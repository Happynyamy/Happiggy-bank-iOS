//
//  NewNoteDatePickerViewController.swift
//  Happiggy-bank
//
//  Created by sun on 2022/03/10.
//

import UIKit

import SnapKit
import Then

// FIXME: - 다른 앱 갔다 오면 선택 시 색깔 바꾼 게 사라짐
/// 새로운 쪽지를 추가하기 위한 날짜 피커 뷰를 관리하는 뷰 컨트롤러
final class NewNoteDatePickerViewController: UIViewController {

    // MARK: - Enum

    enum Parent {
        case home
        case noteInput
    }

    private enum Section: Int, CaseIterable {
        case main
    }


    // MARK: - Properties

    private let rootView = NewNoteDatePickingView()
    
    /// 날짜 피커에서 필요한 형태로 데이터를 변환해주는 뷰모델
    private let viewModel: NewNoteDatePickerViewModel
    
    /// 부모 컨트롤러에 따라 내비게이션 방향 설정
    private let parentType: Parent
    
    /// 경고 라벨 애니메이션을 위해 필요
    private var showWarningLabel = false


    // MARK: - Inits

    init(viewModel: NewNoteDatePickerViewModel, parent: Parent) {
        self.viewModel = viewModel
        self.parentType = parent

        super.init(nibName: nil, bundle: nil)
        self.hidesBottomBarWhenPushed = true
        self.view.backgroundColor = AssetColor.subGrayBG
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    // MARK: - Life Cycle

    override func loadView() {
        self.view = self.rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureNavigationBar()
        self.observe(
            selector: #selector(viewWillEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        self.rootView.datePicker.delegate = self
        self.scrollToInitialPosition()
    }

    // FIXME: 다른 방법 찾아보기..
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        guard self.parentType == .home
        else { return }

        self.fadeInWarningLabel()
    }


    // MARK: - @objc

    /// 다시 앱으로 돌아왔을 때 호출
    @objc private func viewWillEnterForeground() {
        self.restoreTintColorAndWarningLabelStatus()
    }


    // MARK: - Configuration Functions

    private func configureNavigationBar() {
        let cancelButton = UIBarButtonItem(
            image: AssetImage.xmark,
            primaryAction: .init { [weak self] _ in
                self?.navigationController?.popViewControllerWithFade()
            }
        )
        let showNoteInputView = UIAction { [weak self] _ in
            guard let row = self?.rootView.datePicker.selectedRow(inComponent: Section.main.rawValue),
                  self?.viewModel.selectedDateIsAvailable(for: row) == true,
                  let date = self?.viewModel.selectedDate
            else {
                /// 이미 작성한 날짜를 선택한 상태에서 오른쪽 버튼을 누르는 경우 햅틱 알림
                HapticManager.instance.notification(type: .error)
                return
            }

            self?.viewModel.newNote.date = date
            if self?.parentType == .noteInput {
                /// 부모가 쪽지 작성 컨트롤러인 경우 기존 컨트롤러로 되돌아감
                self?.navigationController?.popViewControllerWithFade()
            } else if self?.parentType == .home,
                      let newNote = self?.viewModel.newNote,
                      let controllers = self?.navigationController?.viewControllers.dropLast() {

                /// 부모가 홈 컨트롤러인 경우 쪽지 작성 컨트롤러를 생성해서 푸시
                let noteInputViewController = NewNoteInputViewController(
                    viewModel: .init(newNote: newNote)
                )

                self?.fadeIn()
                self?.navigationController?.setViewControllers(controllers + [noteInputViewController], animated: false)
            }
        }

        let checkButton = UIBarButtonItem(image: AssetImage.checkmark, primaryAction: showNoteInputView)

        self.navigationItem.setLeftBarButton(cancelButton, animated: true)
        self.navigationItem.setRightBarButton(checkButton, animated: true)
    }

    /// 날짜를 "2022 02.05  금" 형태의 문자열로 월, 일만 볼드 처리해서 변환
    func attributedDateString(
        forLabel label: BaseLabel,
        source: NoteDatePickerData,
        isSelected: Bool
    ) -> NSMutableAttributedString {
        let customFont = (label.customFont ?? .current)
        let fontSize = label.font.pointSize
        let font = UIFont(name: customFont.regular, size: fontSize) ?? .systemFont(ofSize: fontSize)
        let boldFont = UIFont(name: customFont.bold, size: fontSize) ?? .boldSystemFont(ofSize: fontSize)
        let color = (isSelected && source.color == nil) ?  AssetColor.mainGreen : .label

        return source.date
            .customFormatted(type: .spaceAndDotWithDayOfWeek)
            .nsMutableAttributedStringify()
            .color(color: color ?? .systemGreen)
            .font(font)
            .bold(font: boldFont, targetString: source.date.monthDotDayWithDayOfWeekString)
    }
    
    /// 오늘 날짜 혹은 이전에 선택한 날짜로 스크롤
    private func scrollToInitialPosition() {
        let row = self.viewModel.initialRow
        guard let noteData = self.viewModel.noteData[safe: row]
        else {
            return
        }

        self.rootView.datePicker.selectRow(row, inComponent: Section.main.rawValue, animated: false)
        self.updateSelectedRowView(
            self.rootView.datePicker,
            forRow: row,
            forComponent: .zero,
            noteData: noteData
        )
    }
    
    /// 경고 라벨 나타내는 메서드
    private func fadeInWarningLabel() {
        self.rootView.warningLabel.fadeIn()
        self.showWarningLabel = true
    }
    
    /// 선택된 행의 글자 색깔 업데이트: 작성 가능한 경우 파랑, 불가능한 경우 회색
    private func updateSelectedRowView(
        _ pickerView: UIPickerView,
        forRow row: Int,
        forComponent component: Int,
        noteData: NoteDatePickerData
    ) {
        guard let rowView = pickerView.view(forRow: row, forComponent: component)
                as? NewNoteDatePickerRowView
        else { return }

        rowView.dateLabel.attributedText = self.attributedDateString(
            forLabel: rowView.dateLabel,
            source: noteData,
            isSelected: true
        )
    }
    
    /// 이전 상태와 같게 틴트 컬러 및 경고 라벨 상태 복구
    private func restoreTintColorAndWarningLabelStatus() {
        let selectedRow = self.rootView.datePicker.selectedRow(inComponent: Section.main.rawValue)

        guard let noteDatePickerData = self.viewModel.noteData[safe: selectedRow],
            let rowView = self.rootView.datePicker.view(
            forRow: selectedRow,
            forComponent: Section.main.rawValue
        ) as? NewNoteDatePickerRowView
        else {
            return
        }
        
        /// 선택 가능하면 틴트컬러 적용
        rowView.dateLabel.attributedText = self.attributedDateString(
            forLabel: rowView.dateLabel,
            source: noteDatePickerData,
            isSelected: true
        )
        
        guard noteDatePickerData.color != nil
        else {
            return
        }
        
        /// 선택 불가능하면 경고 라벨
        self.fadeInWarningLabel()
    }
}


// MARK: - UIPickerViewDataSource
extension NewNoteDatePickerViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        Section.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        self.viewModel.numberOfRows
    }
}


// MARK: - UIPickerViewDelegate
extension NewNoteDatePickerViewController: UIPickerViewDelegate {
    
    func pickerView(
        _ pickerView: UIPickerView,
        viewForRow row: Int,
        forComponent component: Int,
        reusing view: UIView?
    ) -> UIView {

        guard let noteData = self.viewModel.noteData[safe: row]
        else {
            return UIView()
        }

        let rowView = view as? NewNoteDatePickerRowView ?? NewNoteDatePickerRowView()
        
        /// 데이터에 맞게 행의 모습(날짜 라벨 텍스트와 쪽지 이미지 색깔) 업데이트
        rowView.dateLabel.attributedText = self.attributedDateString(
            forLabel: rowView.dateLabel,
            source: noteData,
            isSelected: false
        )
        rowView.noteImageView.image = self.viewModel.image(for: noteData)
    
        return rowView
    }
    
    func pickerView(
        _ pickerView: UIPickerView,
        didSelectRow row: Int,
        inComponent component: Int
    ) {
        guard let noteData = self.viewModel.noteData[safe: row]
        else {
            return
        }
        
        self.updateSelectedRowView(
            pickerView,
            forRow: row,
            forComponent: component,
            noteData: noteData
        )

        guard self.viewModel.selectedDateIsAvailable(for: row)
        else {
            /// 이미 작성한 날짜면 경고 라벨 띄우고 버튼 회색 처리
            self.fadeInWarningLabel()
            return
        }
        
        self.viewModel.selectedDate = noteData.date

        guard self.showWarningLabel
        else { return }
        
        self.rootView.warningLabel.fadeOut()
        self.showWarningLabel = false
    }
}

//
//  NoteListViewController.swift
//  Happiggy-bank
//
//  Created by sun on 2022/03/13.
//

import UIKit

/// 개봉한 저금통의 쪽지를 확인할 수 있는 쪽지 리스트(테이블뷰)를 관리하는 뷰 컨트롤러
final class NoteListViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    /// 쪽지 개수를 나타내는 라벨
    @IBOutlet weak var noteCountLabel: UILabel!
    
    /// 전체 쪽지 개봉 버튼
    @IBOutlet weak var openAllNotesButton: CapsuleButton!
    
    /// 리스트를 나타낼 테이블 뷰
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Properties
    
    /// 리스트에 나타낼 쪽지 데이터를 담고 있는 뷰모델
    var viewModel: NoteListViewModel!
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerNoteCell()
        self.configureNavigationBar()
        self.configureNoteCountLabel()
        self.configureOpenAllNotesButton()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        PersistenceStore.shared.save()
    }
    
    // MARK: - @IBActions
    
    /// 전체 개봉 버튼을 눌렀을 때 호출되는 메서드
    @IBAction func openAllNotesButtonDidTap(_ sender: CapsuleButton) {
        self.showOpenAllNotesConfirmAlert()
    }
    
    
    // MARK: - Function
    
    /// 재사용 가능한 note cell 등록
    private func registerNoteCell() {
        let nib = UINib(nibName: NoteCell.name, bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: NoteCell.name)
    }
    
    /// 내비게이션 투명화, 제목 설정
    private func configureNavigationBar() {
        self.navigationItem.title = self.viewModel.bottleTitle
        
        guard let navigationBar = self.navigationController?.navigationBar
        else { return }
        
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
    }
    
    /// 전체 쪽지 개수 라벨 모습 설정
    private func configureNoteCountLabel() {
        self.noteCountLabel.text = self.viewModel.noteCountLabelString
    }
    
    /// 모든 쪽지가 개봉되었으면 숨김 처리
    private func configureOpenAllNotesButton() {
        guard self.viewModel.allNotesAreOpen
        else { return }
        
        // TODO: FadeOut 으로 대체할 것
        UIView.animate(withDuration: 0.2) {
            self.openAllNotesButton.alpha = .zero
        } completion: { _ in
            self.openAllNotesButton.isHidden = true
        }
    }
    
    /// 쪽지 전체 개봉 의사를 재확인하는 알림을 띄움
    private func showOpenAllNotesConfirmAlert() {
        let alert = self.makeConfirmAlert()
        self.present(alert, animated: true)
    }
    
    /// 쪽지 전체 개봉 의사를 재확인하는 알림 생성
    private func makeConfirmAlert() -> UIAlertController {
        let alert = UIAlertController(
            title: StringLiteral.alertTitle,
            message: nil,
            preferredStyle: .alert
        )
        
        let confirmAction = UIAlertAction(
            title: StringLiteral.confirmButtonTitle,
            style: .default,
            handler: { _ in self.openAllNotes() }
        )
        
        let cancelAction = UIAlertAction(
            title: StringLiteral.cancelButtonTitle,
            style: .cancel,
            handler: nil
        )
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        return alert
    }
    
    /// 모든 쪽지를 개봉하는 메서드
    private func openAllNotes() {
        
        let enumeratedUnopenNotes = self.viewModel.enumeratedUnopenNotes
        let unopenIndexPaths = enumeratedUnopenNotes.map {
            IndexPath(row: $0.offset, section: .zero)
        }
        enumeratedUnopenNotes.forEach { $0.element.isOpen.toggle() }
        
        let visibleUnopenRows =  unopenIndexPaths.filter {
            self.tableView.indexPathsForVisibleRows?.contains($0) == true
        }
        self.openNoteWithAnimation(rowsAtIndexPaths: visibleUnopenRows)
        self.configureOpenAllNotesButton()
    }
    
    /// 현재 화면에 나타나 있는 쪽지를 애니메이션 효과와 함께 개봉하고, completion 으로 데이터 리로드
    private func openNoteWithAnimation(rowsAtIndexPaths indexPaths: [IndexPath]) {

        let noteCells = indexPaths.compactMap { self.tableView.cellForRow(at: $0) as? NoteCell }
        
        /// 차례대로 개봉되는 것처럼 보이도록 딜레이 설정
        var animationDelay: TimeInterval = .zero
    
        for (indexPath, noteCell)  in zip(indexPaths, noteCells) {
            
            if noteCell == noteCells.last {
                noteCell.completion = { _ in self.tableView.reloadData() }
            }
            
            noteCell.animationDelay = animationDelay
            animationDelay += Metric.animationDelay
            self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            self.tableView.deselectRow(at: indexPath, animated: false)
        }
    }
}


// MARK: - UITableViewDataSource

extension NoteListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.notes.count
    }
    
    // swiftlint:disable force_cast
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: NoteCell.name,
            for: indexPath
        ) as! NoteCell
        
        let note = self.viewModel.notes[indexPath.row]
        
        self.clearCell(cell: cell)
        self.configureNoteImageView(cell: cell, note: note)
        self.configureContents(cell: cell, note: note)

        return cell
    }
    // swiftlint:enable force_cast
    
    /// 셀 재사용 시 이전에 설정했던 속성들 리셋
    private func clearCell(cell: NoteCell) {
        cell.frontDateLabel.attributedText = nil
        cell.backDateLabel.attributedText = nil
        cell.contentLabel.text = nil
        cell.noteImageView.image = UIImage()
        cell.animationDelay = .zero
    }
    
    /// 쪽지의 색깔에 맞게 배경/이미지 업데이트
    private func configureNoteImageView(cell: NoteCell, note: Note) {
        cell.noteImageView.image = self.viewModel.image(for: note)
    }
    
    /// 쪽지 내용 라벨들 내용 업데이트
    private func configureContents(cell: NoteCell, note: Note) {
        /// 내용 입력
        cell.frontDateLabel.attributedText = self.viewModel.attributedDateString(for: note)
        cell.backDateLabel.attributedText = self.viewModel.attributedDateString(for: note)
        cell.contentLabel.text = note.content
        
        /// 개봉 여부에 따라 숨김 처리
        cell.frontDateLabel.isHidden = note.isOpen
        cell.backDateLabel.isHidden = !note.isOpen
        cell.contentLabel.isHidden = !note.isOpen
    }
}


// MARK: - UITableViewDelegate

extension NoteListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Metric.cellHeight
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard indexPath.row >= .zero,
              indexPath.row < self.viewModel.numberOfTotalNotes
        else { return nil }
        
        /// 이미 개봉되었으면 다시 누르는 것 방지
        let note = self.viewModel.notes[indexPath.row]
        return note.isOpen ? nil : indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row >= .zero,
              indexPath.row < self.viewModel.numberOfTotalNotes
        else { return }

        let note = self.viewModel.notes[indexPath.row]
        note.isOpen.toggle()
        /// 최초 개봉 애니메이션이 스크롤할 떄 마다 다시 나타나는 것 방지
        tableView.deselectRow(at: indexPath, animated: false)
        self.configureOpenAllNotesButton()
    }
}

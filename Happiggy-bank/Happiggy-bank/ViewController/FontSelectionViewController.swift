//
//  FontSelectionViewController.swift
//  Happiggy-bank
//
//  Created by sun on 2022/04/22.
//

import UIKit

/// 폰트 선택 뷰 컨트롤러
final class FontSelectionViewController: UIViewController {
    
    // MARK: - @IBOutlets
    
    /// 폰트 이름 라벨
    @IBOutlet weak var fontNameLabel: UILabel!
    
    /// 폰트 예시 라벨
    @IBOutlet weak var exampleLabel: UILabel!
    
    /// 폰트 영문 예시 라벨
    @IBOutlet weak var englishExampleLabel: UILabel!
    
    /// 폰트 종류가 나열된 테이블뷰
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: Properties
    
    /// UserDefaults.standard 를 호출하는 syntactic sugar
    private let userdefaults = UserDefaults.standard
    
    /// 유저티폴트에서 유저가 설정한 폰트를 불러오는 키값
    private let fontKey = UserDefaults.Key.font.rawValue
    
    /// 현재 커스텀 폰트
    private var currentFont: CustomFont {
        guard let rawValue = self.userdefaults.value(forKey: self.fontKey) as? Int
        else { return .system }
        
        return CustomFont.init(rawValue: rawValue) ?? .system
    }
    
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerCell()
        self.configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.toggleTabBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.toggleTabBar()
    }
    
    
    // MARK: - Functions
    
    /// 테이블뷰 셀 등록
    private func registerCell() {
        let nib = UINib(nibName: FontSelectionCell.name, bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: FontSelectionCell.name)
    }
    
    /// 뷰 초기 설정
    private func configureView() {
        self.tableView.layer.cornerRadius = Metric.tableViewCornerRadius
        self.fontNameLabel.text = self.currentFont.displayName
        self.configureParagraphStyle(forLabel: self.fontNameLabel)
        self.configureParagraphStyle(forLabel: self.exampleLabel)
        self.configureParagraphStyle(forLabel: self.englishExampleLabel)
    }
    
    /// 라벨 자간 설정
    private func configureParagraphStyle(forLabel label: UILabel) {
        label.configureParagraphStyle(
            lineSpacing: Metric.lineSpacing,
            characterSpacing: Metric.characterSpacing
        )
    }
    
    /// 탭바 숨김 여부 토글
    private func toggleTabBar() {
        self.tabBarController?.tabBar.isHidden.toggle()
    }
}


// MARK: - UITableViewDataSource
extension FontSelectionViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        CustomFont.allCases.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: FontSelectionCell.name,
            for: indexPath
        ) as? FontSelectionCell,
              let currentCellFont = CustomFont(rawValue: indexPath.row)
        else { return FontSelectionCell() }
        
        cell.fontNameLabel.attributedText = currentCellFont
            .displayName
            .nsMutableAttributedStringify()
        cell.fontNameLabel.font = UIFont(
            name: currentCellFont.regular,
            size: cell.fontNameLabel.font.pointSize
        )
        
        guard self.userdefaults.value(forKey: self.fontKey) as? Int == indexPath.row
        else { return cell }
        
        cell.fontNameLabel.boldAndColor()
        cell.checkmarkImageView.isHidden = false
        
        return cell
    }
}


// MARK: - UITableViewDelegate
extension FontSelectionViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        guard let selectedfont = CustomFont(rawValue: indexPath.row),
              selectedfont != self.currentFont
        else { return }
        
        HapticManager.instance.selection()
        self.updateFontAccordingToSelection(font: selectedfont, indexPath: indexPath)
        self.updateExamplesAccordingToSelctedFont(selectedfont)
        self.updateCellsAccordingToSelection(inTableView: tableView, selectedIndexPath: indexPath)
    }
    
    /// 예시 라벨들 폰트 업데이트
    private func updateExamplesAccordingToSelctedFont(_ font: CustomFont) {
        self.fontNameLabel.text = font.displayName
        self.fontNameLabel.changeFont(to: font.bold)
        self.exampleLabel.changeFont(to: font.regular)
        self.englishExampleLabel.changeFont(to: font.regular)
    }
    
    /// 유저의 새로운 선택에 따라 테이블뷰 모습 업데이트
    private func updateCellsAccordingToSelection(
        inTableView tableview: UITableView,
        selectedIndexPath indexPath: IndexPath
    ) {
        for row in Int.zero..<tableView.numberOfRows(inSection: .zero) {
            let currentIndexPath = IndexPath(row: row, section: .zero)
            
            guard let cell = tableView.cellForRow(at: currentIndexPath) as? FontSelectionCell
            else { continue }
            
            cell.checkmarkImageView.isHidden = (currentIndexPath != indexPath)
            guard currentIndexPath == indexPath
            else {
                cell.fontNameLabel.attributedText = cell.fontNameLabel.text?
                    .nsMutableAttributedStringify()
                continue
            }
            cell.fontNameLabel.boldAndColor()
        }
    }
    
    /// 커스텀 폰트 변경
    private func updateFontAccordingToSelection(font: CustomFont, indexPath: IndexPath) {
        self.userdefaults.set(indexPath.row, forKey: self.fontKey)
        self.post(name: .customFontDidChange, object: font)
    }
}

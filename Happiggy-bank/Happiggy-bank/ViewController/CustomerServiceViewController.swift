//
//  CustomerServiceViewController.swift
//  Happiggy-bank
//
//  Created by sun on 2022/04/20.
//

import MessageUI
import UIKit

/// 고객 지원 뷰 컨트롤러
final class CustomerServiceViewController: UIViewController {
    
    // MARK: - @IBOutlets
    
    /// 고객 지원 각 항목을 담고 있는 테이블 뷰
    @IBOutlet weak var tableView: UITableView!
    
    /// 누르면 메일 앱을 띄우는 팀 소개 라벨
    @IBOutlet weak var teamLabel: UIStackView!
    
    
    // MARK: - Properties
    
    private var viewModel = CustomerServiceViewModel()
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerCells()
        self.navigationItem.backButtonTitle = .empty
    }
    
    
    // MARK: - Functions
    
    /// 테이블 뷰 셀 등록
    private func registerCells() {
        self.tableView.register(
            UINib(nibName: SettingsNonIconButtonCell.name, bundle: nil),
            forCellReuseIdentifier: SettingsNonIconButtonCell.name
        )
    }
}


// MARK: - MFMailComposeViewControllerDelegate
/// 메일 관련 메서드, 프로퍼티
extension CustomerServiceViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(
        _ controller: MFMailComposeViewController,
        didFinishWith result: MFMailComposeResult,
        error: Error?
    ) {
        controller.dismiss(animated: true)
    }
}


// MARK: - UITableViewDataSource
extension CustomerServiceViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.numberOfRowsInSection
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        self.labelButtonCell(inTableView: tableView, indexPath: indexPath)
    }
    
    /// 라벨 버튼 셀 모습 설정
    private func labelButtonCell(
        inTableView tableView: UITableView,
        indexPath: IndexPath
    ) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SettingsNonIconButtonCell.name,
            for: indexPath
        ) as? SettingsNonIconButtonCell
        else { return SettingsNonIconButtonCell() }
        
        cell.titleLabel.text = self.viewModel.title(forContentAt: indexPath)
        
        return cell
    }
}


// MARK: - UITableViewDelegate
extension CustomerServiceViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        guard let destination = self.viewModel.destination(forContentAt: indexPath, delegate: self)
        else { return }
        
        HapticManager.instance.selection()

        guard let alert = destination as? UIAlertController
        else {
            self.show(destination, sender: self)
            return
        }
        
        self.present(alert, animated: true)
    }
}

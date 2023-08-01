//
//  SettingsViewController.swift
//  Happiggy-bank
//
//  Created by sun on 2022/03/22.
//

import Combine
import UIKit

import Then

/// 환경 설정 뷰 컨트롤러
final class SettingsViewController: UIViewController {

    // MARK: - Properties

    private let tableView = UITableView().then {
        $0.rowHeight = Metric.rowHeight
        $0.separatorStyle = .none
        $0.isScrollEnabled = false
        $0.showsVerticalScrollIndicator = false
    }
    private let viewModel: SettingsViewModel
    private var cancellable: AnyCancellable?


    // MARK: - Init(s)

    init(versionManager: any VersionChecking, fontManager: FontManaging) {
        self.viewModel = SettingsViewModel(versionManager: versionManager, fontManager: fontManager)

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - Life Cycle

    override func loadView() {
        self.view = self.tableView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureNavigationBar()
        self.configureTableView()
        self.subscribeToFontPublisher()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.subscribeToVersionManager()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.viewModel.versionManager.removeSubscriber(self)
    }


    // MARK: - Configuration Functions

    private func subscribeToFontPublisher() {
        self.cancellable = self.viewModel.fontManager.fontPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in self?.tableView.reloadData() }
    }

    /// 내비게이션 바 초기 설정
    private func configureNavigationBar() {
        self.navigationItem.backButtonTitle = .empty
        self.navigationController?.navigationBar.clear()
        self.navigationItem.title = StringLiteral.navigationTitle
    }

    /// 테이블 뷰 셀 등록, datsource, delegate 설정
    private func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(
            SettingsTableViewButtonCell.self,
            forCellReuseIdentifier: SettingsTableViewButtonCell.name
        )
    }

    private func subscribeToVersionManager() {
        let indexPath = IndexPath(row: SettingsViewModel.RowType.version.rawValue, section: .zero)
        self.viewModel.versionManager.addSubscriber(self) { [weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.reloadRows(at: [indexPath], with: .none)
            }
        }
    }
}


// MARK: - UITableViewDataSource
extension SettingsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.numberOfRows
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: SettingsTableViewButtonCell.name,
            for: indexPath
        ) as? SettingsTableViewButtonCell ?? SettingsTableViewButtonCell()

        cell.icon = self.viewModel.icon(for: indexPath)
        cell.title = self.viewModel.title(for: indexPath)
        cell.buttonTitle = self.viewModel.buttonTitle(for: indexPath)
        cell.buttonImage = self.viewModel.buttonImage(for: indexPath)
        cell.buttonTextColor = self.viewModel.buttonTitleColor(for: indexPath)

        return cell
    }
}


// MARK: - UITableViewDelegate
extension SettingsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let rowType = self.viewModel.rowType(for: indexPath)
        else {
            return
        }

        // TODO: 항목별 컨트롤러 구현 후 삭제
        let tempVC = UIViewController().then { $0.view.backgroundColor = .systemBackground }

        switch rowType {
        case .alert:
            self.show(NotificationSettingViewController(), sender: self)
        case .version:
            self.openAppStoreIfNeeded()
            return
        case .font:
            self.show(FontSelectionViewController(fontManager: self.viewModel.fontManager), sender: self)
        case .customerService:
            self.show(tempVC, sender: self)
        }

        HapticManager.instance.selection()
    }

    private func openAppStoreIfNeeded() {
        self.openAppStore { [weak self] didOpen in
            guard !didOpen,
                  let selfUpdateAlert = self?.selfUpdateAlert
            else {
                return
            }

            self?.present(selfUpdateAlert, animated: true)
        }
    }
}


// MARK: - Constants
fileprivate extension SettingsViewController {

    enum Metric {
        static let rowHeight: CGFloat = 67
    }

    enum StringLiteral {
        static let navigationTitle = "환경설정"
    }
}

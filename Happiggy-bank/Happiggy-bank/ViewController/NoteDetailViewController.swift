//
//  NoteDetailViewController.swift
//  Happiggy-bank
//
//  Created by sun on 2022/03/30.
//

import UIKit

/// 쪽지 디테일 뷰 컨트롤러로 캐러셀 뷰 구현을 위해 컬렉션 뷰 사용
final class NoteDetailViewController: UIViewController {

    // MARK: - @IBOutlets

    @IBOutlet weak var tableView: UITableView!


    // MARK: - Properties

    var viewModel: NoteDetailViewModel!


    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureNavitationBar()
        self.registerCells()
        self.configureTableView()
    }


    // MARK: - Configuration Functions

    private func configureNavitationBar() {
        self.navigationItem.title = self.viewModel.bottleTitle
    }

    /// 셀 등록
    private func registerCells() {
        self.tableView.register(NoteCell.self, forCellReuseIdentifier: NoteCell.name)
        self.tableView.register(PhotoNoteCell.self, forCellReuseIdentifier: PhotoNoteCell.name)
    }

    /// datasource 설정 및 초기 위치로 스크롤
    private func configureTableView() {
        self.tableView.dataSource = self
        let indexPath = IndexPath(row: self.viewModel.selectedIndex, section: .zero)
        self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .top)
    }

}


// MARK: - UITableViewDataSource
extension NoteDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.noteViewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row

        guard row >= .zero, row < self.viewModel.noteViewModels.count
        else { return UITableViewCell() }

        let viewModel = self.viewModel.noteViewModels[indexPath.row]

        if viewModel.photo == nil {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: NoteCell.name,
                for: indexPath
            ) as? NoteCell
            else { return UITableViewCell() }

            cell.viewModel = viewModel
            return cell
        }

        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: PhotoNoteCell.name,
                for: indexPath
            ) as? PhotoNoteCell
        else { return UITableViewCell() }

        cell.viewModel = viewModel
        return cell
    }
}

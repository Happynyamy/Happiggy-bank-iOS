//
//  NoteDetailViewController.swift
//  Happiggy-bank
//
//  Created by sun on 2022/03/30.
//

import UIKit

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
        self.navigationItem.backButtonTitle = .empty
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

        if !viewModel.hasPhoto {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: NoteCell.name,
                for: indexPath
            ) as? NoteCell
            else { return UITableViewCell() }

            viewModel.photoDidTap = nil
            cell.viewModel = viewModel
            return cell
        }

        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: PhotoNoteCell.name,
                for: indexPath
            ) as? PhotoNoteCell
        else { return UITableViewCell() }

        viewModel.photoDidTap = { [weak self] image in
            let photoViewController = PhotoViewController(photo: image)
//            photoViewController.view.backgroundColor = .systemBackground
            self?.show(photoViewController, sender: self)
        }
        cell.viewModel = viewModel
        return cell
    }
}

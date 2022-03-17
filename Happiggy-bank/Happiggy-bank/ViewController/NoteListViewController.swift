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
    
    /// 리스트를 나타낼 테이블 뷰
    @IBOutlet var tableView: UITableView!
    
    
    // MARK: - Properties
    
    /// 리스트에 나타낼 쪽지 데이터를 담고 있는 뷰모델
    var viewModel: NoteListViewModel!

    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerNoteCell()
        self.navigationItem.title = self.viewModel.bottleTitle
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    // MARK: - Function
    
    /// 재사용 가능한 note cell 등록
    private func registerNoteCell() {
        let nib = UINib(nibName: NoteCell.name, bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: NoteCell.name)
    }
    
    // TODO: 전체 개봉 버튼 구현
    /// 모든 쪽지를 개봉하는 메서드
    private func openAllNotes() {
        var newlyOpenedNoteIndexPaths = [IndexPath]()
        
        for (index, note) in self.viewModel.notes.enumerated() {
            guard !note.isOpen
            else { return }
            
            note.isOpen.toggle()
            newlyOpenedNoteIndexPaths.append(IndexPath(row: index, section: .zero))
        }
        
        // TODO: check if this calls tableview(didSelect:) (it needs to!)
        self.tableView.indexPathsForVisibleRows?
            .filter { newlyOpenedNoteIndexPaths.contains($0) }
            .forEach { self.tableView.selectRow(at: $0, animated: false, scrollPosition: .none)
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
        // TODO: activate core data saving
//        PersistenceStore.shared.save()
        /// 최초 개봉 애니메이션이 스크롤할 떄 마다 다시 나타나는 것 방지
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

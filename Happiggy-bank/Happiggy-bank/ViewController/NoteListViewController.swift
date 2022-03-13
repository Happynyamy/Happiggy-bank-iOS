//
//  NoteListViewController.swift
//  Happiggy-bank
//
//  Created by sun on 2022/03/13.
//

import UIKit

/// 개봉한 저금통의 쪽지를 확인할 수 있는 쪽지 리스트(테이블뷰)를 관리하는 뷰 컨트롤러
class NoteListViewController: UIViewController {
    
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
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
    
    /// 쪽지의 색깔에 맞게 배경/이미지 업데이트
    private func configureNoteImageView(cell: NoteCell, note: Note) {
        cell.noteImageView.backgroundColor = UIColor.note(color: note.color)
        
        /// 흰색이면 외곽선 표현
        if note.color == .white {
            cell.noteImageView.layer.borderWidth = Metric.noteImageViewBorderWidth
            cell.noteImageView.layer.borderColor = UIColor.highlight(color: note.color).cgColor
        }
    }
    
    /// 셀 재사용 시 이전에 설정했던 속성들 리셋
    private func clearCell(cell: NoteCell) {
        cell.frontDateLabel.attributedText = nil
        cell.backDateLabel.attributedText = nil
        cell.contentLabel.text = nil
        cell.noteImageView.backgroundColor = nil
        cell.noteImageView.layer.borderWidth = .zero
        cell.noteImageView.layer.borderColor = .none
        
    }
    
    /// 개봉 여부에 따라 앞면 혹은 뒷면으로 나타나도록 설정
    private func configureContents(cell: NoteCell, note: Note) {
        /// 내용 입력
        cell.frontDateLabel.attributedText = self.viewModel.attributedDateString(for: note)
        cell.backDateLabel.attributedText = self.viewModel.attributedDateString(for: note)
        cell.contentLabel.text = note.content
        
        /// 개봉 여부에 따라 숨김 처리
        cell.frontDateLabel.isHidden = note.isOpen
        cell.contentLabel.isHidden = !note.isOpen
        cell.backDateLabel.isHidden = !note.isOpen
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
        
        // FIXME: 일단 개발 시 편의를 위해 토글로 둠
        /// 이미 개봉되었으면 다시 누르는 것 방지
//        let note = self.viewModel.notes[indexPath.row]
//        return note.isOpen ? nil : indexPath
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row >= .zero,
              indexPath.row < self.viewModel.numberOfTotalNotes
        else { return }
        
        /// 쪽지를 개봉하고 뷰를 다시 로드해서 반영
        let note = self.viewModel.notes[indexPath.row]
        note.isOpen.toggle()
        // TODO: activate core data saving
//        PersistenceStore.shared.save()
        // 그냥 두면 심심하니까...일단 아무거나 제 눈에 괜찮아보이는 애니메이션 넣었어요...
        self.tableView.reloadRows(at: [indexPath], with: .top)
    }
}

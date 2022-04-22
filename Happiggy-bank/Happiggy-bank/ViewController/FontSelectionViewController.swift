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
    
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.registerCell()
    }
    
    
    // MARK: - Functions
    
    /// 테이블뷰 셀 등록
    private func registerCell() {
        let nib = UINib(nibName: FontSelectionCell.name, bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: FontSelectionCell.name)
    }
}


// MARK: - UITableViewDataSource
extension FontSelectionViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        CustomFont.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: FontSelectionCell.name,
            for: indexPath
        ) as? FontSelectionCell
        else { return FontSelectionCell() }
        
        // TODO: configure cell
        
        return cell
    }
}


// MARK: - UITableViewDelegate
extension FontSelectionViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        // TODO: update selection
    }
}

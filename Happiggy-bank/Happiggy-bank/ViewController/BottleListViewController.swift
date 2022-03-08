//
//  BottleListViewController.swift
//  Happiggy-bank
//
//  Created by 권은빈 on 2022/02/28.
//

import UIKit

import Then

/// 유리병 리스트 뷰 컨트롤러
final class BottleListViewController: UIViewController {
    
    // MARK: Properties
    
    // TODO: View Model로 이동
    /// 유리병 리스트(임시)
    lazy var bottleList: [Bottle] = {
        var bottles = [Bottle]()
        
        for index in 0...3 {
            // FIXME: 코어데이터 엔티티 생성하면서 주석 처리 및 밑에 일단 임시 인스턴스 생성
//            let bottle = Bottle(id: index, title: "bottle \(index)", date: "2022.01.01 ~ 2022.01.31")
            let bottle = Bottle(title: "유리병 \(index + 1)", startDate: Date(), endDate: Date())
            bottles.append(bottle)
        }
        
        return bottles
    }()
    
    /// 유리병 리스트 테이블 뷰
    lazy var tableView = UITableView().then {
        $0.frame = CGRect(
            x: 0,
            y: 0,
            width: UIScreen.main.bounds.width,
            height: UIScreen.main.bounds.height
        )
        $0.backgroundColor = UIColor(hex: Color.tableViewBackground)
        $0.separatorStyle = .none
        $0.rowHeight = Metric.tableViewRowHeight
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    /// 유리병 리스트가 빈 경우 표시하는 라벨
    lazy var emptyListLabel = UILabel().then {
        $0.text = StringLiteral.emptyListLabelTitle
        $0.font = .systemFont(ofSize: FontSize.emptyListLabelTitle)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureTableView()
        configureViewHierarchy()
        hideEmptyListLabelIfNeeded()
        configureConstraints()
    }
    
    
    // MARK: View Configuration
    
    /// 내비게이션 바 속성 설정
    private func configureNavigationBar() {
        self.navigationController?.navigationBar.tintColor = UIColor(hex: Color.navigationBar)
        self.title = bottleList.isEmpty ?
        StringLiteral.emptyListNavigationBarTitle :
        StringLiteral.fullListNavigationBarTitle
    }
    
    /// 테이블 뷰 속성 설정
    private func configureTableView() {
        self.tableView.register(BottleCell.self, forCellReuseIdentifier: "BottleCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    /// 뷰 계층 설정
    private func configureViewHierarchy() {
        self.view.addSubview(tableView)
        self.tableView.addSubview(emptyListLabel)
    }
    
    /// 유리병 리스트가 차있는 경우, 테이블뷰에 표시되는 라벨 감추기
    private func hideEmptyListLabelIfNeeded() {
        if !bottleList.isEmpty {
            self.emptyListLabel.isHidden = true
        }
    }
    
    
    // MARK: Constraints
    /// Constraints 메서드 호출하는 함수
    private func configureConstraints() {
        configureTableViewConstraints()
        configureEmptyListLabelConstraints()
    }
    
    /// 테이블 뷰 Constraints
    private func configureTableViewConstraints() {
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    /// 유리병이 빈 경우 표시되는 라벨 Constraints
    private func configureEmptyListLabelConstraints() {
        NSLayoutConstraint.activate([
            self.emptyListLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.emptyListLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
}

extension BottleListViewController: UITableViewDataSource {
    
    /// 테이블 뷰의 셀 개수 리턴하는 함수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bottleList.count
    }
    
    // swiftlint:disable force_cast
    /// 셀을 구성하는 함수
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let bottle = bottleList[indexPath.row]
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "BottleCell",
            for: indexPath
        ) as! BottleCell
        
        resetReusableCellAttribute(cell)
        cell.titleLabel.text = bottle.title
        // FIXME: 코어데이터 엔티티 생성하면서 주석 처리
//        cell.dateLabel.text = bottle.startDate.description
        
        return cell
    }
    // swiftlint:enable force_cast
    
    /// 리유저블 셀의 속성 초기화하는 함수
    private func resetReusableCellAttribute(_ cell: BottleCell) {
        cell.titleLabel.text = ""
        cell.dateLabel.text = ""
    }
}

extension BottleListViewController: UITableViewDelegate {
    
    // TODO: GET from server
    // TODO: HomeVC currentIndex update
    /// 특정 행을 선택했을 때 호출되는 함수
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bottleId = bottleList[indexPath.row].id
        print("get bottle data from db with \(bottleId)")
        self.navigationController?.popViewController(animated: true)
    }
}

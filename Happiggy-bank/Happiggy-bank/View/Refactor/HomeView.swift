//
//  HomeView.swift
//  Happiggy-bank
//
//  Created by 권은빈 on 2022/02/17.
//

import UIKit

import SnapKit
import Then

/// BottleViewController의 뷰, InitialImage 뷰를 나타낼 HomeView
final class HomeView: UIView {
    
    // TODO: - 기본 UI 설정을 위한 예시 라벨, 삭제 예정.
    lazy var label: UILabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "Label"
        $0.backgroundColor = AssetColor.mainYellow
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = UIScreen.main.bounds
        self.backgroundColor = AssetColor.subGrayBG
        self.addSubview(label)
        configureLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configureLabel() {
        label.snp.makeConstraints { make in
            make.centerX.equalTo(self.safeAreaLayoutGuide)
            make.centerY.equalTo(self.safeAreaLayoutGuide)
        }
    }
}

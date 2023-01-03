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
    
    /// 저금통 이름. nil일 때 저금통이 없음.
    var title: String?
    
    /// D-day 문자열.
    var dDay: String?
    
    /// 쪽지가 있는지 없는지에 대한 불리언 값
    var hasNotes: Bool = false
    
    /// 저금통이 비어있을 때 나타나는 상단 라벨
    lazy var emptyBottleLabel: UILabel = BaseLabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = StringLiteral.emptyBottleLabelText
        $0.changeFontSize(to: FontSize.headline2)
        $0.boldAndColor()
    }
    
    /// 저금통이 비어있을 때 나타나는 하단 라벨
    lazy var emptyBottleDescription: UILabel = BaseLabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = StringLiteral.emptyBottleDescriptionText
        $0.changeFontSize(to: FontSize.title2)
        $0.color(AssetColor.subBrown02)
    }
    
    /// 저금통이 진행중일 때 나타나는 D-day 라벨
    lazy var dDayLabel: UILabel = BaseLabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "D-365"
        $0.changeFontSize(to: FontSize.headline1)
        $0.boldAndColor()
    }
    
    /// 저금통이 진행중일 때, 쪽지를 추가하지 않았을 때 나타나는 하단 라벨
    lazy var emptyNoteDescription: UILabel = BaseLabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = StringLiteral.emptyNoteDescriptionText
        $0.changeFontSize(to: FontSize.body3)
        $0.color(AssetColor.subBrown02)
    }
    
    /// 저금통이 없거나, 저금통이 진행중이지만 쪽지가 없을 때 나타나는 캐릭터 이미지 뷰
    lazy var imageView: UIImageView = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = AssetImage.homeCharacterInitial
    }
    
    /// 저금통이 진행중일 때 나타나는 저금통 이름 뷰
    lazy var bottleTitleView: UIView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addSubviews([
            self.bottleTitleTag,
            self.bottleTitleStack
        ])
    }
    
    /// 저금통이 진행중일 때 나타나는 저금통 이름 태그 이미지
    lazy var bottleTitleTag: UIImageView = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = AssetImage.tag
    }
    
    /// 저금통이 진행중일 때 나타나는 저금통 이름 스택 뷰
    lazy var bottleTitleStack: BottleTitleStack = BottleTitleStack().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    init(title: String?, dDay: String?, hasNotes: Bool) {
        super.init(frame: .zero)
        self.title = title
        self.dDay = dDay
        self.hasNotes = hasNotes
        configureHomeView()
        configureImageView()
        configureLabels()
        configureBottleTitleView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHomeView()
        configureImageView()
        configureLabels()
        configureBottleTitleView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    /// 홈 뷰 세팅
    private func configureHomeView() {
        self.frame = UIScreen.main.bounds
        self.backgroundColor = AssetColor.subGrayBG
    }
    
    /// 홈 뷰 중간에 있는 캐릭터 이미지 뷰 세팅
    private func configureImageView() {
        if self.title == nil || !self.hasNotes {
            self.addSubview(imageView)
            
            self.imageView.snp.makeConstraints { make in
                make.centerX.equalTo(self.safeAreaLayoutGuide)
                make.centerY.equalTo(self.safeAreaLayoutGuide)
            }
        }
        
        if self.title == nil {
            self.imageView.image = AssetImage.homeCharacter
            return
        }
        if !self.hasNotes {
            self.imageView.image = AssetImage.homeCharacterInitial
            return
        }
    }
    
    /// 라벨 레이아웃 세팅
    private func configureLabels() {
        if self.title == nil {
            self.addSubviews([
                self.emptyBottleLabel,
                self.emptyBottleDescription
            ])
            
            self.emptyBottleLabel.snp.makeConstraints { make in
                make.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).offset(23)
                make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(86)
            }
            
            self.emptyBottleDescription.snp.makeConstraints { make in
                make.leading.equalTo(self.emptyBottleLabel.snp.leading)
                make.top.equalTo(self.emptyBottleLabel.snp.bottom).offset(18)
            }
            
            return
        }
        
        if self.dDay != nil {
            
            self.dDayLabel.text = self.dDay
            
            self.addSubview(dDayLabel)
            
            self.dDayLabel.snp.makeConstraints { make in
                make.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).offset(23)
                make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(70)
            }
        }
        
        if !self.hasNotes {
            self.addSubview(emptyNoteDescription)
            
            self.emptyNoteDescription.snp.makeConstraints { make in
                make.centerX.equalTo(self.safeAreaLayoutGuide.snp.centerX)
                make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-202)
            }
        }
    }
    
    /// 저금통 이름 뷰 및 하위 뷰들 레이아웃 세팅
    private func configureBottleTitleView() {
        guard let bottleTitle = self.title
        else { return }
        
        self.bottleTitleStack.bottleTitleLabel.text = bottleTitle
        
        self.addSubview(self.bottleTitleView)
        
        self.bottleTitleView.snp.makeConstraints { make in
            make.top.equalTo(self.dDayLabel.snp.bottom).offset(4)
        }
        
        self.bottleTitleStack.bottleTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.dDayLabel.snp.leading)
        }
        
        self.bottleTitleTag.snp.makeConstraints { make in
            make.leading.equalTo(self.bottleTitleStack.snp.leading)
            make.trailing.equalTo(self.bottleTitleStack.snp.trailing)
            make.top.equalTo(self.bottleTitleStack.snp.top)
            make.bottom.equalTo(self.bottleTitleStack.snp.bottom)
        }
    }
}

extension HomeView {
    
    /// 문자열
    enum StringLiteral {
        
        /// 저금통이 없는 경우 나타나는 라벨 문자열
        static let emptyBottleLabelText: String = "저금통이 없습니다."
        
        /// 저금통이 없는 경우 나타나는 라벨 문자열
        static let emptyBottleDescriptionText: String = "탭해서 행복저금통을 추가해주세요."
        
        /// 저금통 생성 후 쪽지가 없을 때 나타내는 라벨 문자열
        static let emptyNoteDescriptionText: String = "화면을 탭해서 첫 행복을 작성하세요."
    }
}

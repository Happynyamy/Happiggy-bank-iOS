//
//  Constants.swift
//  Happiggy-bank
//
//  Created by 권은빈 on 2022/02/17.
//

import UIKit

extension HomeViewController {
    
    /// HomeViewController 에서  설정하는 layout 에 적용할 상수값들을 모아놓은 enum
    enum Metric {
        
        /// 뷰 간 간격
        static let spacing: CGFloat = 8
        
        /// BottleView 의 높이/너비 값
        static let pageViewHeightWidthRatio: CGFloat = 480 / 375
        
        /// 좌우 패딩 값
        static let verticalPadding: CGFloat = 24
        
        /// 버튼 높이
        static let buttonHeight: CGFloat = 48
        
        /// 버튼 길이(높이와 동일)
        static let buttonWidth: CGFloat = buttonHeight
        
        // 라벨 높이(버튼 높이와 동일)
        static let labelHeight: CGFloat = buttonHeight
        
        /// noteProgress 라벨 너비
        static let noteProgressLabelWidth: CGFloat = 126
        
        /// list Button의 앞쪽 패딩
        static let listButtonLeadingPadding: CGFloat = 88
    }
}

extension BottleViewController {
    
    /// BottleViewController 에서 설정하는 layout 에 적용할 상수값들을 모아놓은 enum
    enum Metric {
        
        /// TODO: 모든 뷰에서 같으면 전역으로 만들기
        /// 좌우 패딩 값
        static let verticalPadding: CGFloat = HomeViewController.Metric.verticalPadding
    }
}

extension DefaultButton {

    /// HomeViewButton 에서 설정하는 layout에 적용할 상수값
    enum Metric {
        
        /// 버튼 높이
        static let buttonHeight: CGFloat = HomeViewController.Metric.buttonHeight
        
        /// 버튼 너비
        static let buttonWidth: CGFloat = HomeViewController.Metric.buttonWidth
    }
}

extension HomeView {
    
    /// HomeView 에서 설정하는 layout에 적용할 상수값
    enum Metric {
        
        /// 디바이스 스크린 높이
        static let screenHeight: CGFloat = UIScreen.main.bounds.height
        
        /// 디바이스 스크린 너비
        static let screenWidth: CGFloat = UIScreen.main.bounds.width
    }
}

extension CreateNewBottlePopupView {
    
    /// CreateNewBottlePopupView에서 설정하는 layout에 적용할 상수값
    enum Metric {
        /// 팝업 뷰 너비
        static let viewWidth: CGFloat = HomeView.Metric.screenWidth * 0.872
        
        /// 팝업 뷰 높이
        static let viewHeight: CGFloat = 443
        
        /// 팝업 뷰 양 사이드 padding
        static let horizontalPadding: CGFloat = 24
        
        /// 팝업 뷰 제출 버튼  너비
        static let submitButtonWidth: CGFloat = viewWidth - horizontalPadding * 2
        
        /// 팝업 뷰 제출 버튼 높이
        static let submitButtonHeight: CGFloat = 56
        
        /// 팝업 뷰 제출 버튼 위 아래 padding
        static let submitButtonVerticalPadding: CGFloat = 40
    }
}

extension PopupTopBar {
    
    /// PopupTopBar에서 설정하는 layout에 적용할 상수값
    enum Metric {
        
        /// 상단 바 너비
        static let viewWidth: CGFloat
        = CreateNewBottlePopupView.Metric.viewWidth
        - cancelButtonLeadingPadding * 2
        
        /// 상단 바 높이
        static let viewHeight: CGFloat = 64
        
        /// 상단 바 취소 버튼 leading padding 16
        static let cancelButtonLeadingPadding: CGFloat = 16
        
        /// 상단 바 취소 버튼 vertical padding 8
        static let cancelButtonVerticalPadding: CGFloat = 8
        
        /// 상단 바 제목 라벨 top padding 21
        static let titleLabelTopPadding: CGFloat = 21
    }
    
    /// PopupTopBar에서 설정하는 Color
    enum Color {
        
        /// bar 하단 border 색상
        static let bottomBorder: Int = 0xEFEFEF
    }
    
    /// PopupTopBar에서 설정하는 Font Size
    enum FontSize {
        
        /// bar 타이틀 라벨 크기
        static let titleLabel: CGFloat = 17
    }
}

extension PopupTextInputField {
    
    /// PopupTextInputField에서 설정하는 layout에 적용할 상수값
    enum Metric {
        
        /// 유리병 이름 입력 뷰 너비
        static let viewWidth: CGFloat
        = CreateNewBottlePopupView.Metric.viewWidth
        - CreateNewBottlePopupView.Metric.horizontalPadding * 2
        
        /// 유리병 이름 입력 뷰 높이
        static let viewHeight: CGFloat = 90
        
        /// 유리병 이름 입력 뷰 텍스트필드 높이
        static let textFieldHeight: CGFloat = 56
        
        /// 유리병 이름 입력 뷰 top padding 32
        static let topPadding: CGFloat = 32
        
        /// 유리병 이름 입력 뷰 텍스트필드 top padding 16
        static let innerPadding: CGFloat = 16
    }
    
    /// PopupTextInputField에서 사용하는 Color hex값
    enum Color {
        
        /// 플레이스홀더 글자 색상
        static let placeHolder: Int = 0xECA7A7
        
        /// 텍스트필드 배경 색상
        static let textFieldBackground: Int = 0xFFF9F9
    }
    
    /// PopupTextInputField에서 사용하는 Font Size
    enum FontSize {
        
        /// desctiption label 글자 크기
        static let descriptionLabel: CGFloat = 16
        
        /// 플레이스홀더의 글자 크기
        static let placeHolder: CGFloat = 18
    }
}

extension PopupPeriodSelectionField {
    
    /// PopupPeriodSelectionField에서 설정하는 layout에 적용할 상수값
    enum Metric {
        
        /// 유리병 개봉 기간 선택 뷰 너비
        static let viewWidth: CGFloat = PopupTextInputField.Metric.viewWidth
        
        /// 유리병 개봉 기간 선택 뷰 높이
        static let viewHeight: CGFloat = 90

        /// 유리병 개봉 기간 선택 뷰 버튼 높이
        static let buttonHeight: CGFloat = 56
        
        /// 유리병 개봉 기간 선택 뷰 버튼 너비
        static let buttonWidth: CGFloat = 48
        
        /// 유리병 개봉 기간 선택 뷰 top padding 32
        static let topPadding: CGFloat = 32
        
        /// 유리병 개봉 기간 선택 뷰 버튼들 top padding 16
        static let innerPadding: CGFloat = 16
        
        /// 유리병 개봉 기간 선택 뷰 버튼 간 padding 8
        static let buttonPadding: CGFloat = 8
    }
    
    /// PopupPeriodSelectionField에서 설정하는 Color
    enum Color {
        
        /// 선택 버튼 .normal인 경우 border 색상
        static let buttonNormalBorder: Int = 0xD6D6D6
        
        /// 선택 버튼 .normal인 경우 글자 색상
        static let buttonNormalTitle: Int = 0x777777
        
        /// 선택 버튼 .normal인 경우 배경 색상
        static let buttonNormalBackground: Int = 0xFFFFFF
        
        /// 선택 버튼 .selected인 경우 글자 색상
        static let buttonSelectedTitle: Int = 0xFFFFFF
        
        /// 선택 버튼 .selected인 경우 배경 색상
        static let buttonSelectedBackground: Int = 0xF6666C
    }
    
    /// PopupPeriodSelectionField에서 설정하는 Font Size
    enum FontSize {
        
        /// description label 글자 크기
        static let descriptionLabel: CGFloat = 16
    }
}

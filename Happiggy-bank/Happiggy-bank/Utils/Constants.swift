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
        
        /// BottleView 의 높이/너비 값 :
        static let pageViewHeightWidthRatio: CGFloat = 480 / 375
        
        /// 좌우 패딩 값 : 24
        static let verticalPadding: CGFloat = 24
        
        /// 버튼 높이 : 48
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

extension NewNotePopupViewController {
    
    /// NewNotePopupViewController 에서 설정하는 layout 에 적용할 상수값들을 모아놓은 enum
    enum Metric {
        
        /// 상하 패딩 값
        static let verticalPadding: CGFloat = HomeViewController.Metric.verticalPadding
        
        /// 좌우 패딩 값
        static let horizontalPadding: CGFloat = verticalPadding
        
        /// 팝업 뷰 top anchor constraint
        static let popupViewTopAnchor: CGFloat = 120
        
        /// 팝업 뷰 너비, 높이
        static let popupViewSize = CGSize(
            width: UIScreen.main.bounds.width - 2 * verticalPadding,
            height: 438
        )
        
        /// 버튼 너비, 높이
        static let buttonSize = CGSize(
            width: HomeViewController.Metric.buttonWidth,
            height: HomeViewController.Metric.buttonHeight
        )
        
        /// 버튼 상하 패딩
        static let buttonVerticalPadding: CGFloat = 8
        
        /// 버튼 좌우 패딩
        static let buttonHorizontalPadding: CGFloat = 16
        
        /// 팝업 뷰 corner radius
        static let popupCornerRadius: CGFloat = 16
        
        /// top bar container 의 너비, 높이
        static let topbarContainerSize = CGSize(
            width: popupViewSize.width,
            height: buttonSize.height + 2 * buttonVerticalPadding
        )
        
        /// top bar 의 너비, 높이
        static let topBarSize = CGSize(
            width: topbarContainerSize.width - 2 * buttonHorizontalPadding,
            height: buttonSize.height
        )
        
        /// note text view 너비, 높이
        static let noteTextViewSize = CGSize(
            width: popupViewSize.width,
            height: popupViewSize.height
            - paletteContainerSize.height
            - topbarContainerSize.height
        )
        
        /// palette container view 너비, 높이
        static let paletteContainerSize = CGSize(
            width: popupViewSize.width,
            height: buttonSize.height + 2 * verticalPadding
        )
        
        /// palette 너비, 높이
        static let paletteSize = CGSize(
            width: paletteContainerSize.width - 2 * verticalPadding,
            height: buttonSize.height
        )
        
        /// note 의 최대 작성 가능 길이 : 100 자
        static let noteTextMaxLength = 100
        
        /// 팝업 뷰 페이드인 효과 시 스케일 이펙트 정도: 0.9
        static let transformScale: CGFloat = 0.9
        
        /// 팝업 뷰 애니메이션 지속 정도: 0.3
        static let animationDuration: CGFloat = 0.3
        
        /// 배경 화면 어두운 정도: 0.2
        static let blackAlpha: CGFloat = 0.2
    }
    
    /// NewNotePopupViewController 의 폰트 크기 상수들
    enum Font {
        
        /// body text 의 폰트 크기
        static let body = UIFont.systemFont(ofSize: 18)
    }
    
    /// NewNotePopupViewController 에서 설정하는 제목들
    enum StringLiteral {
        
        /// note text view 의 place holder
        static let noteTextViewPlaceHolder = "하루 한 번,\n100 글자로 행복을 기록하세요:)"

        /// 글자 수 라벨의 최댓값
        static let maximumLetterCount = "/\(Metric.noteTextMaxLength)"
        
        /// 글자 수 라벨의 최초 상태
        static let letterCountLabel = "0" + maximumLetterCount
        
        /// 키보드 언어 설정이 한글인 경우
        static let korean = "ko-KR"
        
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

extension NewNotePopupTopBar {
    
    /// 노트 추가 팝업의 상단바에서 설정하는 레이아웃에 적용할 상수들
    enum Metric {
        
        /// 버튼 너비, 높이
        static let buttonSize = CGSize(
            width: HomeViewController.Metric.buttonWidth,
            height: HomeViewController.Metric.buttonHeight
        )
    }
    
    /// 노트 추가 팝업의 상단바에서 설정하는 제목들
    enum StringLiteral {
        
        /// 취소 버튼 제목
        static let cancelButtonTitle = "취소"
        
        /// 저장 버튼 제목
        static let saveButtonTitle = "저장"
        
        /// 팝업 제목
        static let title = "쪽지 추가하기"
    }
    
    /// 노트 추가 팝업의 상단바에서 설정하는 폰트 크기들
    enum Font {
        
        /// title 수준의 폰트 크기
        static let title = UIFont.systemFont(ofSize: 20)
    }
}

extension ColorPalette {
    
    /// Color Palette 의 레이아웃에 사용하는 상수들
    enum Metric {
        
        /// 버튼 크기
        static let buttonSize = CGSize(
            width: DefaultButton.Metric.buttonWidth,
            height: DefaultButton.Metric.buttonHeight
        )
        
        /// 하이라이트 뷰 크기
        static let highlightViewSize = CGSize(width: buttonSize.width, height: buttonSize.height)
        
        /// 하이라이트 뷰 corner radius
        static let highlightViewCornerRadius: CGFloat = ColorButton.Metric.cornerRadius
        
        /// 하이라이트 뷰 테두리 선 두께
        static let highlightBorderWidth: CGFloat = 2
    }
}

extension ColorButton {
    
    /// 컬러 버튼의 레이아웃에 사용하는 상수값들
    enum Metric {
        
        /// 버튼의 corner radius
        static let cornerRadius: CGFloat = 8
        
        /// 버튼 테두리 선 두께
        static let borderWidth: CGFloat = 1
    }
}

extension NoteTextView {
    
    /// note text view 의 레이아웃에 사용하는 상수값들
    enum Metric {
        
        /// 상하 패딩
        static let verticalPadding: CGFloat = HomeViewController.Metric.verticalPadding
        
        /// 좌우 패딩
        static let horizontalPadding: CGFloat = verticalPadding
        
        /// note 의 최대 작성 가능 길이
        static let noteTextMaxLength = 100
        
        /// 글자 수 라벨의 trailing anchor 를 구하기 위해 note text view 의 leading anchor 에  더할 상수
        static let letterCountLabelTrailingConstant: CGFloat =
            NewNotePopupViewController.Metric.noteTextViewSize.width - horizontalPadding
        
        /// 글자 수 라벨의 bottom anchor 를 구하기 위해 note text view 의 top anchor 에 더할 상수
        static let letterCountLabelBottomConstant: CGFloat =
            NewNotePopupViewController.Metric.noteTextViewSize.height - verticalPadding
    }
    
    /// note text view 에서 사용되는 폰트 크기 상수들
    enum Font {
        
        /// body text 의 폰트 크기
        static let body = UIFont.systemFont(ofSize: 18)
    }
    
    /// note text view 에서 설정하는 제목들
    enum StringLiteral {
        
        /// note text view 의 place holder
        static let noteTextViewPlaceHolder = "하루 한 번,\n100 글자로 행복을 기록하세요:)"

        /// 글자 수 라벨의 최댓값
        static let maximumLetterCount = "/\(Metric.noteTextMaxLength)"
        
        /// 글자 수 라벨의 최초 상태
        static let letterCountLabel = "0" + maximumLetterCount
        
    }
}

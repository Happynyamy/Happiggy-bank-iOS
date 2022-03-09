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
    
    /// HomeViewController 에서 사용하는 문자열
    enum StringLiteral {
        
        /// "showBottleView" segue identifier 
        static let showBottleViewIdentifier = "showBottleView"
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

extension NotesViewController {
    
    /// NotesViewController 에서 설정하는 레이아웃에 적용할 상수들
    enum Metric {
        
        /// 상하좌우 패딩 값 : 16
        static let padding: CGFloat = 16
        
        /// notes view cell 높이/너비 비율
        private static let cellHeightWidthRatio: CGFloat = 96 / 162
        
        /// notes view cell 너비
        private static let cellWidth: CGFloat = (UIScreen.main.bounds.width - 3 * padding) / 2
        
        /// notes view cell 너비와 높이
        static let cellSize = CGSize(
            width: cellWidth,
            height: cellWidth * cellHeightWidthRatio
        )
        
        /// notes view cell 간 간격
        static let spacing: CGFloat = padding
    }
    
    /// NotesViewController 에서 설정하는 제목들
    enum StringLiteral {
        
        /// 쪽지가 한 개도 없을 때 라벨에 나타낼 텍스트 : 럴수럴수이럴수...쪽지가 없어요ㅠ
        static let emptyNotesLabelText = "럴수럴수이럴수...쪽지가 없어요ㅠ"
        
        /// 뒤로가기 버튼 제목
        static let backButtonTitle = ""
        
    }
}

/// 대한민국 local identifier
let krLocalIdentifier = "ko_KR"

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

extension BottleListViewController {
    
    /// BottleListViewController에서 설정하는 layout 상수값
    enum Metric {
        
        /// 테이블뷰 행 높이
        static let tableViewRowHeight: CGFloat = 112
    }
    
    /// BottleListViewController에서 설정하는 Color 상수값
    enum Color {
        
        /// 테이블뷰 배경색
        static let tableViewBackground: Int = 0xE1C2BC
        
        /// 내비게이션 바 Item 색상
        static let navigationBar: Int = 0x000000
    }
    
    /// BottleListViewController에서 설정하는 글자 크기 상수값
    enum FontSize {
        
        /// 리스트가 빈 경우 표시되는 라벨 글자 크기
        static let emptyListLabelTitle: CGFloat = 16
    }
    
    /// BottleListViewController에서 설정하는 문자열
    enum StringLiteral {
        
        /// 리스트가 빈 경우 표시되는 내비게이션 타이틀
        static let emptyListNavigationBarTitle: String = "지난 유리병"
        
        /// 리스트가 차있는 경우 표시되는 내비게이션 타이틀
        static let fullListNavigationBarTitle: String = "지난 유리병 목록"
        
        /// 리스트가 빈 경우 테이블뷰에 표시되는 라벨
        static let emptyListLabelTitle: String = "이전에 사용한 유리병이 없습니다."
    }
}

extension BottleCell {
    
    /// Bottle Cell에서 설정하는 layout 상수값
    enum Metric {
        
        /// 셀 배경 너비
        static let cellBackgroundWidth: CGFloat =
        UIScreen.main.bounds.width - cellHorizontalPadding * 2
        
        /// 셀 배경 높이
        static let cellBackgroundHeight: CGFloat = 96
        
        /// 셀 수평 패딩
        static let cellHorizontalPadding: CGFloat = 16
        
        /// 셀 수직 패딩
        static let cellVerticalPadding: CGFloat = 16
        
        /// 셀 내부 앞쪽 패딩
        static let cellInnerLeadingPadding: CGFloat = 16
        
        /// 셀 내부 뒤쪽 패딩
        static let cellInnerTrailingPadding: CGFloat = 56
        
        /// 셀 내부 수직 패딩
        static let cellInnerVerticalPadding: CGFloat = 24
        
        /// 셀 내부 라벨 간 패딩
        static let cellLabelPadding: CGFloat = 12
    }
    
    /// Bottle Cell에서 설정하는 글자 크기
    enum FontSize {
        
        /// 유리병 제목 라벨 글자 크기
        static let titleLabel: CGFloat = 16
        
        /// 유리병 기간 라벨 글자 크기
        static let dateLabel: CGFloat = 16
    }
    
    /// Bottle Cell에서 설정하는 색상 상수값
    enum Color {
        
        /// 유리병 기간 라벨 색상
        static let dateLabelText: Int = 0xA19491
    }
}

extension Bottle {
    
    /// Bottle 엔티티에서 설정하는 문자열
    enum StringLiteral {

        /// 제목 디폴트 값: "?"
        static let title = "?"
    }
    
}

extension Note {
    
    /// Note 엔티티에서 설정하는 문자열
    enum StringLiteral {

        /// 내용 디폴트 값: "?"
        static let content = "?"
    }
    
}

/// 쪽지 색상들을 모아둔 enum 으로 상황별로 기본 문자열에 이하 문자열을 접두사/접미사로 붙여서 불러올 애셋 이름을 완성
/// e.g MainViewNote + NoteColors.white
enum NoteColor {
    
    /// 기본 쪽지 색깔
    static let `default` = NoteColor.white
    
    /// 흰색 쪽지
    static let white = "white"
    
    /// 분홍 쪽지
    static let pink = "pink"
    
    /// 보라 쪽지
    static let purple = "purple"
    
    /// 노랑 쪽지
    static let yellow = "yellow"
    
    /// 연두 쪽지
    static let green = "green"
}

extension PersistenceStore {
    
    /// Persistence Store 에서 사용되는 문자열들
    enum StringLiteral {
        
        /// 공유 persistence store 의 이름 : "Happiggy-bank"
        static let sharedPersistenceStoreName = "Happiggy-bank"
    }
}

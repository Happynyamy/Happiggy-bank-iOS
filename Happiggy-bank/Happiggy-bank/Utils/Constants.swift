//
//  Constants.swift
//  Happiggy-bank
//
//  Created by 권은빈 on 2022/02/17.
//

import UIKit

// swiftlint:disable file_length
extension HomeViewController {
    
    /// HomeViewController 에서  설정하는 layout 에 적용할 상수값들을 모아놓은 enum
    enum Metric {
        
        /// 좌우 패딩 값 : 24
        static let verticalPadding: CGFloat = 24
        
        /// 버튼 높이 : 48
        static let buttonHeight: CGFloat = 48
        
        /// 버튼 길이(높이와 동일)
        static let buttonWidth: CGFloat = buttonHeight

        /// Bottle Label의 Border Width
        static let bottleLabelBorderWidth: CGFloat = 1
        
        /// Bottle Label의 Corner Radius
        static let bottleLabelCornerRadius: CGFloat = 10
        
        /// Bottle Label의 배경 투명도
        static let bottleLabelBackgroundOpacity: CGFloat = 0.6
        
        /// 기한이 지났는데 저금통을 열지 않은 경우 나타내는 라벨 앞쪽 패딩
        static let openDatePassedLabelLeadingPadding: CGFloat = 16
    }
    
    /// 애니메이션 시간
    enum Duration {
        
        /// 저금통 개봉 애니메이션 시간
        static let bottleOpeningAnimation: TimeInterval = 1.0
    }
    
    /// 문자열
    enum StringLiteral {
        
        /// 저금통 개봉 확인 알림 제목
        static let bottleOpenAlertTitle = "저금통 개봉날이에요! 개봉하시겠어요?"
        
        ///
        static let bottleOpenAlertMessage = "현재 저금통 모습이 그대로 저장됩니다"
        
        /// 저금통 개봉 확인 알림 개봉 버튼 제목
        static let bottleOpenAlertOpenButtonTitle = "개봉"
        
        /// 저금통이 없는 경우 나타나는 상단 라벨 문자열
        static let emptyTopLabelText: String = "저금통이 없습니다."
        
        /// 저금통이 없는 경우 나타나는 아래 라벨 문자열
        static let emptyBottomLabelText: String = "탭해서 행복저금통을 추가해주세요."
        
        /// 기한이 지났는데 저금통을 열지 않은 경우 나타내는 문자열
        static let openDatePassedMessage: String = "저금통을 개봉해주세요!"
        
        /// 저금통 제목 이미 바꿨을 때 나오는 알림 제목
        static let bottleNameFixedAlertTitle = "이미 저금통 이름을 변경했습니다."
        
        /// BottleNameEditViewController identifier
        static let bottleNameEditViewController = "BottleNameEditViewController"
        
        /// 저금통 생성 후 쪽지가 없을 때 나타내는 라벨 문자열
        static let tapToAddNoteLabelText: String = "화면을 탭해서 첫 행복을 작성하세요."
        
        /// 저금통 생성 후 쪽지가 없을 때 나타내는 캐릭터 이미지 이름
        static let homeCharacterInitialName: String = "homeCharacterInitial"
        
        /// 작성 가능한 날짜가 없음을 알리는 알람의 제목
        static let noEmptyDateAlertTitle = "이미 모든 날짜에 행복을 기록했어요"

        /// 작성 가능한 날짜가 없음을 알리는 알람의 메시지
        static let noEmptyDateAlertMessage = "미래의 날짜는 작성 불가능합니다."
        
        /// 저금통이 없을 때 나타나는 캐릭터 이미지 이름
        static let homeCharacterEmpty = "homeCharacter"
    }
    
    /// 폰트 크기
    enum FontSize {
        
        /// 기한이 지났는데 저금통을 열지 않은 경우 나타내는 라벨 폰트 크기
        static let openDatePassedLabelFont: CGFloat = 15
    }
}

extension BottleViewController {
    
    /// BottleViewController 에서 설정하는 layout 에 적용할 상수값들을 모아놓은 enum
    enum Metric {
        
        /// 현재 뷰를 기준으로 충돌 영역 설정을 위해 넣을 상하좌우 마진
        static let collisionBoundaryInsets = UIEdgeInsets(top: .zero, left: 3, bottom: 3, right: 3)
    }
}

extension BottleViewModel {
    /// 상수값
    enum Metric {
        
        /// 그리드 인셋
        static let gridEdgeInsets = UIEdgeInsets(
            top: 30,
            left: gridVerticalInset,
            bottom: .zero,
            right: gridVerticalInset
        )
        
        /// 1년 짜리 제외 다 영역 축소
        static let durationCap = 300
        
        /// 일주일, 한 달인 경우 높이를 축소하기 위해 감산해줄 값: 40
        static let shorterDurationHeightRemovalConstant: CGFloat = 40
        
        /// 그리드 좌우 인셋: 7
        private static let gridVerticalInset: CGFloat = 7
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

/// 대한민국 local identifier
let krLocalIdentifier = "ko_KR"

extension ColorButton {
    
    /// 컬러 버튼의 상수값들
    enum Metric {
        
        /// 버튼 테두리 선 두께: 1
        static let borderWidth: CGFloat = 1
        
        /// 컬러 버튼 상하좌우 패딩: 1
        static let colorButtonInset: CGFloat = 1
        
        /// 애니메이션 지속 시간: 0.2
        static let animationDuration = CATransition.transitionDuration
        
        /// 버튼 테두리 둥근 정도: 7
        static let buttonCornerRadius: CGFloat = 7
        
        /// 버튼 하이라이트 테두리 둥근 정도: 8
        static let highlightViewCornerRadius = buttonCornerRadius + 1
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

extension BottleListViewController {
    
    /// BottleListViewController에서 설정하는 layout 상수값
    enum Metric {
        
        /// 컬렉션뷰 셀 너비
        static let cellWidth: CGFloat = BottleCell.Metric.cellWidth
        
        /// 컬렉션뷰 셀 높이
        static let cellHeight: CGFloat = BottleCell.Metric.cellHeight
        
        /// 셀 각 라인 별 최소 간격
        static let minimumLineSpacing: CGFloat = 40
    }
    
    /// BottleListViewController에서 설정하는 Color 상수값
    enum Color {
        
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
        static let emptyListNavigationBarTitle: String = "저금통 목록"
        
        /// 리스트가 차있는 경우 표시되는 내비게이션 타이틀
        static let fullListNavigationBarTitle: String = "저금통 목록"
        
        /// 리스트가 빈 경우 테이블뷰에 표시되는 라벨
        static let emptyListLabelTitle: String = "이전에 사용한 유리병이 없습니다."
        
        /// 쪽지 리스트로 넘어갔을 때 뒤로가기 버튼의 제목을 비워두기 위해 사용
        static let emptyString = ""
    }
}

extension BottleCell {
    
    /// 리유저블 ID 이름
    static var reuseIdentifier: String {
        return "\(self)"
    }
    
    /// 인터페이스 빌더 파일 이름
    static var nibName: String {
        return "\(self)"
    }
    
    /// Bottle Cell에서 설정하는 layout 상수값
    enum Metric {

        /// bottle  image 가로:세로 비율
        private static let imageSizeRatio: CGFloat = 306 / 165
        
        /// bottle cell 가로:세로 비율
        private static let cellSizeRatio: CGFloat = 356 / 165
        
        /// 화면 가로 길이
        static let screenWidth: CGFloat = UIScreen.main.bounds.width
        
        /// bottle cell 사이 수평 간격
        static let cellHorizontalSpacing: CGFloat = 24
        
        /// bottle cell 사이 수직 간격
        static let cellVerticalSpacing: CGFloat = 20
        
        /// bottle cell 너비
        static let cellWidth: CGFloat = ((screenWidth - 3 * 24) / 2)
        
        /// bottle cell 높이
        static let cellHeight = cellWidth * cellSizeRatio
        
        /// bottle image 높이 : 스크린 가로 길이에서 좌우 패딩값을 뺀 다음 지정한 비율을 곱해서 계산
        static let imageHeight = cellWidth * imageSizeRatio
        
        /// corner radius
        static let cornerRadius: CGFloat = 7
    }
    
    /// Bottle Cell에서 설정하는 글자 크기
    enum FontSize {
        
        /// 유리병 제목 라벨 글자 크기
        static let titleLabel: CGFloat = 16
        
        /// 유리병 기간 라벨 글자 크기
        static let dateLabel: CGFloat = 12
    }
}

extension Bottle {
    
    /// Bottle 엔티티에서 설정하는 문자열
    enum StringLiteral {

        /// 제목 디폴트 값: "?"
        static let title = "?"
        
        /// date 라벨 중간 문자
        static let center: String = " ~ "
    }
}

extension Note {
    
    /// Note 엔티티에서 사용하는 상수
    enum Metric {
        
        /// 첫 단어 최대 길이(10자)로, 이 길이를 초과하면 해당 글자까지 자름
        static let firstWordMaxLength: Int = 10
        
        /// 첫 단어가 최대 길이(10자)를 초과하는 경우 랜덤으로 1~최대 길이의 범위 내의 숫자를 길이로 설정
        static var firstWordRandomLength: Int {
            (1...firstWordMaxLength).randomElement() ?? 3
        }
    }
    
    /// Note 엔티티에서 설정하는 문자열
    enum StringLiteral {

        /// 내용 디폴트 값: "?"
        static let content = "?"
    }
}

extension PersistenceStore {
    
    /// Persistence Store 에서 사용되는 문자열들
    enum StringLiteral {
        
        /// 공유 persistence store 의 이름 : "Happiggy-bank"
        static let sharedPersistenceStoreName = "Happiggy-bank"
        
        /// 저장 오류 알림 제목
        static let saveErrorTitle = "변경사항 저장에 실패했습니다"
        
        /// 저장 오류 알림 내용
        static let saveErrorMessage = """
        디바이스의 저장 공간이 충분한지 확인해주세요.
        같은 문제가 계속 발생하는 경우 happiggybank@gmail.com 으로 문의 부탁드립니다.
        """
        
        /// 확인 버튼 제목: 확인
        static let okButtonTitle = "확인"
    }
}

/// 스토리보드에서 사용하는 segue identifier 들
enum SegueIdentifier {
    
    /// 홈 뷰컨트롤러에서 보틀뷰 컨트롤러를 띄울 때 사용
    static let showBottleView = "showBottleView"
    
    /// 홈뷰 컨트롤러에서 새 쪽지 날짜 피커뷰 컨트롤러를 띄울 때 사용
    static let presentNewNoteDatePicker = "presentNewNoteDatePicker"
    
    /// 홈뷰 컨트롤러에서 새 쪽지 작성뷰 컨트롤러를 띄우는 데 사용
    static let presentNewNoteTextView = "presentNewNoteTextView"
    
    /// 쪽지 작성뷰 컨트롤러에서 취소 버튼을 눌러서 홈뷰 컨트롤러로 돌아갈 때 사용
    static let unwindFromNoteTextViewToHomeView = "unwindFromNoteTextViewToHomeView"
    
    /// 새 유리병 이름 텍스트필드 팝업 띄울 때 사용
    static let presentNewBottleNameField = "presentNewBottleNameField"
    
    /// 새 유리병 개봉 날짜 피커 띄울 때 사용
    static let presentNewBottleDatePicker = "presentNewBottleDatePicker"
    
    /// 새 저금통 팝업에서 홈뷰로 돌아갈 때 사용
    static let unwindFromNewBottlePopupToHomeView = "unwindFromNewBottlePopupToHomeView"
    
    /// 저금통 리스트에서 쪽지 리스트로 넘어갈 때 사용
    static let showNoteList = "showNoteList"
    
    /// 새 쪽지 텍스트 뷰에서 날짜 피커 띄울 때 사용
    static let presentDatePickerFromNoteTextView = "presentDatePickerFromNoteTextView"
    
    /// 새 쪽지 날짜 피커에서 텍스트뷰로 돌아갈 때 사용
    static let unwindFromNoteDatePickerToTextView = "unwindFromNoteDatePickerToTextView"
    
    /// 새 쪽지 날짜 피커에서 텍스트뷰로 넘어갈 때 사용
    static let presentNewNoteTextViewFromDatePicker = "presentNewNoteTextViewFromDatePicker"
    
    /// 새 쪽지 날짜 피커에서 저금통 뷰로 돌아갈 때 사용
    static let unwindFromNoteDatePickerToHomeView = "unwindFromNoteDatePickerToHomeView"
    
    /// 쪽지 리스트 컨트롤러에서 쪽지 디테일 뷰 컨트롤러를 띄울 때 사용
    static let showNoteDetailView = "showNoteDetailView"
    
    /// 홈뷰컨트롤러에서 저금통 개봉 시 저금통 메시지 뷰 컨트롤러를 띄울 때 사용
    static let presentBottleMessageView = "presentBottleMessageView"
    
    /// 저금통 개봉 시점 피커 뷰에서 저금통 개봉시 멘트 필드 뷰로 전환할 때 사용
    static let presentNewBottleMessageField = "presentNewBottleMessageFieldFromDatePicker"
    
    static let unwindFromNewBottleViewToHomeView = "unwindFromNewBottleViewToHomeView"
}

extension CATransition {
    
    /// 애니메이션 지속 시간: 0.2
    static let transitionDuration: CFTimeInterval = 0.2
}

extension NewNoteDatePickerViewController {
    
    /// NewNoteDatePickerViewController 에서 사용하는 상수값
    enum Metric {
        
        /// 영역 수: 1개
        static let numberOfComponents = 1
    }
}

extension NewBottleNameFieldViewController {
    
    /// NewBottleNameFieldViewController에서 사용하는 문자열
    enum StringLiteral {
        
        /// 키보드 언어 설정이 한글인 경우
        static let korean = "ko-KR"
        
        /// 상단 라벨의 문자열
        static let topLabel = "저금통 이름을 입력해주세요."
        
        /// 텍스트필드 플레이스홀더 문자열
        static let placeholder = "최대 10글자까지 입력 가능합니다."
        
        /// 하단 라벨의 문자열
        static let bottomLabel = "저금통 이름은 나중에 1회 변경할 수 있습니다."
        
        /// 경고 라벨의 문자열
        static let warningLabel = "저금통 이름이 없어요!"
    }
    
    /// NewBottleNameFieldViewController에서 사용하는 폰트 크기
    enum FontSize {
        
        /// 상단 라벨 텍스트 크기
        static let topLabelText: CGFloat = 17
        
        /// 하단 라벨 텍스트 크기
        static let bottomLabelText: CGFloat = 14
    
        /// 경고 라벨 텍스트 색상
        static let warningLabelText: CGFloat = 14
    }
    
    /// NewBottleNameFieldViewController에서 설정하는 layout 상수값
    enum Metric {
        
        /// 글자수 제한
        static let textFieldMaxLength = 10
        
        /// 한글 글자수 제한
        static let textFieldKoreanMaxLength = textFieldMaxLength + 1
        
        /// 텍스트필드 corner radius
        static let textFieldCornerRadius: CGFloat = 10
    }
}

extension NewBottleDatePickerViewController {
    
    /// NewBottleDatePickerViewController의 Picker 선택지
    static let pickerValues = ["일주일", "한 달", "3달", "6달", "일 년"]
    
    /// DateComponents를 만들기 위한 Picker의 상수값
    static let pickerConstants: [String: Int] = [
        pickerValues[0] : 7,
        pickerValues[1] : 1,
        pickerValues[2] : 3,
        pickerValues[3] : 6,
        pickerValues[4] : 1
    ]
    
    /// NewBottleDatePickerViewController에서 사용하는 문자열
    enum StringLiteral {
        
        /// 상단 라벨의 문자열
        static let topLabel = "저금통을 개봉할 기간을 선택해주세요"
    }
    
    /// NewBottleDatePickerViewController에서 사용하는 폰트 크기
    enum FontSize {
        
        /// 상단 라벨 텍스트 크기
        static let topLabelText: CGFloat = 17
        
        /// 피커 행 텍스트 크기
        static let rowText: CGFloat = 18
        
        /// 개봉 예정일 라벨 텍스트 크기
        static let openDateLabelText: CGFloat = 14
    }
    
    /// NewBottleDatePickerViewController에서 설정하는 layout 상수값
    enum Metric {
        
        /// 상단 라벨 topAnchor
        static let topLabelTopAnchor: CGFloat = 226
    }
}

/// 애셋에 추가한 색깔/이미지들의 이름을 쉽게 불러오기 위한 enum
enum Asset: String {
    
    // MARK: shared
    
    /// 쪽지 하이라이트 색상 (새 쪽지 컬러피커에서 사용)
    case noteHighlight
    
    /// 쪽지 색상
    case note
    
    /// 쪽지 외곽선 색상
    case noteBorder
    
    /// 캐릭터
    case character
    
    
    // MARK: Buttons
    
    /// 뒤로가기 아이콘
    case back
    
    /// 확인(체크 표시) 아이콘
    case checkmark
    
    /// 다음 아이콘
    case next
    
    /// 취소 아이콘
    case xmark
    
    
    // MARK: Tab bar Buttons
    
    /// 탭바 홈 아이콘 보통 상태
    case tabBarHomeNormal
    
    /// 탭바 리스트 아이콘 보통 상태
    case tabBarListNormal
    
    /// 탭바 환경설정 아이콘 보통 상태
    case tabBarSettingsNormal

    /// 탭바 홈 아이콘 선택 상태
    case tabBarHomeSelected
    
    /// 탭바 리스트 아이콘 선택 상태
    case tabBarListSelected
    
    /// 탭바 환경설정 아이콘 선택 상태
    case tabBarSettingsSelected

    
    // MARK: Home View Images
    
    /// 홈 라이트 모드 배경화면
    case homeBackgroundLight
    
    /// 홈 저금통 뚜껑
    case homeBottleCap
    
    /// 홈 저금통 뒷면
    case homeBottleBack
    
    /// 홈 저금통 앞면
    case homeBottleFront
    
    /// 홈 저금통 그림자
    case homeBottleShadow
    
    /// 블러된 홈 라이트 모드 배경화면
    case homeBackgroundBlurredLight
    
    
    // MARK: Bottle List Images
    
    /// 저금통 리스트 셀 라이트 모드 배경화면
    case bottleCellBackgroundLight

    /// 저금통 리스트 저금통 뒷면
    case bottleListBottleBack

    /// 저금통 리스트 저금통 앞면
    case bottleListBottleFront
}

extension NoteListViewController {
    
    /// NoteListViewController 에서 사용하는 상수값
    enum Metric {
        
        /// 첫 단어 라벨 위아래 패딩: 16
        static let firstWordLabelVerticalPadding: CGFloat = 16
        
        /// 첫 단어 라벨 좌우 패딩: 24
        static let firstWordLabelHorizontalPadding: CGFloat = 24
        
        /// 2
        static let two = 2.0
        
    }
    
    /// 줌 애니메이션
    enum ZoomAnimation {
        
        /// 화면이 최초로 나타날 때 줌 효과 시간: 0.5
        static let initialDisplayDuration: CGFloat = 0.5
        
        /// 순차적 효과를 위한 딜레이: 0.1
        static let initialDisplayDelayBase: TimeInterval = 0.1
        
        /// 셀 선택 시 줌 효과 시간: 0.3
        static let selectionDuration: Double = 0.3
    }
}

extension NoteCell {
    
    /// NoteCell 에서 사용하는 상수들
    enum Metric {
        
        /// 내용 라벨 줄 간격: 8
        static let lineSpacing: CGFloat = 8
        
        /// 내용 라벨 자간: 0.5
        static let characterSpacing: CGFloat = 0.5
    }
}

extension NewNoteTextViewController {
    
    /// NewNoteTextViewController에서 사용하는 상수값
    enum Metric {
        
        /// 텍스트 뷰 컨테이너 인셋: (위: 16, 왼쪽: 24, 아래: 24, 오른쪽: 24)
        static let textViewInset = UIEdgeInsets(
            top: 16,
            left: 24,
            bottom: 24,
            right: 24
        )
        
        /// note 의 최대 작성 가능 길이 : 100 자
        static let noteTextMaxLength = 100
        
        /// 한국 글자수 제한을 위한 오버플로우 cap 추가 값: 1
        static let krOverflowCap = noteTextMaxLength + 1
        
        /// 애니메이션 지속 시간: 0.2
        static let animationDuration = CATransition.transitionDuration
        
        /// 내용 스택이 내비게이션바, safe area top inset, 키보드 크기를 제외한 나머지 영역을 다 차지할 수 있도록 높이를 계산해서 리턴
        static func contentStackHeight(
            keyboardFrame: CGRect,
            navigationBarFrame: CGRect
        ) -> CGFloat {
            let keyboardHeight = keyboardFrame.size.height
            let navigationBarHeight = navigationBarFrame.size.height
            let screenHeight = UIScreen.main.bounds.height
            let safeAreaTopInset = navigationBarFrame.origin.y

            return screenHeight - safeAreaTopInset - navigationBarHeight - keyboardHeight
        }
        
        /// 텍스트뷰 줄 간격: 8
        static let lineSpacing: CGFloat = 8
        
        /// 텍스트뷰 자간: 0.5
        static let characterSpacing: CGFloat = 0.5
        
        /// 컬러 버튼 컨테이너 뷰 페이드 인 지속 시간: 0.1
        static let colorButtonContainerViewFadeInDuration: TimeInterval = 0.1
        
        /// 컬러 버튼 컨테이너 뷰 페이드 아웃 지속 시간: 0.1
        static let colorButtonContainerViewFadeOutDuration: TimeInterval = 0.1
    }
    
    /// NewNoteTextViewController 에서 설정하는 제목들
    enum StringLiteral {
        
        /// 키보드 언어 설정이 한글인 경우
        static let korean = "ko-KR"
        
        /// 저장 확인 알림 제목
        static let alertTitle = "쪽지를 저장하시겠어요?"
        
        /// 알림 내용
        static let message = """
쪽지는 하루에 한 번 작성할 수 있고,
저장 후에는 수정/삭제가 불가능합니다
"""
        
        /// 취소 버튼 제목
        static let cancelButtonTitle = "취소"
        
        /// 확인 버튼 제목
        static let confirmButtonTitle = "확인"
    }
}

extension NewNoteDatePickerViewModel {
    
    /// NoteNoteDatePickerViewModel 에서 지정하는 폰트 크기
    enum Font {
        
        /// 날짜라벨 폰트 크기: 18
        static let dateLabelFontSize: CGFloat = 18
    }
}

extension NoteListViewModel {
    
    /// NoteListViewModel 에서 사용하는 문자열
    enum StringLiteral {
        
        /// 쪽지 개수 라벨에서 개수 뒤에 붙일 문자열: 리턴 "행복 n개"
        static func noteCountLabelString(count: Int) -> String { "행복 \(count)개" }
    }
}

extension NewNoteTextViewModel {
    
    /// NewNoteTextViewModel 에서 사용하는 문자열
    enum StringLiteral {
        
        /// 쪽지 이미지 에셋 호출을 위해 앞에 붙일 접두사
        static let textViewNote = "textViewNote"
        
        /// 글자수 라벨 텍스트를 반환
        static let letterCountText = " \\ \(NewNoteTextViewController.Metric.noteTextMaxLength)"
    }
    
    /// NewNoteTextViewModel 에서 사용하는 폰트 크기
    enum Font {
        
        /// 글자수 라벨 폰트 크기: 15
        static let letterCountLabel: CGFloat = 15
    }
}

extension CapsuleButton {
    
    /// CapsuleButton 에서 사용하는 상수
    enum Metric {
        
        /// 외곽선 굵기: 1
        static let borderWidth: CGFloat = 1
    }
}

extension TagCell {
    
    /// TagCell 폰트
    enum Font {
        
        /// 첫 단어 라벨 폰트 크기: 18
        static let firstWordLabel: CGFloat = 18
    }
}

extension SettingsViewController {
    
    /// 각 셀 별 내용
    enum Content: Int, CaseIterable {
        /// 저금통 개봉 알림 설정
        case bottleAlertSettings
        
        /// 앱 버전 정보
        case appVersion
        
        /// 라이선스
//        case license
        
        
        // MARK: - Properties
        
        /// 아이콘 딕셔너리
        static let icon: [Int: UIImage?] = [
            appVersion.rawValue: UIImage(systemName: "info.circle")
//            license.rawValue: UIImage(systemName: "")
        ]
        
        /// 제목 딕셔너리
        static let title: [Int: String] = [
            appVersion.rawValue: "버전 정보"
//            license.rawValue: "라이선스"
        ]
        
        /// 추가 정보 딕셔너리
        static let informationText: [Int: String] = [
            appVersion.rawValue: "최신 버전을 사용 중 입니다"
        ]
    }
    
    /// 메일 앱 관련 문자열
    enum Mail {
        
        /// 수신인: 팀 이메일
        static let recipients = ["happiggybank@gmail.com"]
        
        /// 제목: [행복저금통]
        static let subject = "[행복저금통]"
        
        /// 내용
        static let body =
        "<p style=\"color:gray\">버그 발생 시 디바이스 이름, iOS 버전을 함께 알려주시면 감사하겠습니다:)</p>"
    }
}

extension SettingsViewCell {
    
    /// 상수값
    enum Metric {
        
        /// 좌우 패딩: 24
        static let HorizontalPadding: CGFloat = 24
    }
}


extension NoteView {
    
    /// NoteView 에서 사용하는 상수값
    enum Metric {
        
        /// 쪽지 이미지들의 z index
        static var randomZpostion: CGFloat {
            [3, 4, 5, 6, 7, 8].randomElement() ?? 3
        }
        
        // TODO: 삭제
        /// 쪽지 이미지 scale
        static var randomScale: CGFloat {
            [1, 1.1, 1.2, 1.3, 1.4, 1.5].randomElement() ?? .one
        }
        
        /// 쪽지 이미지 회전 각도
        static var randomDegree: CGFloat {
            2 * .pi / (degreeDividers.randomElement() ?? .one)
        }
        
        /// 쪽지 이미지들의 회전 각도를 구하기 위한 값들
        private static let degreeDividers: [CGFloat] = {
            var degree = [CGFloat]()
            for number in 1...36 {
                degree.append(CGFloat(number))
            }
            return degree
        }()
    }
}

extension Gravity {
    
    /// 상수값
    enum Metric {
        
        /// 디바이스 모션 업데이트 주기: 0.05
        static let deviceMotionUpdateInterval: CGFloat = 1/20
    }
}

extension NoteDetailViewModel {
    
    /// 폰트 관련 설정
    enum Font {
        
        /// 인덱스라벨 폰트 크기: 16
        static let indexLabel: CGFloat = 16
    }
    
    /// 문자열
    enum StringLiteral {
        
        /// 쪽지 이미지 에셋 호출을 위해 앞에 붙일 접두사
        static let listNote: String = "listNote"
    }
}

extension NoteDetailViewController {
    
    /// 상수값
    enum Metric {
        
        /// 양 옆에 보일 아이템의 너비: 30
        static let sideItemVisibleWidth: CGFloat = 30
        
        /// 중앙 아이템 사이즈(아이폰 12 기준)
        static let itemSize = CGSize(
            width: 294,
            height: 367.5
        )
    }
    
    /// 애니메이션 관련 상수
    enum Animation {
        
        /// 상단 캐릭터 애니메이션 시간: 0.3
        static let topCharacterDuration: Double = 0.3
        
        /// 하단 캐릭터 애니메이션 시간: 0.2
        static let bottomCharacterDuration: Double = 0.2
        
        /// 하단 캐릭터 애니메이션 딜레이 시간: 0.1
        static let bottomCharacterDelay: Double = 0.1
        
        /// 인덱스 라벨 업데이트 애니메이션 시간: 0.2
        static let IndexLabelDuration: Double = 0.2
    }
}

extension BottleMessageViewController {
    
    /// 애니메이션 시간
    enum Duration {
        
        /// 탭 안내 라벨 딜레이: 0.5
        static let tapToContinueLabelDelay: TimeInterval = 0.5

        /// 탭 안내 라벨 시간: 1.5
        static let tapToContinueLabel: TimeInterval = 1.5
        
        /// 페이드인 상대시간: 3/4
        static let tapToContinueLabelRelativeFadeIn: TimeInterval = 3/4

    }
    
    /// 문자열
    enum StringLiteral {
        
        /// 저금통이 비어있는 경우: "화면을 탭하면 홈으로 돌아갑니다."
        static let emptyBottleTapToContinueLabelText = "화면을 탭하면 홈으로 돌아갑니다."
    }
}

extension NotificationSettingViewController {
    
    /// 상수값
    enum Metric {
        
        /// 노티피케이션 반복할 날짜
        static let repeatingDays: Int = 14
        
        /// 스위치 오른쪽 패딩
        static let trailingPadding: CGFloat = -10
    }
    
    /// 문자열
    enum StringLiteral {
        
        /// 노티피케이션 제목
        static let notificationTitle: String = "행복한 소식!"
        
        /// 노티피케이션 내용
        static let notificationBody: String = "저금통을 열어볼 준비가 되었어요 :)"
        
        /// 노티피케이션 식별자
        static let notificationIdentifier: String = "repeatingNotification"
        
        /// UserDefaults의 key로 사용할 문자열
        static let hasNotificationOn: String = "hasNotificationOn"
        
        /// 알림 타이틀
        static let disabledAlertTitle: String = "알림을 허용해주세요."
        
        /// 알림 메시지
        static let disabledAlertMessage: String = "저금통 개봉 알림을 받으려면 시스템 설정에서 행복 저금통 알림을 허용해주세요."
        
        /// 알림 이동 액션 라벨
        static let move: String = "설정으로 이동"
        
        /// 알림 취소 액션 라벨
        static let cancel: String = "취소"
    }
}

extension NewBottleDatePickerViewModel {
    
    /// 문자열
    enum StringLiteral {
        
        /// 개봉 예정일 표시하는 라벨 앞에 붙는 문자열
        static let openDateLabelPrefix: String = "개봉일: "
    }
}

extension NewBottleMessageFieldViewController {
    
    /// NewBottleMessageFieldViewController에서 사용하는 문자열
    enum StringLiteral {
        
        /// 키보드 언어 설정이 한글인 경우
        static let korean = "ko-KR"
        
        /// 상단 라벨의 문자열
        static let topLabel = "저금통 개봉할 때의\n나에게 해줄 한마디를 적어주세요!"
        
        /// 텍스트필드 플레이스홀더 문자열
        static let placeholder = "최대 15글자까지 입력 가능합니다."
        
        /// 하단 라벨의 문자열
        static let bottomLabel = "최대 15글자까지 입력 가능합니다."
        
        // TODO: 좋은 아이디어좀 주세요..
        /// 개봉 메시지를 적지 않았을 때 기본으로 제공되는 메시지
        static let defaultMessage = "반가워 내 행복들아!"
    }
    
    /// NewBottleMessageFieldViewController에서 사용하는 폰트 크기
    enum FontSize {
        
        /// 상단 라벨 텍스트 크기
        static let topLabelText: CGFloat = 17
        
        /// 하단 라벨 텍스트 크기
        static let bottomLabelText: CGFloat = 14
    }
    
    /// NewBottleMessageFieldViewController에서 설정하는 layout 상수값
    enum Metric {
        
        /// 글자수 제한
        static let textFieldMaxLength = 15
        
        /// 한글 글자수 제한
        static let textFieldKoreanMaxLength = textFieldMaxLength + 1
        
        /// 텍스트필드 corner radius
        static let textFieldCornerRadius: CGFloat = 10
    }
}

extension BottleNameEditViewController {
    
    /// NewBottleNameFieldViewController에서 사용하는 문자열
    enum StringLiteral {
        
        /// 키보드 언어 설정이 한글인 경우
        static let korean = "ko-KR"
        
        /// 상단 라벨의 문자열
        static let topLabel = "변경할 저금통 이름을 입력해주세요."
        
        /// 텍스트필드 플레이스홀더 문자열
        static let placeholder = "최대 10글자까지 입력 가능합니다."
        
        /// 하단 라벨의 문자열
        static let bottomLabel = "저금통 이름 변경 시, 추가 변경은 불가합니다."
        
        /// 이름이 없을 때 경고 라벨의 문자열
        static let warningLabel = "저금통 이름이 없어요!"
        
        /// 이름이 같을 때 경고 라벨의 문자열
        static let sameNameWarningLabel = "저금통 이름이 같아요!"
    }
    
    /// NewBottleNameFieldViewController에서 사용하는 폰트 크기
    enum FontSize {
        
        /// 상단 라벨 텍스트 크기
        static let topLabelText: CGFloat = 17
        
        /// 하단 라벨 텍스트 크기
        static let bottomLabelText: CGFloat = 14
    
        /// 경고 라벨 텍스트 색상
        static let warningLabelText: CGFloat = 14
    }
    
    /// NewBottleNameFieldViewController에서 설정하는 layout 상수값
    enum Metric {
        
        /// 글자수 제한
        static let textFieldMaxLength = 10
        
        /// 한글 글자수 제한
        static let textFieldKoreanMaxLength = textFieldMaxLength + 1
        
        /// 텍스트필드 corner radius
        static let textFieldCornerRadius: CGFloat = 10
    }
}

extension CustomTabBar {
    
    /// 상수값
    enum Metric {
        
        /// 높이 : 89
        static let height: CGFloat = 89
        
        /// 아이템 제목 오프셋: 4
        static let titleOffset: CGFloat = 4
        
        /// 아이템 인셋: (4, 0, -4, 0)
        static let imageInset = UIEdgeInsets(
            top: titleOffset,
            left: .zero,
            bottom: -titleOffset,
            right: .zero
        )
        
        /// 커스텀 탭바 크기를 적용할 디바이스 최소 높이
        static let heightCap: CGFloat = 800
    }
}

extension HomeViewModel {
    
    /// 상수값
    enum Metric {
        
        /// 저금통 스냅샷 사이즈
        static func snapshotSize(forView containerView: UIView) -> CGSize {
            let bottleListWidth = UIScreen.main.bounds.width
            let snapshotWidth = (bottleListWidth - 3 * interSnapshotSpacingInBottleList) / 2
            let scale = snapshotWidth / containerView.frame.width
            let snapShotheight = containerView.frame.height * scale
            
            return CGSize(width: snapshotWidth, height: snapShotheight)
        }
        
        /// 저금통 리스트에서 스냅샷 간 간격
        private static let interSnapshotSpacingInBottleList: CGFloat = 24
    }
}

/// 메인 스토리보드 이름 "main"
let mainStoryboardName = "Main"

extension ErrorViewController {
    
    /// 문자열
    enum StringLiteral {
        
        /// 에러 내용
        static let errorDescription = "코어데이터 오류"
        
        /// 에러 안내 라벨 내용
        static let informationLabelText = """
데이터 오류가 발생해 앱을 작동할 수 없습니다
happiggybank@gmail.com으로 문의 부탁드립니다

화면을 탭하면 앱이 종료됩니다
"""
    }
}

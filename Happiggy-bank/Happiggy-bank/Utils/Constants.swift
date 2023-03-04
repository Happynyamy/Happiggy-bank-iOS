//
//  Constants.swift
//  Happiggy-bank
//
//  Created by 권은빈 on 2022/02/17.
//

import UIKit

// swiftlint:disable file_length

/// 팀 메일 주소
let teamMail = "happynyamy@gmail.com"

/// 폰트 사이즈
enum FontSize {

    /// 46
    static let headline1: CGFloat = 46
    /// 30
    static let headline2: CGFloat = 30

    /// 22
    static let title1: CGFloat = 22
    /// 20
    static let title2: CGFloat = 20

    /// 18
    static let body1: CGFloat = 18
    /// 17
    static let body2: CGFloat = 17
    /// 16
    static let body3: CGFloat = 16
    /// 14
    static let body4: CGFloat = 14

    /// 12
    static let caption1: CGFloat = 12
    /// 10
    static let caption2: CGFloat = 10


    // TODO: 아래 2개는 전체 리팩토링 후 삭제

    /// 이거 대신 body1 사용!!!
    static let body: CGFloat = 18

    /// 이거 사용 x
    static let secondaryLabel: CGFloat = 15
}

extension BottleViewController {
    
    /// BottleViewController 에서 설정하는 layout 에 적용할 상수값들을 모아놓은 enum
    enum Metric {
        
        /// 현재 뷰를 기준으로 충돌 영역 설정을 위해 넣을 상하좌우 마진
        static let collisionBoundaryInsets = UIEdgeInsets(top: .zero, left: 3, bottom: 3, right: 3)
        
        /// 쪽지들이 바운더리와 부딪칠 때 햅틱 반응의 강도: 0.4
        static let impactHapticIntensity: CGFloat = 0.4
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

/// 대한민국 local identifier
let krLocalIdentifier = "ko_KR"

extension ColorButton {
    
    /// 컬러 버튼의 상수값들
    enum Metric {
        
        /// 버튼 테두리 선 두께: 1
        static let borderWidth: CGFloat = 2
        
        /// 애니메이션 지속 시간: 0.2
        static let animationDuration = CATransition.transitionDuration
        
        /// 버튼 테두리 둥근 정도: 8
        static let buttonCornerRadius: CGFloat = 8
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
        같은 문제가 계속 발생하는 경우 \(teamMail) 으로 문의 부탁드립니다.
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
        static let bottomLabel = "저금통 이름은 나중에 변경할 수 있습니다."
        
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

// TODO: 전체 리팩토링 후 삭제
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
    
    
    // MARK: Settings View Icons
    
    /// 환경설정 아이콘 에셋 호출을 위함
    case settings
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
            let removingHeight = safeAreaTopInset + navigationBarHeight + keyboardHeight

            return screenHeight - removingHeight
        }
        
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
        static let alertTitle = "쪽지를 추가하시겠어요?"
        
        /// 알림 내용
        static let message = """
쪽지는 하루에 한 번 작성할 수 있고,
추가 후에는 수정/삭제가 불가능합니다
"""
        
        /// 취소 버튼 제목: "취소"
        static let cancelButtonTitle = "취소"
        
        /// 확인 버튼 제목: "추가"
        static let confirmButtonTitle = "추가"
    }
}

extension NewNoteDatePickerViewModel {
    
    /// NoteNoteDatePickerViewModel 에서 지정하는 폰트 크기
    enum Font {
        
        /// 날짜라벨 폰트 크기: 18
        static let dateLabelFontSize: CGFloat = 18
    }
}

extension NewNoteTextViewModel {
    
    /// NewNoteTextViewModel 에서 사용하는 문자열
    enum StringLiteral {
        
        /// 글자수 라벨 텍스트를 반환
        static let letterCountText = " / \(NewNoteTextViewController.Metric.noteTextMaxLength)"

        /// 날짜 레이블 간격
        static let spacing = "  "
    }

    /// NewNoteTextViewModel 에서 사용하는 폰트 크기
    enum Font {
        
        /// 날짜 버튼과 글자수 라벨 폰트 크기: 15
        static let secondaryText: CGFloat = 15
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
        
        /// UserDefaults의 key로 사용할 문자열
        static let hasNotificationOn: String = "hasNotificationOn"
    }
    
    /// 숫자
    enum Metric {
        /// 1
        static let one = 1
    }
}

extension NotificationSettingsViewController {
    
    /// 문자열
    enum StringLiteral {
        
        /// 알림 타이틀
        static let disabledAlertTitle: String = "알림을 허용해주세요."
        
        /// 알림 메시지
        static let disabledAlertMessage: String = "알림을 받으려면 시스템 설정에서 행복저금통 알림을 허용해주세요."
        
        /// 알림 이동 액션 라벨
        static let move: String = "설정으로 이동"
        
        /// 알림 취소 액션 라벨
        static let cancel: String = "취소"
        
        /// 리마인드 알림 불가시 알림 타이틀
        static let reminderDisabledAlertTitle: String = "저금통이 없어요!"
        
        /// 리마인드 알림 불가시 알림 메시지
        static let reminderDisabledAlertMessage: String = "리마인드 알림을 받으려면 저금통을 생성해주세요."
        
        /// 홈 화면으로 이동
        static let moveToHome: String = "만들러 가기"
        
        /// 취소 액션
        static let cancelAlert: String = "취소"
        
        /// 현재 화면에서 홈 화면으로 이동하는 segue의 식별자
        static let segueIdentifier: String = "segueFromSettingsViewToHomeView"
    }
}

extension NotificationSettingsViewModel {
    
    /// 상수값
    enum Metric {
        
        /// 노티피케이션 반복할 날짜
        static let repeatingDays: Int = 3
    }
    
    /// 문자열
    enum StringLiteral {
        
        /// 노티피케이션 식별자
        static let notificationIdentifier: String = "repeatingNotification"
        
        /// 노티피케이션 시간을 저장하는 userDefaults 데이터의 key
        static let datePickerUserDefaultsKey: String = "timePickerDate"
    }
    
    /// 각 셀 별 내용
    enum Content: Int, CaseIterable {
        /// 일일 알림 설정
        case daily
        
        /// 리마인드 알림 설정
        case reminder
        
        
        // MARK: - Properties
        
        /// 제목 딕셔너리
        static let title: [Int: String] = [
            daily.rawValue: "일일 알림",
            reminder.rawValue: "리마인드 알림"
        ]
        
        /// userDefault key 딕셔너리
        static let userDefaultsKey: [Content: String] = [
            daily: "hasDailyNotificationOn",
            reminder: "hasRemindNotificationOn"
        ]
        
        /// NotificationCenter의 식별자 딕셔너리
        static let identifier: [Int: String] = [
            daily.rawValue: "dailyNotification",
            reminder.rawValue: "remindNotification"
        ]
        
        static let message: [Content: [String]] = [
            .daily: [
                "오늘의 기분은?",
                "오늘 느낀 행복을 저장해보세요 :)"
            ],
            .reminder: [
                "행복한 소식!",
                "저금통을 열어볼 준비가 되었어요 :)"
            ]
        ]
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
        
        /// 생성 확인 알림 제목
        static let confirmationAlertTitle = "저금통을 추가하시겠어요?"
        
        /// 생성 확인 알림 내용
        static let confirmationAlertMessage = "추가 후에는 개봉날짜 변경 및 저금통 삭제가 불가합니다."
        
        /// 생성 확인 알림 확인 버튼 제목: 추가
        static let confirmationAlertConfirmButtonTitle = "추가"
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
        static let bottomLabel = String.empty
        
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
    
    /// 상수
    enum Metric {
        
        /// 상하좌우 패딩 (24, -24, 24, -24)
        static let paddings = (
            top: edgeInset,
            bottom: -edgeInset,
            leading: edgeInset,
            trailing: -edgeInset
        )
        
        /// 뷰 간 간격: 16
        static let spacing: CGFloat = 24
        
        /// 패딩: 24
        private static let edgeInset: CGFloat = 24
    }
    
    /// 문자열
    enum StringLiteral {
        
        /// 에러 내용
        static let errorDescription = "코어데이터 오류"
        
        /// 에러 안내 라벨 내용
        static let informationLabelText = """
데이터 오류가 발생해 앱을 작동할 수 없습니다
\(teamMail)으로 문의 부탁드립니다

화면을 탭하면 앱이 종료됩니다
"""
    }
}

extension CustomerServiceViewModel {
    
    /// 셀 제목
    enum ContentTitle {
        
        /// 라이선스
        static let license = "라이선스"
        
        /// 메일
        static let mail = "의견 보내기"
    }
    
    /// 메일 앱 관련 문자열
    enum Mail {
        
        /// 제목: [행복저금통]
        static let subject = "[행복저금통]"
        
        /// 내용
        static let body =
        "<p style=\"color:gray\">버그 발생 시 디바이스 이름, iOS 버전을 함께 알려주시면 감사하겠습니다:)</p>"
        
        /// 메일을 보낼 수 없을 때 띄울 알림의 제목
        static let alertTitle = "메일 앱을 열 수 없습니다"
        
        /// 메일을 보낼 수 없을 때 띄울 알림의 내용
        static let alertMessage = """
\(teamMail)
으로 의견을 보내주세요!
"""
    }
}

extension LicenseViewModel {
    
    /// 폰트 관련 상수
    enum Font {
        
        /// 볼드체 사이즈: 14
        static let boldFontSize: CGFloat = 14
    }
}

/// 단락 자간, 행간 설정에 사용하는 상수값
enum ParagraphStyle {

    /// 행간: 8
    static let lineSpacing: CGFloat = 8

    /// 자간: 0.5
    static let characterSpacing: CGFloat = 0.5
}

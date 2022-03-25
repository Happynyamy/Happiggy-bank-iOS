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
    }
}

extension BottleViewController {
    
    /// BottleViewController 에서 설정하는 layout 에 적용할 상수값들을 모아놓은 enum
    enum Metric {
        
        /// TODO: 모든 뷰에서 같으면 전역으로 만들기
        /// 좌우 패딩 값
        static let verticalPadding: CGFloat = HomeViewController.Metric.verticalPadding
        
        /// 저금통 안에 들어갈 쪽지 노드 너비
        static let noteWidth: CGFloat = 12
        
        /// 저금통 안에 들어갈 쪽지 노드 높이
        static let noteHeight: CGFloat = noteWidth
        
        /// Gravity에 추가될 x축 패딩
        static let boundaryPosX: CGFloat = 5
        
        /// Gravity에 추가될 y축 패딩
        static let boundaryPosY: CGFloat = 5
        
        /// Gravity에 추가될 수평 패딩
        static let boundaryPadding: CGFloat = 10
        
        /// 쪽지 이미지들의 z index
        static var randomZpostion: CGFloat {
            [3, 4, 5, 6, 7, 8].randomElement() ?? 3
        }
        
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
    
    enum Color {
        
        /// 흰색 버튼 외곽선 색상
        static let whiteButtonBorder = UIColor(named: "noteColorPickerBorderColorWhite") ?? .customGray
    }
    
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
        
        /// 테이블뷰 행 높이
        static let cellHeight: CGFloat = BottleCell.Metric.cellHeight + BottleCell.Metric.cellSpacing
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
        static let emptyListNavigationBarTitle: String = "지난 유리병"
        
        /// 리스트가 차있는 경우 표시되는 내비게이션 타이틀
        static let fullListNavigationBarTitle: String = "지난 유리병 목록"
        
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
    
    // TODO: 에셋 교체시 이름 통일
    /// Bottle Cell에서 사용하는 문자열
    enum StringLiteral {
        
        /// 셀 배경 이미지 이름
        static let backgroundImage: String = "bottleCellBackground"
        
        /// 셀 저금통 프레임 이미지 이름
        static let bottleFrameImage: String = "bottleInList"
        
        /// 셀 저금통 뚜껑 이미지 이름
        static let bottleCapImage: String = "cap"
    }
    
    /// Bottle Cell에서 설정하는 layout 상수값
    enum Metric {

        /// bottle cell 세로:가로 비율
        private static let cellSizeRatio: CGFloat = 262/327
        
        /// 좌우 패딩: 24
        static let horizontalPadding: CGFloat = 24
        
        /// 화면 가로 길이
        static let screenWidth: CGFloat = UIScreen.main.bounds.width
        
        /// bottle cell 사이 간격: 16
        static let cellSpacing: CGFloat = 16
        
        /// bottle cell 높이 : 스크린 가로 길이에서 좌우 패딩값을 뺀 다음 지정한 비율을 곱해서 계산
        static let cellHeight = (screenWidth - 2 * horizontalPadding) * cellSizeRatio
        
        /// corner radius
        static let cornerRadius: CGFloat = 15
        
        /// 그리드 top constraint 를 비율에 따라 조정한 값
        static let gridTopConstraintConstant = cellHeight * gridTopConstraintCellHeightRatio
        
        /// 쪽지 이미지들의 z index
        static var randomZpostion: CGFloat {
            [3, 4, 5, 6, 7, 8].randomElement() ?? 3
        }
        
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
        
        /// 그리드 top constraint 와 셀 높이 간 비율
        private static let gridTopConstraintCellHeightRatio: CGFloat = 83 / 262
    }
    
    /// Bottle Cell에서 설정하는 글자 크기
    enum FontSize {
        
        /// 유리병 제목 라벨 글자 크기
        static let titleLabel: CGFloat = 17
        
        /// 유리병 기간 라벨 글자 크기
        static let dateLabel: CGFloat = 16
    }
    
    /// Bottle Cell에서 설정하는 색상 상수값
    enum Color {
        
        /// 유리병 기간 라벨 색상
        static let dateLabelText: Int = 0x6D6E78
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
    }
}

/// 스토리보드에서 사용하는 segue identifier 들
enum SegueIdentifier {
    
    /// 홈 뷰컨트롤러에서 보틀뷰 컨트롤러를 띄울 때 사용
    static let showBottleView = "showBottleView"
    
    /// 보틀뷰 컨트롤러에서 새 쪽지 날짜 피커뷰 컨트롤러를 띄울 때 사용
    static let presentNewNoteDatePicker = "presentNewNoteDatePicker"
    
    /// 새 쪽지 날짜 피커에서 색깔 피커를 띄울 때 사용
    static let presentNewNoteColorPicker = "presentNewNoteColorPicker"
    
    /// 색깔 피커에서 새 쪽지 작성뷰 컨트롤러를 띄울 때 사용
    static let presentNewNoteTextView = "presentNewNoteTextView"
    
    /// 쪽지 작성뷰 컨트롤러에서 보틀뷰 컨트롤러로 돌아갈 때 사용
    static let unwindToBotteView = "unwindToBotteView"
    
    /// 새 유리병 이름 텍스트필드 팝업 띄울 때 사용
    static let presentNewBottleNameField = "presentNewBottleNameField"
    
    /// 새 유리병 개봉 날짜 피커 띄울 때 사용
    static let presentNewBottleDatePicker = "presentNewBottleDatePicker"
    
    static let unwindFromNewBottlePopupToBottleView = "unwindFromNewBottlePopupToBottleView"
    
    /// 새 쪽지 색깔 피커에서 날짜 피커로 돌아갈 때 사용
    static let unwindToNewNoteDatePicker = "unwindToNewNoteDatePicker"
    
    /// 저금통 리스트에서 쪽지 리스트로 넘어갈 때 사용
    static let showNoteList = "showNoteList"
    
    /// 새 쪽지 텍스트 뷰에서 날짜 피커 띄울 때 사용
    static let presentDatePickerFromNoteTextView = "presentDatePickerFromNoteTextView"
    
    /// 새 쪽지 날짜 피커에서 텍스트뷰로 돌아갈 때 사용
    static let unwindFromNoteDatePickerToTextView = "unwindFromNoteDatePickerToTextView"
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
        
        /// 영역 수가 1개이므로 항상 0으로 고정
        static let defaultComponentIndex = 0
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
        static let placeholder = "최대 15글자까지 입력 가능합니다."
        
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
        static let textFieldMaxLength = 15
        
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
        
        /// 좌우 패딩: 24
        static let horizontalPadding: CGFloat = 24
        
        /// 쪽지 이미지 너비
        static let noteImageWidth = UIScreen.main.bounds.width - 2 * horizontalPadding
        
        /// 쪽지 이미지 높이
        static let noteImageHeight = noteImageWidth * noteImageSizeRatio
        
        /// note cell 높이 : 쪽지 이미지 높이 + spacing
        static let cellHeight = noteImageHeight + noteImageSpacing
        
        /// 애니메이션 딜레이 시간: 0.5
        static let animationDelay: TimeInterval = 0.5

        /// note cell 세로:가로 비율 : 242/327
        private static let noteImageSizeRatio: CGFloat = 242/327
        
        /// 쪽지 이미지 사이 간격: 16
        private static let noteImageSpacing: CGFloat = 16
    }
    
    /// NoteNoteDatePickerViewModel 에서 사용하는 문자열
    enum StringLiteral {
        
        /// 알림 제목
        static let alertTitle = "전체 쪽지를 개봉하시겠습니까?"
        
        /// 취소 버튼 제목
        static let cancelButtonTitle = "아니오"
        
        /// 확인 버튼 제목
        static let confirmButtonTitle = "네"
    }
}

extension NoteCell {
    
    /// NoteCell 에서 사용하는 상수들
    enum Metric {
        
        /// 애니메이션 지속 시간: 0.6
        static let animationDuration: TimeInterval = 0.6
        
        /// 50%
        static let half: Double = 0.5
        
        /// 좌우 패딩: 25
        static let horizontalPadding = NoteListViewController.Metric.horizontalPadding
        
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
        
        /// 이미지 뷰가 내비게이션바, safe area top inset, 키보드 크기를 제외한 나머지 영역을 다 차지할 수 있도록 높이를 계산해서 리턴
        static func imageViewHeight(
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
    }
    
    /// NewNoteTextViewController 에서 설정하는 제목들
    enum StringLiteral {
        
        /// 키보드 언어 설정이 한글인 경우
        static let korean = "ko-KR"
    }
}

extension NewNoteDatePickerViewModel {
    
    /// NoteNoteDatePickerViewModel 에서 지정하는 폰트 크기
    enum Font {
        
        /// 날짜라벨 폰트 크기: 17
        static let dateLabelFontSize: CGFloat = 17
    }
}

extension NoteListViewModel {
    
    /// NoteListViewModel 에서 지정하는 폰트 크기
    enum Font {
        
        /// 날짜라벨 폰트 크기: 17
        static let dateLabelFontSize: CGFloat = 17
        
    }
    
    /// NoteListViewModel 에서 사용하는 문자열
    enum StringLiteral {
        
        /// 빈 문자열: 저금통 제목을 불러올 수 없을 때 사용
        static let emptyString = ""
        
        /// 쪽지 이미지 에셋 호출을 위해 앞에 붙일 접두사
        static let listNote: String = "listNote"
        
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
        static func letterCountText(count: Int) -> String {
            "\(count) / \(NewNoteTextViewController.Metric.noteTextMaxLength)"
        }
    }
    
    /// NewNoteTextViewModel 에서 사용하는 폰트 크기
    enum Font {
        /// 날짜 라벨들 폰트 크기: 17
        static let dateLabel: CGFloat = 17
        
        /// 글자수 라벨 폰트 크기: 17
        static let letterCountLabel = dateLabel
    }
}

extension CapsuleButton {
    
    /// CapsuleButton 에서 사용하는 상수
    enum Metric {
        
        /// 외곽선 굵기: 1
        static let borderWidth: CGFloat = 1
    }
}

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

extension ColorButton {
    
    /// 컬러 버튼의 상수값들
    enum Metric {
        
        /// 버튼 테두리 선 두께
        static let borderWidth: CGFloat = 1
        
        /// 컬러 버튼 상하좌우 패딩 
        static let colorButtonInset: CGFloat = 2
        
        /// 애니메이션 지속 시간: 0.2
        static let animationDuration = CATransition.transitionDuration
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
        static let cellHeight: CGFloat = BottleCell.Metric.cellHeight + BottleCell.Metric.horizontalPadding
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
        static let topLabel = "저금통 이름을 입력해주세요"
        
        /// 텍스트필드 플레이스홀더 문자열
        static let placeholder = "최대 15글자까지 입력 가능합니다"
        
        /// 하단 라벨의 문자열
        static let bottomLabel = "저금통 이름은 나중에 1회 변경할 수 있습니다"
        
        /// 경고 라벨의 문자열
        static let warningLabel = "저금통 이름이 없어요!"
    }
    
    /// NewBottleNameFieldViewController에서 사용하는 색상
    enum Color {
        
        /// 하단 라벨 텍스트 색상
        static let bottomLabelText: Int = 0x666666
        
        /// 경고 라벨 텍스트 색상
        static let warningLabelText: Int = 0xFF0000
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
        
        /// 상단 라벨 topAnchor
        static let topLabelTopAnchor: CGFloat = 226
        
        /// 텍스트필드 topAnchor
        static let textFieldTopAnchor: CGFloat = 50
        
        /// 하단 라벨 topAnchor
        static let bottomLabelTopAnchor: CGFloat = 32
        
        // MARK: 임시값
        /// 경고 라벨 topAnchor
        static let warningLabelTopAnchor: CGFloat = 10
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
    }
    
    /// NewBottleDatePickerViewController에서 설정하는 layout 상수값
    enum Metric {
        
        /// 상단 라벨 topAnchor
        static let topLabelTopAnchor: CGFloat = 226
    }
}

/// 애셋에 추가한 색깔들의 이름을 쉽게 불러오기 위한 enum
enum AssetColor: String {
    
    /// 쪽지 하이라이트 색상 (새 쪽지 컬러피커에서 사용)
    case noteHighlight
    
    /// 쪽지 색상
    case note
}

extension NoteListViewController {
    
    /// NoteListViewController 에서 사용하는 상수값
    enum Metric {
        
        /// note cell 세로:가로 비율 : 42/327
        private static let cellSizeRatio: CGFloat = 242/327
        
        /// 좌우 패딩: 24
        private static let horizontalPadding: CGFloat = 24
        
        /// 화면 가로 길이
        static let screenWidth: CGFloat = UIScreen.main.bounds.width
        
        /// note cell 사이 간격: 16
        static let cellSpacing: CGFloat = 16
        
        /// note cell 높이 : 스크린 가로 길이에서 좌우 패딩값을 뺀 다음 지정한 비율을 곱해서 계산
        static let cellHeight = (screenWidth - 2 * horizontalPadding) * cellSizeRatio
        
        /// note cell 의 (흰색) 쪽지 이미지 뷰 외곽선 굵기: 1
        static let noteImageViewBorderWidth: CGFloat = 1
    }
}

extension NoteCell {
    
    /// NoteCell 에서 사용하는 상수들
    enum Metric {
        
        /// 쪽지 이미지뷰 모서리 둥근 정도: 8
        static let cornerRadius: CGFloat = 8
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
    }
    
    /// NewNoteTextViewController 의 폰트 크기 상수들
    enum Font {
        
        /// body text 의 폰트 크기: 19
        static let body = UIFont.systemFont(ofSize: 19)
        
        /// 날짜 라벨들 폰트 크기: 17
        static let dateLabelFontSize: CGFloat = 17
        
        /// 연도 라벨 폰트 크기: bold 17
        static let yearLabelFont = UIFont.boldSystemFont(ofSize: dateLabelFontSize)
    }
    
    /// NewNoteTextViewController 에서 설정하는 제목들
    enum StringLiteral {
        
        /// note text view 의 place holder
        static let noteTextViewPlaceHolder = "하루 한 번,\n100 글자로 행복을 기록하세요:)"
        
        /// 키보드 언어 설정이 한글인 경우
        static let korean = "ko-KR"
        
        /// 글자수 라벨 텍스트를 반환
        static func letterCountText(count: Int) -> String {
            "\(count)/\(Metric.noteTextMaxLength)"
        }
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
    }
}

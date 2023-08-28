//
//  NewNoteInputToolbar.swift
//  Happiggy-bank
//
//  Created by sun on 2023/03/16.
//

import UIKit

/// 쪽지 작성뷰에서 사용하는, 사진 라이브러리 버튼과 컬러피커가 담긴 툴바
final class NewNoteInputToolbar: UIToolbar {

    // MARK: - Properties

    /// 사진 라이브러리를 여는 버튼
    let photoButton = UIButton().then {
        $0.tintColor = AssetColor.subBrown02
        $0.setImage(AssetImage.gallery, for: .normal)
        $0.adjustsImageWhenHighlighted = false
    }

    /// 쪽지 컬러 피커
    let colorPicker = ColorPickerItem()


    // MARK: - Init(s)

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.configureViews()
    }


    required init?(coder: NSCoder) {
        super.init(coder: coder)

        self.configureViews()
    }


    // MARK: - Initialization Functions

    private func configureViews() {
        self.barTintColor = .systemBackground
        let spacer = UIBarButtonItem(systemItem: .flexibleSpace)
        let buttonItem = UIBarButtonItem(customView: self.photoButton)
        self.setItems([buttonItem, spacer, self.colorPicker], animated: true)
    }
}

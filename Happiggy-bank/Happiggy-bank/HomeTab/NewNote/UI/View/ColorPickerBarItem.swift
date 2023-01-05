//
//  ColorPickerBarItem.swift
//  Happiggy-bank
//
//  Created by sun on 2022/10/21.
//

import UIKit

// TODO: - 삭제 필요

/// 색상을 선택할 수 있게 하는 UIBarButtonItem
final class ColorPickerItem: UIBarButtonItem {

    // MARK: - Properties

    var delegate: ColorPickerDelegate? {
        get { self.colorPicker.delegate }
        set { self.colorPicker.delegate = newValue }
    }

    /// 컬러 피커
    private let colorPicker = ColorPicker()


    // MARK: - Init(s)

    override init() {
        super.init()

        self.configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        self.configure()
    }


    // MARK: - Functions

    /// 뷰 초기화
    private func configure() {
        self.customView = self.colorPicker
        self.title = nil
    }
}

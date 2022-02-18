//
//  BottleImageView.swift
//  Happiggy-bank
//
//  Created by sun on 2022/02/18.
//

import UIKit

/// Bottle 의 채워진 정도에 따른 적절한 이미지를 나타내는 뷰
final class BottleImageView: UIImageView {
    override init(image: UIImage?) {
        super.init(image: image)
        self.backgroundColor = .systemYellow
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

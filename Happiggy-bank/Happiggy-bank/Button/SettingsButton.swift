//
//  SettingsButton.swift
//  Happiggy-bank
//
//  Created by 권은빈 on 2022/02/17.
//

import UIKit

class SettingsButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let buttonImage = UIImage(
            systemName: "gearshape",
            withConfiguration: UIImage.SymbolConfiguration(scale: .large)
        )
        self.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        self.setImage(buttonImage, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

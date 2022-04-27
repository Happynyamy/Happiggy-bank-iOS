//
//  UIFont+OverrideSystemFont.swift
//  Happiggy-bank
//
//  Created by sun on 2022/04/23.
//

import UIKit

extension UIFontDescriptor.AttributeName {
    
    static let nsctFontUIUsage = UIFontDescriptor.AttributeName(
        rawValue: "NSCTFontUIUsageAttribute"
    )
}

extension UIFont {
    
    // MARK: - Properties
    
    /// 중복 방지
    private static var isOverrided: Bool = false
    
    /// 오버라이딩할 폰트
    private static var font: CustomFont {
        
        var rawValue = UserDefaults.standard.value(
            forKey: UserDefaults.Key.font.rawValue
        ) as? Int
        let systemFontRawValue = CustomFont.system.rawValue
        
        if rawValue == nil {
            UserDefaults.standard.set(
                systemFontRawValue,
                forKey: UserDefaults.Key.font.rawValue
            )
            rawValue = .zero
        }
        
        let font = CustomFont(rawValue: rawValue ?? systemFontRawValue) ?? CustomFont.system
        return font
    }
    
    // MARK: - Inits
    @objc convenience init(myCoder aDecoder: NSCoder) {
        guard let fontDescriptor = aDecoder.decodeObject(
            forKey: "UIFontDescriptor"
        ) as? UIFontDescriptor,
              let fontAttribute = fontDescriptor.fontAttributes[.nsctFontUIUsage] as? String
        else {
            self.init(myCoder: aDecoder)
            return
        }
        
        var fontName = String.empty
        
        switch fontAttribute {
        case "CTFontRegularUsage":
            fontName = Self.font.regular
        case "CTFontEmphasizedUsage", "CTFontBoldUsage":
            fontName = Self.font.bold
        default:
            fontName = Self.font.regular
        }
        
        self.init(name: fontName, size: fontDescriptor.pointSize)!
    }
    
    // MARK: - @objc
    
    /// 기본 타입을 오버라이딩할 폰트 리턴
    @objc private static func customSystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: font.regular, size: size)!
    }
    
    /// 볼드 타입을 오버라이딩할 폰트 리턴
    @objc private static func customBoldSystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: font.bold, size: size)!
    }
    
    
    // MARK: - Functions
    
    /// method swizzling 을 통해 시스템 폰트를 오버라이딩 함
    static func overrideSystemFont() {
        guard self == UIFont.self,
              !isOverrided
        else { return }
        
        // Avoid method swizzling run twice and revert to original initialize function
        isOverrided = true
        
        if let systemFontMethod = class_getClassMethod(self, #selector(systemFont(ofSize:))),
           let mySystemFontMethod = class_getClassMethod(self, #selector(customSystemFont(ofSize:))) {
            method_exchangeImplementations(systemFontMethod, mySystemFontMethod)
        }
        
        if let boldSystemFontMethod = class_getClassMethod(
            self,
            #selector(boldSystemFont(ofSize:))
        ),
           let myBoldSystemFontMethod = class_getClassMethod(
            self,
            #selector(customBoldSystemFont(ofSize:))
           ) {
            method_exchangeImplementations(boldSystemFontMethod, myBoldSystemFontMethod)
        }
        
        if let initCoderMethod = class_getInstanceMethod(
            self,
            #selector(UIFontDescriptor.init(coder:))
        ), // Trick to get over the lack of UIFont.init(coder:))
           let myInitCoderMethod = class_getInstanceMethod(
            self,
            #selector(UIFont.init(myCoder:))
           ) {
            method_exchangeImplementations(initCoderMethod, myInitCoderMethod)
        }
    }
}

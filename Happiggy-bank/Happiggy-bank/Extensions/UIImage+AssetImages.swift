//
//  UIImage+AssetImages.swift
//  Happiggy-bank
//
//  Created by sun on 2022/02/18.
//

import UIKit

extension UIImage {
    
    // FIXME: 개봉/미개봉 유리병의 이미지가 다르므로 네이밍 변경 필요
    /// bottle 초기 생성시의 이미지
    static let initialBottle = UIImage(named: "initialBottle")
    
    /// bottle 이 0% 이상 ~ 10% 미만으로 채워졌을 때의 이미지
    static let bottle0 = UIImage(named: "bottle0")
    
    /// bottle 이 10% 이상 ~ 30% 미만으로 채워졌을 때의 이미지
    static let bottle10 = UIImage(named: "bottle10")
    
    /// bottle 이 30% 이상 ~ 50% 미만으로 채워졌을 때의 이미지
    static let bottle30 = UIImage(named: "bottle30")
    
    /// bottle 이 50% 이상 ~ 70% 미만으로 채워졌을 때의 이미지
    static let bottle50 = UIImage(named: "bottle50")
    
    /// bottle 이 70% 이상 ~ 100% 미만으로 채워졌을 때의 이미지
    static let bottle70 = UIImage(named: "bottle70")
    
    /// bottle 이 100% 채워졌을 때의 이미지
    static let bottle100 = UIImage(named: "bottle100")
}

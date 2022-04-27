//
//  Presenter.swift
//  Happiggy-bank
//
//  Created by sun on 2022/04/20.
//

import Foundation

/// 자식 뷰컨트롤러를 종료할 때 부모 뷰컨트롤러에게 알리기 위한 프로토콜
protocol Presenter: AnyObject {
    
    /// 자식 뷰 컨트롤러가 종료되었음을 알리는 메서드
    func presentedViewControllerDidDismiss(withResult: Result)
}

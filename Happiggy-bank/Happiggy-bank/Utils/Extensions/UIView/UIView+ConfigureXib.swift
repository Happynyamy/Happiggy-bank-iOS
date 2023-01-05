//
//  UIView+ConfigureXib.swift
//  NoteViewPractice
//
//  Created by sun on 2022/10/19.
//

import UIKit

extension UIView {

    /// nib 파일로부터 뷰 인스턴스를 생성하는 메서드
    private func loadViewFromNib(nib: String) -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nib, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }

    /// xib 레이아웃 설정하는 메서드
    func configureXib() {
        guard let view = self.loadViewFromNib(nib: Self.name)
        else { return }

        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
    }
}

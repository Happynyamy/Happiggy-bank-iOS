//
//  PageContentViewController.swift
//  Happiggy-bank
//
//  Created by 권은빈 on 2022/02/16.
//

import UIKit

class PageContentViewController: UIViewController {
    var imageView: UIImageView!
    var imageName: String!
    var index: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureImageView()
        configureConstraints()
    }
    
    private func configureImageView() {
        self.imageView = UIImageView()
        self.imageView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        self.imageView.image = UIImage(named: imageName)
        self.view.addSubview(imageView)
        
    }
    
    private func configureConstraints() {
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.imageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
}

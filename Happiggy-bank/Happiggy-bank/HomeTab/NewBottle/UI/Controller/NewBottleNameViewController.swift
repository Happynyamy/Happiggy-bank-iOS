//
//  NewBottleNameViewController.swift
//  Happiggy-bank
//
//  Created by 권은빈 on 2023/02/06.
//

import UIKit

final class NewBottleNameViewController: UIViewController {
    
    // MARK: - Properties
    
    var newBottleNameView: NewBottleNameView = NewBottleNameView()
    
    
    // MARK: - Life Cycles
    
    override func loadView() {
        super.loadView()
        
        self.view = self.newBottleNameView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

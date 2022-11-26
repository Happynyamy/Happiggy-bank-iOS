//
//  PhotoViewController.swift
//  Happiggy-bank
//
//  Created by sun on 2022/11/26.
//

import UIKit

import Then

/// 사진만 띄우는 뷰 컨트롤러
final class PhotoViewController: UIViewController {

    // MARK: - Properties

    private let photoView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.clipsToBounds = true
    }


    // MARK: - Init(s)

    init(photo: UIImage) {
        self.photoView.image = photo
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .systemBackground
        configureSubviews()
    }


    // MARK: - Functions

    private func configureSubviews() {
        self.view.addSubview(self.photoView)
        
        let safeAreaLayoutGuide = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.photoView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            self.photoView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            self.photoView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            self.photoView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

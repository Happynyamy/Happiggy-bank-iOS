//
//  BottleViewController.swift
//  Happiggy-bank
//
//  Created by 권은빈 on 2022/02/16.
//

import UIKit

// TODO: 진행중인 유리병 있는지 없는지에 따라 초기 화면 구성 및 동작 수행 필요
/// 각 bottle 의 뷰를 관리하는 컨트롤러
final class BottleViewController: UIViewController {
    
    // MARK: - @IBOutlet

    /// 유리병 이미지를 보여주는 뷰
    @IBOutlet var imageView: BottleImageView!
    
    
    // MARK: - Properties
    
    /// BottleViewController 에 필요한 형태로 데이터를 가공해주는 View Model
    var viewModel: BottleViewModel!
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addObservers()
        configureBottleImage()
    }
    
    
    // MARK: - @IBActions
    
    /// 저금통 이미지를 탭할 시 실행되는 메서드
    /// 1. 저금통이 없는 경우 저금통 추가 팝업을 띄우고,
    /// 2. 저금통이 있으나 기한이 종료되어 개봉을 기다리는 경우 저금통을 개봉하고
    /// 3 - 1. 저금통이 있고 아직 진행중인 경우에는 쪽지를 쓸 수 있는 날이 있는 경우 쪽지 추가 팝업을,
    /// 3 - 2. 그 외에는 쪽지 작성 불가 알림을 띄운다.
    @IBAction func bottleDidTap(_ sender: UITapGestureRecognizer) {
        guard let bottle = self.viewModel.bottle
        else {
            print("show add new bottle popup")
            return
        }
        if !bottle.isInProgress {
            print("show some opening animation")
            return
        }
        if !bottle.hasEmptyDate {
            print("show some alert that no notes are writable")
            return
        }
        if bottle.hasEmptyDate {
            /// 날짜 피커 띄우기
            self.performSegue(
                withIdentifier: SegueIdentifier.presentNewNoteDatePicker,
                sender: sender
            )
        }
    }
    
    /// 현재 뷰 컨트롤러로 unwind 하라는 호출을 받았을 때 실행되는 액션메서드
    @IBAction func unwindCallDidArrive(segue: UIStoryboardSegue) {}
    
    
    // MARK: - @objc
    
    /// 쪽지 진행 정도가 바뀌었다는 알림을 받았을 때 호출되는 메서드
    @objc private func noteProgressDidChange(_ notification: Notification) {
        self.view.backgroundColor = .systemBrown
        print("show note adding animation")
    }
    
    
    // MARK: - Functions
    
    /// NotificationCenter.default 에 observer 들을 추가
    private func addObservers() {
        self.observe(
            selector: #selector(noteProgressDidChange(_:)),
            name: .noteProgressDidUpdate
        )
    }
    
    /// 저금통 상태에 따른 저금통 이미지/애니메이션 등을 나타냄
    /// 저금통을 새로 추가하는 경우, 현재 진행중인 저금통이 있는 경우, 개봉을 기다리는 경우의 세 가지 상태가 있음
    private func configureBottleImage() {
        guard let bottle = self.viewModel.bottle
        else {
            print("show add new bottle image")
            self.imageView.backgroundColor = .systemIndigo
            return
        }
        
        /// 현재 채우는 저금통 있음
        if bottle.isInProgress {
            print("show bottle in progress")
            self.imageView.backgroundColor = .systemYellow
            return
        }
        
        /// 기한 종료로 개봉 대기중
        if !bottle.isInProgress {
            print("show bottle ready to open")
            self.imageView.backgroundColor = .orange
        }
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.presentNewNoteDatePicker {
            guard let datePickerViewController = segue.destination as? NewNoteDatePickerViewController,
                  let bottle = self.viewModel.bottle
            else { return }
            
            let viewModel = NewNoteDatePickerViewModel()
            viewModel.bottle = bottle
            datePickerViewController.viewModel = viewModel
        }
    }
}

//
//  BottleCell.swift
//  Happiggy-bank
//
//  Created by 권은빈 on 2022/02/28.
//

import UIKit

import Then

/// 저금통 리스트의 셀
final class BottleCell: UITableViewCell {
    
    // MARK: - Properties
    
    /// 저금통 제목 라벨
    @IBOutlet weak var bottleTitleLabel: UILabel!

    /// 저금통 기간 라벨
    @IBOutlet weak var bottleDateLabel: UILabel!
    
    /// 그리드 프레임 역할을 할 컨테이너 뷰
    @IBOutlet weak var gridContainerView: UIView!
    
    /// 그리드 컨테이너 뷰 top constraint
    @IBOutlet weak var gridContainerTopConstraint: NSLayoutConstraint!
    
    /// 쪽지를 채울 그리드 
    private var grid = Grid()
    
    // TODO: 불필요할수도?
    /// 그리드 각 셀에 들어있는 노트 이미지 뷰
    private var noteViews = [UIView]()
    
    
    // MARK: - override func
    
    override func awakeFromNib() {
        configureLabels()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.gridContainerTopConstraint.constant = Metric.gridTopConstraintConstant

        contentView.frame = contentView.frame.inset(
            by: UIEdgeInsets(
                top: Metric.cellSpacing,
                left: Metric.horizontalPadding,
                bottom: .zero,
                right: Metric.horizontalPadding
            )
        )
    }
    
    
    // MARK: - cell settings
    
    /// 유리병 내부 영역을 직사각형의 그리드로 나누고 쪽지 이미지로 채움
    func fillGrid(withNotes notes: [Note], duration: Int) {
        self.layoutIfNeeded()
        
        self.grid = Grid(frame: self.gridContainerView.bounds, cellCount: duration)
        
        for index in 0..<notes.count {
            let note = notes[index]
            let noteContainerView = UIView(frame: self.grid[index] ?? .zero).then {
                $0.layer.zPosition = Metric.randomZpostion
            }
            
            let imageView = UIImageView(image: .note(color: note.color)).then {
                $0.frame.size = noteContainerView.bounds.size
                
                /// 크기 조정
                let randomScale = Metric.randomScale
                $0.transform = $0.transform.scaledBy(x: randomScale, y: randomScale)
                
                /// 회전
                $0.transform = $0.transform.rotated(by: Metric.randomDegree)
            }
            
            noteContainerView.addSubview(imageView)
            self.gridContainerView.addSubview(noteContainerView)
            self.noteViews.append(noteContainerView)
        }
    }
    
    /// 셀 재사용을 위해 그리드와 쪽지 뷰들 초기화
    func resetAttributes() {
        self.grid = Grid()
        self.noteViews.forEach { $0.removeFromSuperview() }
        self.noteViews = []
    }
    
    /// 셀 라벨 폰트사이즈, 색상 설정
    private func configureLabels() {
        self.bottleTitleLabel.font = .systemFont(ofSize: FontSize.titleLabel)
        self.bottleDateLabel.font = .systemFont(ofSize: FontSize.dateLabel)
        self.bottleDateLabel.textColor = UIColor(hex: Color.dateLabelText)
    }
}

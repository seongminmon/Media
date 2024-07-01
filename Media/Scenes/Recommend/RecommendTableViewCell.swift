//
//  RecommendTableViewCell.swift
//  Media
//
//  Created by 김성민 on 6/25/24.
//

import UIKit
import SnapKit

final class RecommendTableViewCell: BaseTableViewCell {
    
    let titleLabel = UILabel()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: BaseCollectionViewCell.recommendCollectionViewLayout())
    
    override func addSubviews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(collectionView)
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(20)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.horizontalEdges.bottom.equalTo(contentView.safeAreaLayoutGuide)
            make.height.equalTo(220)
        }
    }
    
    override func configureView() {
        titleLabel.font = .boldSystemFont(ofSize: 17)
    }
    
    func configureCell(title: String) {
        titleLabel.text = title
    }
}

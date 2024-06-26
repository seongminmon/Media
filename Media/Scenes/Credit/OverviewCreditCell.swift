//
//  OverviewCreditCell.swift
//  Media
//
//  Created by 김성민 on 6/24/24.
//

import UIKit

class OverviewCreditCell: BaseTableViewCell {
    
    let descriptionLabel = UILabel()
    let seeMoreButton = UIButton()
    
    override func addSubviews() {
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(seeMoreButton)
    }
    
    override func configureLayout() {
        descriptionLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        
        seeMoreButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(8)
            make.size.equalTo(30)
            make.centerX.equalToSuperview()
        }
    }
    
    override func configureView() {
        descriptionLabel.font = .systemFont(ofSize: 13)
        descriptionLabel.numberOfLines = 0
        
        seeMoreButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        seeMoreButton.tintColor = .black
    }
    
    func configureCell(_ data: String?) {
        descriptionLabel.text = data
    }
}

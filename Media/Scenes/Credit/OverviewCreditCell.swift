//
//  OverviewCreditCell.swift
//  Media
//
//  Created by 김성민 on 6/24/24.
//

import UIKit

class OverviewCreditCell: UITableViewCell {
    
    let descriptionLabel = UILabel()
    let seeMoreButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(seeMoreButton)
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        
        seeMoreButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(8)
            make.size.equalTo(30)
            make.centerX.equalToSuperview()
        }
        
        descriptionLabel.font = .systemFont(ofSize: 13)
        descriptionLabel.numberOfLines = 0
        
        seeMoreButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        seeMoreButton.tintColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(_ data: String?) {
        descriptionLabel.text = data
    }
}

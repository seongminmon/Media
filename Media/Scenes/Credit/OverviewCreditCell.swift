//
//  OverviewCreditCell.swift
//  Media
//
//  Created by 김성민 on 6/24/24.
//

import UIKit

protocol OverviewCellDelegate {
    func seeMoreButtonTapped()
}

class OverviewCreditCell: BaseTableViewCell {
    
    let descriptionLabel = UILabel()
    let seeMoreButton = UIButton()
    
    var isDetail: Bool = false
    var delegate: OverviewCellDelegate?
    
    override func addSubviews() {
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(seeMoreButton)
    }
    
    override func configureLayout() {
        descriptionLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(16)
        }
        
        seeMoreButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(8)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide)
            make.size.equalTo(30)
            make.centerX.equalToSuperview()
        }
    }
    
    override func configureView() {
        descriptionLabel.font = .systemFont(ofSize: 13)
        descriptionLabel.numberOfLines = 2
        
        seeMoreButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        seeMoreButton.tintColor = .black
        seeMoreButton.addTarget(self, action: #selector(seeMoreButtonTapped), for: .touchUpInside)
    }
    
    @objc func seeMoreButtonTapped() {
        print(#function)
        isDetail.toggle()
        if isDetail {
            descriptionLabel.numberOfLines = 0
            seeMoreButton.setImage(UIImage(systemName: "chevron.up"), for: .normal)
        } else {
            descriptionLabel.numberOfLines = 2
            seeMoreButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        }
        delegate?.seeMoreButtonTapped()
    }
    
    func configureCell(_ data: String?) {
        descriptionLabel.text = data
    }
}

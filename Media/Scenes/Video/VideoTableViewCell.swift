//
//  VideoTableViewCell.swift
//  Media
//
//  Created by 김성민 on 7/1/24.
//

import UIKit
import SnapKit

final class VideoTableViewCell: BaseTableViewCell {
    
    let titleLabel = UILabel()
    let detailImageView = UIImageView()
    
    override func addSubviews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailImageView)
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.safeAreaLayoutGuide)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(16)
            make.trailing.equalTo(detailImageView.snp.leading).offset(16)
        }
        
        detailImageView.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.safeAreaLayoutGuide)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(16)
            make.size.equalTo(20)
        }
    }
    
    override func configureView() {
        titleLabel.font = .boldSystemFont(ofSize: 17)
        
        detailImageView.image = UIImage(systemName: "chevron.right")
        detailImageView.contentMode = .scaleAspectFit
        detailImageView.tintColor = .gray
    }
    
    func configureCell(_ name: String) {
        titleLabel.text = name
    }
}

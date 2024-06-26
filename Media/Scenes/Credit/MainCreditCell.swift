//
//  MainCreditCell.swift
//  Media
//
//  Created by 김성민 on 6/24/24.
//

import UIKit

class MainCreditCell: BaseTableViewCell {
    
    let backgroundImageView = UIImageView()
    let posterImageView = UIImageView()
    let titleLabel = UILabel()
    
    override func addSubviews() {
        contentView.addSubview(backgroundImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(posterImageView)
    }
    
    override func configureLayout() {
        backgroundImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(posterImageView.snp.top).offset(-8)
            make.height.equalTo(40)
        }
        
        posterImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(8)
            make.width.equalTo(80)
            make.height.equalTo(100)
        }
    }
    
    override func configureView() {
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.backgroundColor = .gray
        
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.backgroundColor = .gray
        
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.textColor = .white
    }
    
    func configureCell(_ data: Movie?) {
        guard let data else { return }
        backgroundImageView.kf.setImage(with: data.backdropImageURL)
        posterImageView.kf.setImage(with: data.posterImageURL)
        titleLabel.text = data.title
    }
}

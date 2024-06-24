//
//  MainCreditCell.swift
//  Media
//
//  Created by 김성민 on 6/24/24.
//

import UIKit

class MainCreditCell: UITableViewCell {
    
    let backgroundImageView = UIImageView()
    let posterImageView = UIImageView()
    let titleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(backgroundImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(posterImageView)
        
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
        
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.backgroundColor = .gray
        
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.backgroundColor = .gray
        
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.textColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(_ data: Movie?) {
        guard let data else { return }
        backgroundImageView.kf.setImage(with: data.backdropImageURL)
        posterImageView.kf.setImage(with: data.posterImageURL)
        titleLabel.text = data.title
    }
}

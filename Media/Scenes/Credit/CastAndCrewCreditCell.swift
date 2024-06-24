//
//  CastAndCrewCreditCell.swift
//  Media
//
//  Created by 김성민 on 6/24/24.
//

import UIKit

class CastAndCrewCreditCell: UITableViewCell {
    
    let profileImageView = UIImageView()
    let nameLabel = UILabel()
    let detailLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        setLayout()
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(detailLabel)
    }
    
    func setLayout() {
        profileImageView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(8)
            make.leading.equalToSuperview().inset(16)
            make.width.equalTo(profileImageView.snp.height).multipliedBy(0.8)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(16)
            make.leading.equalTo(profileImageView.snp.trailing).offset(16)
            make.height.equalTo(30)
        }
        
        detailLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.leading.equalTo(profileImageView.snp.trailing).offset(16)
            make.trailing.bottom.equalToSuperview().inset(16)
        }
    }
    
    func setUI() {
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.backgroundColor = .gray
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 10
        
        nameLabel.font = .boldSystemFont(ofSize: 14)
        
        detailLabel.font = .systemFont(ofSize: 13)
        detailLabel.textColor = .lightGray
    }
    
    func configureCellWithCast(_ data: Cast?) {
        guard let data else { return }
        profileImageView.kf.setImage(with: data.posterImageURL)
        nameLabel.text = data.name
        detailLabel.text = data.character
    }
    
    func configureCellWithCrew(_ data: Cast?) {
        guard let data else { return }
        profileImageView.kf.setImage(with: data.posterImageURL)
        nameLabel.text = data.name
        detailLabel.text = data.knownForDepartment
    }
}

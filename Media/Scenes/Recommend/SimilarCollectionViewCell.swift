//
//  SimilarCollectionViewCell.swift
//  Media
//
//  Created by 김성민 on 6/24/24.
//

import UIKit
import SnapKit

class SimilarCollectionViewCell: UICollectionViewCell {
    
    let profileImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setLayout()
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews() {
        contentView.addSubview(profileImageView)
    }
    
    func setLayout() {
        profileImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setUI() {
        profileImageView.backgroundColor = .gray
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 10
    }
    
    func configureCell(_ data: Movie?) {
        profileImageView.kf.setImage(with: data?.posterImageURL)
    }
}

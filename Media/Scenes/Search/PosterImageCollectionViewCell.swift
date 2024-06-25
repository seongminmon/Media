//
//  SearchCollectionViewCell.swift
//  Media
//
//  Created by 김성민 on 6/24/24.
//

import UIKit
import Kingfisher
import SnapKit

// MARK: - 재활용 (검색, 비슷한 영화, 추천 영화, 포스터)
class PosterImageCollectionViewCell: UICollectionViewCell {
    
    let posterImageView = UIImageView()
    
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
        contentView.addSubview(posterImageView)
    }
    
    func setLayout() {
        posterImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setUI() {
        posterImageView.backgroundColor = .gray
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 10
    }
    
    func configureCell(_ url: URL?) {
        posterImageView.kf.setImage(with: url)
    }
}


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
class PosterImageCollectionViewCell: BaseCollectionViewCell {
    
    let posterImageView = UIImageView()

    override func addSubviews() {
        contentView.addSubview(posterImageView)
    }
    
    override func configureLayout() {
        posterImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureView() {
        posterImageView.backgroundColor = .gray
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 10
    }
    
    func configureCell(_ url: URL?) {
        posterImageView.kf.setImage(with: url)
    }
}


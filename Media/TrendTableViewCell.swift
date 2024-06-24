//
//  TrendTableViewCell.swift
//  Media
//
//  Created by 김성민 on 6/24/24.
//

import UIKit
import Kingfisher
import SnapKit

class TrendTableViewCell: UITableViewCell {
    
    static let identifier = "TrendTableViewCell"
    
    let dateLabel = UILabel()
    let genreLabel = UILabel()
    
    let shadowView = UIView()
    let containerView = UIView()
    let posterImageView = UIImageView()
    let shareButton = UIButton()
    let gradeTitleLabel = UILabel()
    let gradeLabel = UILabel()
    
    let descriptionView = UIView()
    let titleLabel = UILabel()
    let summaryLabel = UILabel()
    let separator = UIView()
    let detailLabel = UILabel()
    let detailButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        setLayout()
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shareButton.clipsToBounds = true
        shareButton.layer.cornerRadius = shareButton.frame.width / 2
    }
    
    func addSubviews() {
        addSubview(dateLabel)
        addSubview(genreLabel)
        
        descriptionView.addSubview(titleLabel)
        descriptionView.addSubview(summaryLabel)
        descriptionView.addSubview(separator)
        descriptionView.addSubview(detailLabel)
        descriptionView.addSubview(detailButton)
        
        containerView.addSubview(posterImageView)
        containerView.addSubview(shareButton)
        containerView.addSubview(gradeTitleLabel)
        containerView.addSubview(gradeLabel)
        containerView.addSubview(descriptionView)
        
        shadowView.addSubview(containerView)
        addSubview(shadowView)
    }
    
    func setLayout() {
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).inset(8)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(20)
        }
        
        genreLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(20)
        }
        
        shadowView.snp.makeConstraints { make in
            make.top.equalTo(genreLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(16)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(8)
        }
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        posterImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(posterImageView.snp.width)  // 1:1 비율
        }
        
        shareButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(16)
            make.size.equalTo(30)
        }
        
        gradeTitleLabel.snp.makeConstraints { make in
            make.leading.bottom.equalTo(posterImageView).inset(16)
            make.width.equalTo(40)
            make.height.equalTo(20)
        }
        
        gradeLabel.snp.makeConstraints { make in
            make.leading.equalTo(gradeTitleLabel.snp.trailing)
            make.bottom.equalTo(gradeTitleLabel)
            make.width.equalTo(40)
            make.height.equalTo(20)
        }
        
        descriptionView.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(8)
            make.height.equalTo(20)
        }
        
        summaryLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(8)
            make.bottom.equalTo(separator.snp.top).offset(-8)
        }
        
        separator.snp.makeConstraints { make in
            make.bottom.equalTo(detailButton.snp.top).offset(-4)
            make.horizontalEdges.equalToSuperview().inset(8)
            make.height.equalTo(1)
        }
        
        detailLabel.snp.makeConstraints { make in
            make.top.equalTo(detailButton)
            make.leading.bottom.equalToSuperview().inset(8)
            make.trailing.equalTo(detailButton.snp.leading).offset(-8)
        }
        
        detailButton.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(8)
            make.size.equalTo(25)
        }
        
    }
    
    func setUI() {
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = .zero
        shadowView.layer.shadowRadius = 10
        shadowView.layer.shadowOpacity = 0.9
        
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 10
        
        dateLabel.font = .systemFont(ofSize: 13)
        dateLabel.textColor = .gray
        
        genreLabel.font = .boldSystemFont(ofSize: 14)
        
        posterImageView.contentMode = .scaleAspectFill
        
        shareButton.setImage(UIImage(systemName: "paperclip"), for: .normal)
        shareButton.tintColor = .black
        shareButton.backgroundColor = .white
        
        gradeTitleLabel.text = "평점"
        gradeTitleLabel.font = .systemFont(ofSize: 14)
        gradeTitleLabel.textColor = .white
        gradeTitleLabel.backgroundColor = .systemIndigo
        gradeTitleLabel.textAlignment = .center
        
        gradeLabel.font = .systemFont(ofSize: 14)
        gradeLabel.textColor = .systemIndigo
        gradeLabel.backgroundColor = .white
        gradeLabel.textAlignment = .center
        
        descriptionView.backgroundColor = .white
        
        titleLabel.font = .boldSystemFont(ofSize: 15)
        
        summaryLabel.font = .systemFont(ofSize: 14)
        summaryLabel.numberOfLines = 2
        
        separator.backgroundColor = .black
        
        detailLabel.text = "자세히 보기"
        detailLabel.font = .systemFont(ofSize: 14)
        
        detailButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        detailButton.tintColor = .black
    }
    
    func configureCell(data: Movie?) {
        guard let data else { return }
        dateLabel.text = data.dateString
        genreLabel.text = data.genreText
        posterImageView.kf.setImage(with: data.posterImageURL)
        gradeLabel.text = data.grade
        titleLabel.text = data.title
        summaryLabel.text = data.overview
    }
}

//
//  NasaViewController.swift
//  Media
//
//  Created by 김성민 on 7/1/24.
//

import UIKit
import SnapKit

final class NasaViewController: BaseViewController {
    
    let nasaImageView = UIImageView()
    let progressLabel = UILabel()
    let requestButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureNavigationBar() {
        navigationItem.title = "Nasa 이미지 가져오기"
    }
    
    override func addSubviews() {
        view.addSubview(nasaImageView)
        view.addSubview(progressLabel)
        view.addSubview(requestButton)
    }
    
    override func configureLayout() {
        nasaImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(nasaImageView.snp.width)
        }
        
        progressLabel.snp.makeConstraints { make in
            make.top.equalTo(nasaImageView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        
        requestButton.snp.makeConstraints { make in
            make.top.equalTo(progressLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
    }
    
    override func configureView() {
        nasaImageView.image = UIImage(systemName: "star")
        nasaImageView.tintColor = .black
        
        progressLabel.text = "진행 상황이 표시됩니다."
        progressLabel.font = .boldSystemFont(ofSize: 20)
        progressLabel.textAlignment = .center
        
        requestButton.setTitle("랜덤 이미지 불러오기", for: .normal)
        requestButton.setTitleColor(.white, for: .normal)
        requestButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        requestButton.backgroundColor = .systemPink
        requestButton.layer.cornerRadius = 25
        requestButton.addTarget(self, action: #selector(requestButtonClicked), for: .touchUpInside)
    }
    
    @objc func requestButtonClicked() {
        print(#function)
    }
    
}

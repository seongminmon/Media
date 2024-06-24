//
//  RecommendViewController.swift
//  Media
//
//  Created by 김성민 on 6/24/24.
//

import UIKit
import Alamofire
import SnapKit

class RecommendViewController: UIViewController {
    
    let similarLabel = UILabel()
    lazy var similarCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    
    let recommendLabel = UILabel()
    lazy var recommendCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    
    // 이전 화면에서 전달
    var navTitle: String?
    var movieid: Int?
    
    // 네트워크로 전달
    var similarMovieResponse: MovieResponse?
    var similarPage = 1 // 페이지네이션 위한 변수
    var recommendMovieResponse: MovieResponse?
    var recommendPage = 1 // 페이지네이션 위한 변수
    
    override func viewDidLoad() {
        super.viewDidLoad()
        similarCallRequest(movieid: movieid ?? 0, page: similarPage)
        recommendCallRequest(movieid: movieid ?? 0, page: recommendPage)
        
        setNavi()
        addSubviews()
        setLayout()
        setCollectionView()
        setUI()
    }
    
    func setNavi() {
        navigationItem.title = navTitle
    }
    
    func addSubviews() {
        view.addSubview(similarLabel)
        view.addSubview(similarCollectionView)
        view.addSubview(recommendLabel)
        view.addSubview(recommendCollectionView)
    }
    
    func setLayout() {
        similarLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(20)
        }
        
        similarCollectionView.snp.makeConstraints { make in
            make.top.equalTo(similarLabel.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(220)
        }
        
        recommendLabel.snp.makeConstraints { make in
            make.top.equalTo(similarCollectionView.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(20)
        }
        
        recommendCollectionView.snp.makeConstraints { make in
            make.top.equalTo(recommendLabel.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(220)
        }
    }
    
    func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        
        let sectionSpacing: CGFloat = 10
        let cellSpacing: CGFloat = 10
        
        layout.itemSize = CGSize(width: 150, height: 200)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = cellSpacing
        layout.minimumLineSpacing = cellSpacing
        layout.sectionInset = UIEdgeInsets(top: sectionSpacing, left: sectionSpacing, bottom: sectionSpacing, right: sectionSpacing)
        
        return layout
    }
    
    func setUI() {
        view.backgroundColor = .black
        similarLabel.text = "비슷한 영화"
        similarLabel.font = .boldSystemFont(ofSize: 16)
        similarLabel.textColor = .white
        
        recommendLabel.text = "추천 영화"
        recommendLabel.font = .boldSystemFont(ofSize: 16)
        recommendLabel.textColor = .white
    }
    
    func setCollectionView() {
        similarCollectionView.delegate = self
        similarCollectionView.dataSource = self
        similarCollectionView.prefetchDataSource = self
        similarCollectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.identifier)
        similarCollectionView.backgroundColor = .clear
        similarCollectionView.showsHorizontalScrollIndicator = false
        
        recommendCollectionView.delegate = self
        recommendCollectionView.dataSource = self
        recommendCollectionView.prefetchDataSource = self
        recommendCollectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.identifier)
        recommendCollectionView.backgroundColor = .clear
        recommendCollectionView.showsHorizontalScrollIndicator = false
    }
    
    func similarCallRequest(movieid: Int, page: Int) {
        NetworkManager.shared.similarRequest(movieId: movieid, page: page) { result in
            switch result {
            case .success(let value):
                self.similarSuccessAction(value: value)
            case .failure(let error):
                self.similarFailureAction(error: error)
            }
        }
    }
    
    func similarSuccessAction(value: MovieResponse) {
        print("SUCCESS")
        if similarPage == 1 {
            // 첫 검색일때 -> 교체
            similarMovieResponse = value
        } else {
            // 페이지네이션일때 -> 추가
            similarMovieResponse?.movieList.append(contentsOf: value.movieList)
        }
        
        similarCollectionView.reloadData()
        
        // 스크롤 맨위로 올리기
        if let movieList = similarMovieResponse?.movieList, !movieList.isEmpty, similarPage == 1 {
            similarCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
        }
    }
    
    func similarFailureAction(error: AFError) {
        dump(error)
    }
    
    func recommendCallRequest(movieid: Int, page: Int) {
        NetworkManager.shared.recommendRequest(movieId: movieid, page: page) { result in
            switch result {
            case .success(let value):
                self.recommendSuccessAction(value: value)
            case .failure(let error):
                self.recommendFailureAction(error: error)
            }
        }
    }
    
    func recommendSuccessAction(value: MovieResponse) {
        print("SUCCESS")
        if recommendPage == 1 {
            // 첫 검색일때 -> 교체
            recommendMovieResponse = value
        } else {
            // 페이지네이션일때 -> 추가
            recommendMovieResponse?.movieList.append(contentsOf: value.movieList)
        }
        
        recommendCollectionView.reloadData()
        
        // 스크롤 맨위로 올리기
        if let movieList = recommendMovieResponse?.movieList, !movieList.isEmpty, recommendPage == 1 {
            recommendCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
        }
    }
    
    func recommendFailureAction(error: AFError) {
        dump(error)
    }
}

extension RecommendViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == similarCollectionView {
            return similarMovieResponse?.movieList.count ?? 0
        } else {
            return recommendMovieResponse?.movieList.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == similarCollectionView {
            let cell = similarCollectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.identifier, for: indexPath) as! SearchCollectionViewCell
            let data = similarMovieResponse?.movieList[indexPath.item]
            cell.configureCell(data)
            return cell
        } else {
            let cell = recommendCollectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.identifier, for: indexPath) as! SearchCollectionViewCell
            let data = recommendMovieResponse?.movieList[indexPath.item]
            cell.configureCell(data)
            return cell
        }
    }
}

extension RecommendViewController: UICollectionViewDataSourcePrefetching {
    // 페이지네이션
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        print(indexPaths)
        if collectionView == similarCollectionView {
            guard let similarMovieResponse else { return }
            for indexPath in indexPaths {
                if indexPath.item == similarMovieResponse.movieList.count - 2,
                   similarPage < similarMovieResponse.totalPages {
                    similarPage += 1
                    similarCallRequest(movieid: movieid ?? 0, page: similarPage)
                }
            }
        } else {
            guard let recommendMovieResponse else { return }
            for indexPath in indexPaths {
                if indexPath.item == recommendMovieResponse.movieList.count - 2,
                   recommendPage < recommendMovieResponse.totalPages {
                    recommendPage += 1
                    recommendCallRequest(movieid: movieid ?? 0, page: recommendPage)
                }
            }
        }
    }
}

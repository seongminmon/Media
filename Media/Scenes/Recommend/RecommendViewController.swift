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

    // 이전 화면에서 전달
    var navTitle: String?
    var movieid: Int?
    
    // 네트워크로 전달
    var similarMovieResponse: MovieResponse?
    var similarPage = 1 // 페이지네이션 위한 변수
    
    override func viewDidLoad() {
        super.viewDidLoad()
        similarCallRequest(movieid: movieid ?? 0, page: similarPage)
        
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
    }
    
    func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        
        let sectionSpacing: CGFloat = 10
        let cellSpacing: CGFloat = 10
        
        // 셀 사이즈
        layout.itemSize = CGSize(width: 150, height: 200)
        // 스크롤 방향
        layout.scrollDirection = .horizontal
        // 셀 사이 거리 (가로)
        layout.minimumInteritemSpacing = cellSpacing
        // 셀 사이 거리 (세로)
        layout.minimumLineSpacing = cellSpacing
        // 섹션 인셋
        layout.sectionInset = UIEdgeInsets(top: sectionSpacing, left: sectionSpacing, bottom: sectionSpacing, right: sectionSpacing)
        
        return layout
    }
    
    func setUI() {
        view.backgroundColor = .black
        similarLabel.text = "비슷한 영화"
        similarLabel.font = .boldSystemFont(ofSize: 16)
        similarLabel.textColor = .white
    }
    
    func setCollectionView() {
        similarCollectionView.delegate = self
        similarCollectionView.dataSource = self
        similarCollectionView.prefetchDataSource = self
        similarCollectionView.register(SimilarCollectionViewCell.self, forCellWithReuseIdentifier: SimilarCollectionViewCell.identifier)
        similarCollectionView.backgroundColor = .clear
        similarCollectionView.showsHorizontalScrollIndicator = false
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
        dump(value)
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

}

extension RecommendViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return similarMovieResponse?.movieList.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = similarCollectionView.dequeueReusableCell(withReuseIdentifier: SimilarCollectionViewCell.identifier, for: indexPath) as! SimilarCollectionViewCell
        let data = similarMovieResponse?.movieList[indexPath.item]
        cell.configureCell(data)
        return cell
    }
    
}

extension RecommendViewController: UICollectionViewDataSourcePrefetching {
    // 페이지네이션
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        print(indexPaths)
        guard let similarMovieResponse else { return }
        for indexPath in indexPaths {
            if indexPath.item == similarMovieResponse.movieList.count - 2,
               similarPage < similarMovieResponse.totalPages {
                similarPage += 1
                similarCallRequest(movieid: movieid ?? 0, page: similarPage)
            }
        }
    }
}

//
//  SearchViewController.swift
//  Media
//
//  Created by 김성민 on 6/24/24.
//

import UIKit
import Alamofire
import SnapKit

class SearchViewController: UIViewController {
    
    let searchBar = UISearchBar()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    
    var movieResponse: MovieResponse?
    var page = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavi()
        addSubviews()
        setLayout()
        setUI()
        setCollectionView()
    }
    
    func setNavi() {
        navigationItem.title = "영화 검색"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    func addSubviews() {
        view.addSubview(searchBar)
        view.addSubview(collectionView)
    }
    
    func setLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let width = (UIScreen.main.bounds.width - 40) / 3
        layout.itemSize = CGSize(width: width, height: width * 1.5)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return layout
    }
    
    func setUI() {
        view.backgroundColor = .black
        collectionView.backgroundColor = .black
        
        searchBar.delegate = self
        // placeholder color
        let placeholder = "영화 제목을 검색해보세요"
        let attributedString = NSMutableAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15),
                         NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        searchBar.searchTextField.attributedPlaceholder = attributedString
        // text color
        searchBar.searchTextField.textColor = .white
        // background color
        searchBar.barTintColor = .black
        // textfield color
        searchBar.searchTextField.backgroundColor = .darkGray
        // 커서 color
        searchBar.tintColor = .lightGray
        // icon color
        searchBar.searchTextField.leftView?.tintColor = .lightGray
    }
    
    func setCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        
        collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.identifier)
    }
    
    func callRequest(query: String, page: Int) {
        NetworkManager.shared.searchRequest(query: query, page: page) { result in
            switch result {
            case .success(let value):
                self.successAction(value: value)
            case .failure(let error):
                self.failureAction(error: error)
            }
        }
    }
    
    func successAction(value: MovieResponse) {
        print("SUCCESS")
        if page == 1 {
            // 첫 검색일때 -> 교체
            movieResponse = value
        } else {
            // 페이지네이션일때 -> 추가
            movieResponse?.movieList.append(contentsOf: value.movieList)
        }
        
        collectionView.reloadData()
        
        // 스크롤 맨위로 올리기
        if let movieList = movieResponse?.movieList, !movieList.isEmpty, page == 1 {
            collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
        }
    }
    
    func failureAction(error: AFError) {
        print("ERROR")
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // 페이지 초기화 후 검색
        page = 1
        callRequest(query: searchBar.text!, page: page)
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieResponse?.movieList.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.identifier, for: indexPath) as! SearchCollectionViewCell
        let data = movieResponse?.movieList[indexPath.item]
        cell.configureCell(data)
        return cell
    }
}

extension SearchViewController: UICollectionViewDataSourcePrefetching {
    // 페이지네이션
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        guard let movieResponse else { return }
        for indexPath in indexPaths {
            if indexPath.item == movieResponse.movieList.count - 2,
               page < movieResponse.totalPages {
                page += 1
                callRequest(query: searchBar.text!, page: page)
            }
        }
    }
}

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
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 220
        tableView.register(RecommendTableViewCell.self, forCellReuseIdentifier: RecommendTableViewCell.identifier)
        return tableView
    }()
    
    // 이전 화면에서 전달
    var navTitle: String?
    var movieid: Int?
    
    var titleList: [String] = ["비슷한 영화", "추천 영화", "포스터"]
    // 네트워크로 전달
    var movieResponseList: [MovieResponse?] = [
        MovieResponse(page: 0, movieList: [], totalPages: 0, totalResults: 0),
        MovieResponse(page: 0, movieList: [], totalPages: 0, totalResults: 0),
        MovieResponse(page: 0, movieList: [], totalPages: 0, totalResults: 0),
    ]
    var pageList: [Int] = [1, 1, 1]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        setNavi()
        addSubviews()
        setLayout()
        configureView()
    }
    
    func setNavi() {
        navigationItem.title = navTitle
    }
    
    func addSubviews() {
        view.addSubview(tableView)
    }
    
    func setLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureView() {
        view.backgroundColor = .white
    }
    
    func fetchData() {
        let group = DispatchGroup()
        
        // 비슷한 영화 네트워크 통신
        group.enter()
        DispatchQueue.global().async(group: group) {
            NetworkManager.shared.similarRequest(movieId: self.movieid ?? 0, page: self.pageList[0]) { result in
                switch result {
                case .success(let value):
                    self.movieResponseList[0] = value
                    
                case .failure(let error):
                    dump(error)
                }
                group.leave()
            }
        }
        
        // 추천 영화 네트워크 통신
        group.enter()
        DispatchQueue.global().async(group: group) {
            NetworkManager.shared.recommendRequest(movieId: self.movieid ?? 0, page: self.pageList[1]) { result in
                switch result {
                case .success(let value):
                    self.movieResponseList[1] = value
                    
                case .failure(let error):
                    dump(error)
                }
                group.leave()
            }
        }
        
        // 포스터 네트워크 통신
        group.enter()
        DispatchQueue.global().async(group: group) {
            NetworkManager.shared.recommendRequest(movieId: self.movieid ?? 0, page: self.pageList[2]) { result in
                switch result {
                case .success(let value):
                    self.movieResponseList[2] = value
                    
                case .failure(let error):
                    dump(error)
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.tableView.reloadData()
        }
    }
}

extension RecommendViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieResponseList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecommendTableViewCell.identifier, for: indexPath) as! RecommendTableViewCell
        let title = titleList[indexPath.row]
        cell.configureCell(title: title)
        
        cell.collectionView.delegate = self
        cell.collectionView.dataSource = self
        cell.collectionView.register(PosterImageCollectionViewCell.self, forCellWithReuseIdentifier: PosterImageCollectionViewCell.identifier)
        cell.collectionView.backgroundColor = .clear
        cell.collectionView.showsHorizontalScrollIndicator = false
        
        // collectionView 태그 설정
        cell.collectionView.tag = indexPath.row
        cell.collectionView.reloadData()
        
        return cell
    }
}

extension RecommendViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieResponseList[collectionView.tag]?.movieList.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterImageCollectionViewCell.identifier, for: indexPath) as! PosterImageCollectionViewCell
        let data = movieResponseList[collectionView.tag]?.movieList[indexPath.row]
        cell.configureCell(data)
        return cell
    }
}

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
    var urlList: [[URL?]] = [[], [], []]
    var pageList: [Int] = [1, 1]
    
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
                    print("similar SUCCESS")
                    self.urlList[0] = value.movieList.map { $0.posterImageURL }
                    
                case .failure(let error):
                    print("similar ERROR")
                    print(error)
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
                    print("recommend SUCCESS")
                    self.urlList[1] = value.movieList.map { $0.posterImageURL }
                    
                case .failure(let error):
                    print("recommend ERROR")
                    print(error)
                }
                group.leave()
            }
        }
        
        // 포스터 네트워크 통신
        group.enter()
        DispatchQueue.global().async(group: group) {
            NetworkManager.shared.posterRequest(movieId: self.movieid ?? 0) { result in
                switch result {
                case .success(let value):
                    print("poster SUCCESS")
                    self.urlList[2] = value.posters.map { $0.posterImageURL }
                    
                case .failure(let error):
                    print("poster ERROR")
                    print(error)
                }
                group.leave()
            }
        }
        
        // 3개의 네트워크 통신 모두 종료한 시점에 한번만 tableview reload
        group.notify(queue: .main) {
            self.tableView.reloadData()
        }
    }
    
}

extension RecommendViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return urlList.count
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
        // 테이블뷰가 리로드될 때 컬렉션뷰도 함께 리로드 시키기
        cell.collectionView.reloadData()
        
        return cell
    }
}

extension RecommendViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urlList[collectionView.tag].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterImageCollectionViewCell.identifier, for: indexPath) as! PosterImageCollectionViewCell
        let data = urlList[collectionView.tag][indexPath.row]
        cell.configureCell(data)
        return cell
    }
}

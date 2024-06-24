//
//  TrendViewController.swift
//  Media
//
//  Created by 김성민 on 6/24/24.
//

import UIKit
import Alamofire
import SnapKit

enum TimeWindow: String {
    case day
    case week
}

class TrendViewController: UIViewController {
    
    let tableView = UITableView()
    
    var timeWindow: TimeWindow = .day {
        didSet {
            navigationItem.title = timeWindow.rawValue
            callRequest()
        }
    }
    var movieResponse: MovieResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callRequest()
        
        setNavi()
        addSubviews()
        setLayout()
        setTableView()
    }
    
    func setNavi() {
        navigationItem.title = "day"
        
        let menuButton = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: #selector(menuButtonTapped))
        navigationItem.leftBarButtonItem = menuButton
        
        let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(searchButtonTapped))
        navigationItem.rightBarButtonItem = searchButton
    }
    
    @objc func menuButtonTapped() {
        print(#function)
        let alert = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .actionSheet
        )
        let day = UIAlertAction(title: TimeWindow.day.rawValue, style: .default) { _ in
            self.timeWindow = .day
        }
        let week = UIAlertAction(title: TimeWindow.week.rawValue, style: .default) { _ in
            self.timeWindow = .week
        }
        alert.addAction(day)
        alert.addAction(week)
        present(alert, animated: true)
    }
    
    @objc func searchButtonTapped() {
        print(#function)
    }
    
    func addSubviews() {
        view.addSubview(tableView)
    }
    
    func setLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UIScreen.main.bounds.width * 1.4
        tableView.register(TrendTableViewCell.self, forCellReuseIdentifier: TrendTableViewCell.identifier)
    }
    
    func callRequest() {
        NetworkManager.shared.trendingRequest(timeWindow: timeWindow.rawValue) { result in
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
        movieResponse = value
        tableView.reloadData()
    }
    
    func failureAction(error: AFError) {
        print("ERROR")
    }
}

extension TrendViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieResponse?.movieList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TrendTableViewCell.identifier, for: indexPath) as! TrendTableViewCell
        let data = movieResponse?.movieList[indexPath.row]
        cell.configureCell(data: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = CreditViewController()
        let movie = movieResponse?.movieList[indexPath.row]
        vc.movie = movie
        navigationController?.pushViewController(vc, animated: true)
    }
}

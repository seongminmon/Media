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

class TrendViewController: BaseViewController {
    
    let tableView = UITableView()
    
    var timeWindow: TimeWindow = .day {
        didSet {
            navigationItem.title = timeWindow.rawValue
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            callRequest()
        }
    }
    var movieList: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callRequest()
    }
    
    override func configureNavigationBar() {
        navigationItem.title = timeWindow.rawValue
        
        let menuButton = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: #selector(menuButtonTapped))
        navigationItem.leftBarButtonItem = menuButton
        
        let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(searchButtonTapped))
        navigationItem.rightBarButtonItem = searchButton
    }
    
    @objc func menuButtonTapped() {
        presentActionSheet(
            title1: TimeWindow.day.rawValue,
            title2: TimeWindow.week.rawValue
        ) { _ in
            self.timeWindow = .day
        } secondAction: { _ in
            self.timeWindow = .week
        }
    }
    
    @objc func searchButtonTapped() {
        let vc = SearchViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func addSubviews() {
        view.addSubview(tableView)
    }
    
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UIScreen.main.bounds.width * 1.4
        tableView.register(TrendTableViewCell.self, forCellReuseIdentifier: TrendTableViewCell.identifier)
    }
    
    func callRequest() {
        NetworkManager.shared.trending(api: .trending(timeWindow: timeWindow)) { data, error in
            if let error = error {
                // 얼럿 띄우기
                self.presentErrorAlert(title: "에러", message: error)
            } else {
                self.movieList = data ?? []
                self.tableView.reloadData()
            }
        }
    }
}

extension TrendViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TrendTableViewCell.identifier, for: indexPath) as! TrendTableViewCell
        let data = movieList[indexPath.row]
        cell.configureCell(data: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = CreditViewController()
        let movie = movieList[indexPath.row]
        vc.movie = movie
        navigationController?.pushViewController(vc, animated: true)
    }
}

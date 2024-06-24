//
//  TrendViewController.swift
//  Media
//
//  Created by 김성민 on 6/24/24.
//

import UIKit
import SnapKit

class TrendViewController: UIViewController {
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkManager.shared.trendingRequest(timeWindow: "day") { result in
            switch result {
            case .success(let value):
                dump(value)
                
            case .failure(let error):
                dump(error)
            }
        }
        
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
        tableView.rowHeight = UIScreen.main.bounds.width * 1.5
        tableView.register(TrendTableViewCell.self, forCellReuseIdentifier: TrendTableViewCell.identifier)
    }
}

extension TrendViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TrendTableViewCell.identifier, for: indexPath) as! TrendTableViewCell
        cell.backgroundColor = .orange
        return cell
    }
    
}

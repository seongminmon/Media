//
//  CreditViewController.swift
//  Media
//
//  Created by 김성민 on 6/24/24.
//

import UIKit
import Alamofire
import Kingfisher
import SnapKit

enum Sections: Int, CaseIterable {
    case main
    case overview
    case cast
    case crew
    
    var headerTitle: String? {
        switch self {
        case .main: nil
        case .overview: "OverView"
        case .cast: "Cast"
        case .crew: "Crew"
        }
    }
    
    var rowHeight: CGFloat {
        switch self {
        case .main: 200
        case .overview: 60
        case .cast: 80
        case .crew: 80
        }
    }
}

class CreditViewController: UIViewController {
    
    let tableView = UITableView()
    
    var movie: Movie?       // 이전 화면에서 전달
    var credit: Credit?     // 네트워크로 받아오기
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callRequest()
        
        setNavi()
        addSubviews()
        setLayout()
        setTableView()
    }
    
    func setNavi() {
        navigationItem.title = "출연/제작"
    }
    
    func addSubviews() {
        view.addSubview(tableView)
    }
    
    func setLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MainCreditCell.self, forCellReuseIdentifier: MainCreditCell.identifier)
        tableView.register(OverviewCreditCell.self, forCellReuseIdentifier: OverviewCreditCell.identifier)
        tableView.register(CastAndCrewCreditCell.self, forCellReuseIdentifier: CastAndCrewCreditCell.identifier)
    }
    
    func callRequest() {
        guard let movie else { return }
        NetworkManager.shared.creditRequest(movieId: movie.id) { result in
            switch result {
            case .success(let value):
                self.successAction(value: value)
            case .failure(let error):
                self.failureAction(error: error)
            }
        }
    }
    
    func successAction(value: Credit) {
        print("SUCCESS")
        credit = value
        tableView.reloadData()
    }
    
    func failureAction(error: AFError) {
        print("ERROR")
    }
}

extension CreditViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Sections.allCases.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Sections.allCases[section].headerTitle
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Sections.allCases[section] {
        case .main, .overview: 1
        case .cast: credit?.cast.count ?? 0
        case .crew: credit?.crew.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Sections.allCases[indexPath.section].rowHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Sections.allCases[indexPath.section] {
        case .main:
            let cell = tableView.dequeueReusableCell(withIdentifier: MainCreditCell.identifier, for: indexPath) as! MainCreditCell
            let data = movie
            cell.configureCell(data)
            return cell
            
        case .overview:
            let cell = tableView.dequeueReusableCell(withIdentifier: OverviewCreditCell.identifier, for: indexPath) as! OverviewCreditCell
            let data = movie?.overview
            cell.configureCell(data)
            return cell
            
        case .cast:
            let cell = tableView.dequeueReusableCell(withIdentifier: CastAndCrewCreditCell.identifier, for: indexPath) as! CastAndCrewCreditCell
            let data = credit?.cast[indexPath.row]
            cell.configureCellWithCast(data)
            return cell
            
        case .crew:
            let cell = tableView.dequeueReusableCell(withIdentifier: CastAndCrewCreditCell.identifier, for: indexPath) as! CastAndCrewCreditCell
            let data = credit?.crew[indexPath.row]
            cell.configureCellWithCrew(data)
            return cell
        }
    }
}

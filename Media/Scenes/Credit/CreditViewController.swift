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

class CreditViewController: BaseViewController {
    
    let tableView = UITableView()
    
    var movie: Movie?       // 이전 화면에서 전달
    var credit: Credit?     // 네트워크로 받아오기
    var isDetail: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callRequest()
    }
    
    override func configureNavigationBar() {
        navigationItem.title = "출연/제작"
        let videoButton = UIBarButtonItem(image: UIImage(systemName: "video"), style: .plain, target: self, action: #selector(videoButtonTapped))
        navigationItem.rightBarButtonItem = videoButton
    }
    
    @objc func videoButtonTapped() {
        let vc = VideoViewController()
        vc.movie = movie
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func addSubviews() {
        view.addSubview(tableView)
    }
    
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MainCreditCell.self, forCellReuseIdentifier: MainCreditCell.identifier)
        tableView.register(OverviewCreditCell.self, forCellReuseIdentifier: OverviewCreditCell.identifier)
        tableView.register(CastAndCrewCreditCell.self, forCellReuseIdentifier: CastAndCrewCreditCell.identifier)
    }
    
    func callRequest() {
        guard let movie else { return }
        NetworkManager.shared.request(api: .credit(id: movie.id), model: Credit.self) { data, error in
            if let error = error {
                print("Credit ERROR")
                self.presentErrorAlert(title: "에러", message: error)
            } else if let data = data {
                print("Credit SUCCESS")
                self.credit = data
                self.tableView.reloadData()
            }
        }
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
        switch Sections.allCases[indexPath.section] {
        case .overview:
            return UITableView.automaticDimension
        case .main, .crew, .cast:
            return Sections.allCases[indexPath.section].rowHeight
        }
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
            cell.delegate = self
            cell.selectionStyle = .none
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

extension CreditViewController: OverviewCellDelegate {
    func seeMoreButtonTapped() {
        tableView.reloadData()
    }
}

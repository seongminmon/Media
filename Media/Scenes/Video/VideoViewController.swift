//
//  VideoViewController.swift
//  Media
//
//  Created by 김성민 on 7/1/24.
//

import UIKit
import SnapKit

class VideoViewController: BaseViewController {

    var tableView = UITableView()
    
    var movie: Movie?
    var videoList: [Video] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callRequest()
    }
    
    override func configureNavigationBar() {
        navigationItem.title = "비디오"
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
        tableView.rowHeight = 44
        tableView.register(VideoTableViewCell.self, forCellReuseIdentifier: VideoTableViewCell.identifier)
    }
    
    func callRequest() {
        guard let movie = movie else { return }
        NetworkManager.shared.request(api: .video(id: movie.id), model: VideoResponse.self) { data, error in
            if let error = error {
                print("Video ERROR")
                self.presentErrorAlert(title: "에러", message: error)
            } else if let data = data {
                print("Video SUCCESS")
                self.videoList = data.results
                self.tableView.reloadData()
            }
        }
    }
}

extension VideoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: VideoTableViewCell.identifier, for: indexPath) as? VideoTableViewCell else { return UITableViewCell() }
        let data = videoList[indexPath.row].name
        cell.configureCell(data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = VideoWebViewController()
        vc.video = videoList[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

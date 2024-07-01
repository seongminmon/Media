//
//  NasaViewController.swift
//  Media
//
//  Created by 김성민 on 7/1/24.
//

import UIKit
import SnapKit

private enum Nasa: String, CaseIterable {
    
    static let baseURL = "https://apod.nasa.gov/apod/image/"
    
    case one = "2308/sombrero_spitzer_3000.jpg"
    case two = "2212/NGC1365-CDK24-CDK17.jpg"
    case three = "2307/M64Hubble.jpg"
    case four = "2306/BeyondEarth_Unknown_3000.jpg"
    case five = "2307/NGC6559_Block_1311.jpg"
    case six = "2304/OlympusMons_MarsExpress_6000.jpg"
    case seven = "2305/pia23122c-16.jpg"
    case eight = "2308/SunMonster_Wenz_960.jpg"
    case nine = "2307/AldrinVisor_Apollo11_4096.jpg"
     
    static var photo: URL {
        return URL(string: Nasa.baseURL + Nasa.allCases.randomElement()!.rawValue)!
    }
}

final class NasaViewController: BaseViewController {
    
    let nasaImageView = UIImageView()
    let progressLabel = UILabel()
    let requestButton = UIButton()
    
    var session: URLSession!
    
    var total: Double = 0
    var buffer: Data? {
        didSet {
            let result = String(format: "%.2f", Double(buffer?.count ?? 0) / total * 100)
            progressLabel.text = "\(result) %"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureNavigationBar() {
        navigationItem.title = "Nasa 이미지 가져오기"
    }
    
    override func addSubviews() {
        view.addSubview(nasaImageView)
        view.addSubview(progressLabel)
        view.addSubview(requestButton)
    }
    
    override func configureLayout() {
        nasaImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(nasaImageView.snp.width)
        }
        
        progressLabel.snp.makeConstraints { make in
            make.top.equalTo(nasaImageView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        
        requestButton.snp.makeConstraints { make in
            make.top.equalTo(progressLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
    }
    
    override func configureView() {
        nasaImageView.image = UIImage(systemName: "star")
        nasaImageView.tintColor = .black
        
        progressLabel.text = "진행 상황이 표시됩니다."
        progressLabel.font = .boldSystemFont(ofSize: 20)
        progressLabel.textAlignment = .center
        
        requestButton.setTitle("랜덤 이미지 불러오기", for: .normal)
        requestButton.setTitleColor(.white, for: .normal)
        requestButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        requestButton.backgroundColor = .systemPink
        requestButton.layer.cornerRadius = 25
        requestButton.addTarget(self, action: #selector(requestButtonClicked), for: .touchUpInside)
    }
    
    @objc func requestButtonClicked() {
        print(#function)
        requestButton.isEnabled = false
        nasaImageView.image = UIImage(systemName: "star")
        buffer = Data()
        callRequest()
    }
    
    func callRequest() {
        let request = URLRequest(url: Nasa.photo)
        session = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
        session.dataTask(with: request).resume()
    }
}

extension NasaViewController: URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse) async -> URLSession.ResponseDisposition {
//        print(#function)
        
        guard let response = response as? HTTPURLResponse,
              (200..<300).contains(response.statusCode) else {
            print("응답이 잘못되었습니다.")
            return .cancel
        }
        
        guard let value = response.value(forHTTPHeaderField: "Content-Length"),
              let contentLength = Double(value) else {
            print("Content-Length 키 값이 올바르지 않습니다.")
            return .cancel
        }
        
        print("성공")
        total = contentLength
        return .allow
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
//        print(#function)
        buffer?.append(data)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: (any Error)?) {
//        print(#function)
        if error == nil {
            progressLabel.text = "다운로드가 완료되었습니다."
            nasaImageView.image = UIImage(data: buffer!)
        } else {
            progressLabel.text = "문제가 발생했습니다."
        }
        requestButton.isEnabled = true
    }
}

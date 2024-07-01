//
//  VideoWebViewController.swift
//  Media
//
//  Created by 김성민 on 7/1/24.
//

import UIKit
import WebKit
import SnapKit

final class VideoWebViewController: BaseViewController {
    
    let webView = WKWebView()
    let indicator = UIActivityIndicatorView()
    
    var video: Video?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureNavigationBar() {
        navigationItem.title = video?.name
    }
    
    override func addSubviews() {
        view.addSubview(webView)
        view.addSubview(indicator)
    }
    
    override func configureLayout() {
        webView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        indicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(40)
        }
    }
    
    override func configureView() {
        webView.navigationDelegate = self
        
        if let url = video?.videoURL {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}

extension VideoWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        indicator.isHidden = false
        indicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        indicator.stopAnimating()
        indicator.isHidden = true
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: any Error) {
        indicator.stopAnimating()
        indicator.isHidden = true
        self.presentErrorAlert(title: "에러", message: error.localizedDescription)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: any Error) {
        indicator.stopAnimating()
        indicator.isHidden = true
        self.presentErrorAlert(title: "에러", message: error.localizedDescription)
    }
}

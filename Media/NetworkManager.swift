//
//  NetworkManager.swift
//  Media
//
//  Created by 김성민 on 6/24/24.
//

import Foundation
import Alamofire

class NetworkManager {
    
    // 싱글톤
    static let shared = NetworkManager()
    private init() {}
    
    func trendingRequest(timeWindow: String, completionHandler: @escaping (Result<MovieResponse, AFError>) -> Void) {
        let url = APIURL.trendingURL + timeWindow
        let parameters: Parameters = [
            "language" : "en-US"
        ]
        let headers: HTTPHeaders = [
            "accept": "application/json",
            "Authorization": APIKey.accessTokenAuth
        ]
        
        AF.request(url, method: .get, parameters: parameters, headers: headers)
            .responseDecodable(of: MovieResponse.self) { response in
            completionHandler(response.result)
        }
    }
    
    func creditRequest(movieId: Int, completionHandler: @escaping (Result<Credit, AFError>) -> Void) {
        let url = APIURL.movieURL + "\(movieId)" + "/credits"
        let headers: HTTPHeaders = [
            "accept": "application/json",
            "Authorization": APIKey.accessTokenAuth
        ]
        
        AF.request(url, method: .get, headers: headers)
            .responseDecodable(of: Credit.self) { response in
            completionHandler(response.result)
        }
    }
    
    func searchRequest(query: String, page: Int, completionHandler: @escaping (Result<MovieResponse, AFError>) -> Void) {
        let url = APIURL.searchURL
        let parameters: Parameters = [
            "query" : query,
            "page" : page
        ]
        let headers: HTTPHeaders = [
            "accept": "application/json",
            "Authorization": APIKey.accessTokenAuth
        ]
        
        AF.request(url, method: .get, parameters: parameters, headers: headers)
            .responseDecodable(of: MovieResponse.self) { response in
            completionHandler(response.result)
        }
    }
    
    func similarRequest(movieId: Int, page: Int, completionHandler: @escaping (Result<MovieResponse, AFError>) -> Void) {
        let url = APIURL.movieURL + "\(movieId)" + "/similar"
        let parameters: Parameters = [
            "language" : "en-US",
            "page" : page
        ]
        let headers: HTTPHeaders = [
            "accept": "application/json",
            "Authorization": APIKey.accessTokenAuth
        ]
        
        AF.request(url, method: .get, parameters: parameters, headers: headers)
            .responseDecodable(of: MovieResponse.self) { response in
            completionHandler(response.result)
        }
    }
    
    func recommendRequest(movieId: Int, page: Int, completionHandler: @escaping (Result<MovieResponse, AFError>) -> Void) {
        let url = APIURL.movieURL + "\(movieId)" + "/recommendations"
        let parameters: Parameters = [
            "language" : "en-US",
            "page" : page
        ]
        let headers: HTTPHeaders = [
            "accept": "application/json",
            "Authorization": APIKey.accessTokenAuth
        ]
        
        AF.request(url, method: .get, parameters: parameters, headers: headers)
            .responseDecodable(of: MovieResponse.self) { response in
            completionHandler(response.result)
        }
    }
    
    func posterRequest(movieId: Int, page: Int, completionHandler: @escaping (Result<ImageResponse, AFError>) -> Void) {
        let url = APIURL.movieURL + "\(movieId)" + "/images"
        let headers: HTTPHeaders = [
            "accept": "application/json",
            "Authorization": APIKey.accessTokenAuth
        ]
        
        AF.request(url, method: .get, headers: headers)
            .responseDecodable(of: ImageResponse.self) { response in
            completionHandler(response.result)
        }
    }
    
}

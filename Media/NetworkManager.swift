//
//  NetworkManager.swift
//  Media
//
//  Created by 김성민 on 6/24/24.
//

import Foundation
import Alamofire

// MARK: - Enum으로 네트워크 구조 추상화
enum NetworkRequest {
    case trending(timeWindow: TimeWindow)
    case credit(id: Int)
    case search(query: String, page: Int)
    case similar(id: Int, page: Int)
    case recommend(id: Int, page: Int)
    case poster(id: Int)
    
    static let imageURL = "https://image.tmdb.org/t/p/w500/"
    
    var baseURL: String {
        return "https://api.themoviedb.org/3/"
    }
    
    var endpoint: URL {
        switch self {
        case .trending(let timeWindow):
            return URL(string: baseURL + "trending/movie/" + timeWindow.rawValue)!
        case .credit(let id):
            return URL(string: baseURL + "movie/" + "\(id)" + "/credits")!
        case .search:
            return URL(string: baseURL + "search/movie")!
        case .similar(let id, _):
            return URL(string: baseURL + "movie/" + "\(id)" + "/similar")!
        case .recommend(let id, _):
            return URL(string: baseURL + "movie/" + "\(id)" + "/recommendations")!
        case .poster(let id):
            return URL(string: baseURL + "movie/" + "\(id)" + "/images")!
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var parameters: Parameters {
        switch self {
        case .trending(let timeWindow):
            return ["language": "ko-KR"]
        case .credit, .poster:
            return ["": ""]
        case .search(let query, let page):
            return ["query": query,
                    "page": page]
        case .similar(_, let page), .recommend(_, let page):
            return ["language": "ko-KR",
                    "page": page]
        }
    }
    
    var encoding: URLEncoding {
        return URLEncoding(destination: .queryString)
    }
    
    var header: HTTPHeaders {
        return ["accept": "application/json",
                "Authorization": APIKey.accessToken]
    }
    
}

class NetworkManager {
    
    // 싱글톤
    static let shared = NetworkManager()
    private init() {}
    
    func trending(api: NetworkRequest, completionHandler: @escaping ([Movie]?, String?) -> Void) {
        AF.request(api.endpoint, method: api.method, parameters: api.parameters, encoding: api.encoding, headers: api.header)
            .validate(statusCode: 200..<500)
            .responseDecodable(of: MovieResponse.self) { response in
                switch response.result {
                case .success(let value):
                    print("trending SUCCESS")
                    completionHandler(value.movieList, nil)
                    
                case .failure(let error):
                    print("trending ERROR")
                    completionHandler(nil, "잠시 후 다시 시도해주세요.")
                }
            }
    }
    
//    func trendingRequest(timeWindow: String, completionHandler: @escaping (Result<MovieResponse, AFError>) -> Void) {
//        let url = APIURL.trendingURL + timeWindow
//        let parameters: Parameters = [
//            "language" : "en-US"
//        ]
//        let headers: HTTPHeaders = [
//            "accept": "application/json",
//            "Authorization": APIKey.accessToken
//        ]
//        
//        AF.request(url, method: .get, parameters: parameters, headers: headers)
//            .responseDecodable(of: MovieResponse.self) { response in
//            completionHandler(response.result)
//        }
//    }
//    
//    func creditRequest(movieId: Int, completionHandler: @escaping (Result<Credit, AFError>) -> Void) {
//        let url = APIURL.movieURL + "\(movieId)" + "/credits"
//        let headers: HTTPHeaders = [
//            "accept": "application/json",
//            "Authorization": APIKey.accessToken
//        ]
//        
//        AF.request(url, method: .get, headers: headers)
//            .responseDecodable(of: Credit.self) { response in
//            completionHandler(response.result)
//        }
//    }
//    
//    func searchRequest(query: String, page: Int, completionHandler: @escaping (Result<MovieResponse, AFError>) -> Void) {
//        let url = APIURL.searchURL
//        let parameters: Parameters = [
//            "query" : query,
//            "page" : page
//        ]
//        let headers: HTTPHeaders = [
//            "accept": "application/json",
//            "Authorization": APIKey.accessToken
//        ]
//        
//        AF.request(url, method: .get, parameters: parameters, headers: headers)
//            .responseDecodable(of: MovieResponse.self) { response in
//            completionHandler(response.result)
//        }
//    }
//    
//    func similarRequest(movieId: Int, page: Int, completionHandler: @escaping (Result<MovieResponse, AFError>) -> Void) {
//        let url = APIURL.movieURL + "\(movieId)" + "/similar"
//        let parameters: Parameters = [
//            "language" : "en-US",
//            "page" : page
//        ]
//        let headers: HTTPHeaders = [
//            "accept": "application/json",
//            "Authorization": APIKey.accessToken
//        ]
//        
//        AF.request(url, method: .get, parameters: parameters, headers: headers)
//            .responseDecodable(of: MovieResponse.self) { response in
//            completionHandler(response.result)
//        }
//    }
//    
//    func recommendRequest(movieId: Int, page: Int, completionHandler: @escaping (Result<MovieResponse, AFError>) -> Void) {
//        let url = APIURL.movieURL + "\(movieId)" + "/recommendations"
//        let parameters: Parameters = [
//            "language" : "en-US",
//            "page" : page
//        ]
//        let headers: HTTPHeaders = [
//            "accept": "application/json",
//            "Authorization": APIKey.accessToken
//        ]
//        
//        AF.request(url, method: .get, parameters: parameters, headers: headers)
//            .responseDecodable(of: MovieResponse.self) { response in
//            completionHandler(response.result)
//        }
//    }
//    
//    func posterRequest(movieId: Int, completionHandler: @escaping (Result<ImageResponse, AFError>) -> Void) {
//        let url = APIURL.movieURL + "\(movieId)" + "/images"
//        let headers: HTTPHeaders = [
//            "accept": "application/json",
//            "Authorization": APIKey.accessToken
//        ]
//        
//        AF.request(url, method: .get, headers: headers)
//            .responseDecodable(of: ImageResponse.self) { response in
//            completionHandler(response.result)
//        }
//    }
    
}

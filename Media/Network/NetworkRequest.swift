//
//  NetworkRequest.swift
//  Media
//
//  Created by 김성민 on 6/26/24.
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
        case .trending, .credit:
            return ["language": "ko-KR"]
        case .poster:
            return ["": ""]
        case .search(let query, let page):
            return ["language": "ko-KR",
                    "query": query,
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

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
    
    func trending(api: NetworkRequest, completionHandler: @escaping ([Movie]?, String?) -> Void) {
        AF.request(api.endpoint,
                   method: api.method,
                   parameters: api.parameters,
                   encoding: api.encoding,
                   headers: api.header)
        .validate(statusCode: 200..<500)
        .responseDecodable(of: MovieResponse.self) { response in
            switch response.result {
            case .success(let value):
                print("trending SUCCESS")
                completionHandler(value.movieList, nil)
                
            case .failure(let error):
                print("trending ERROR")
                print(error)
                completionHandler(nil, "잠시 후 다시 시도해주세요.")
            }
        }
    }
    
    func credit(api: NetworkRequest, completionHandler: @escaping (Credit?, String?) -> Void) {
        AF.request(api.endpoint,
                   method: api.method,
                   parameters: api.parameters,
                   encoding: api.encoding,
                   headers: api.header)
        .validate(statusCode: 200..<500)
        .responseDecodable(of: Credit.self) { response in
            switch response.result {
            case .success(let value):
                print("credit SUCCESS")
                completionHandler(value, nil)
                
            case .failure(let error):
                print("credit ERROR")
                print(error)
                completionHandler(nil, "잠시 후 다시 시도해주세요.")
            }
        }
    }
    
    func search(api: NetworkRequest, completionHandler: @escaping (MovieResponse?, String?) -> Void) {
        AF.request(api.endpoint,
                   method: api.method,
                   parameters: api.parameters,
                   encoding: api.encoding,
                   headers: api.header)
        .validate(statusCode: 200..<500)
        .responseDecodable(of: MovieResponse.self) { response in
            switch response.result {
            case .success(let value):
                print("search SUCCESS")
                completionHandler(value, nil)
                
            case .failure(let error):
                print("search ERROR")
                print(error)
                completionHandler(nil, "잠시 후 다시 시도해주세요.")
            }
        }
    }
    
    func similar(api: NetworkRequest, completionHandler: @escaping (MovieResponse?, String?) -> Void) {
        AF.request(api.endpoint,
                   method: api.method,
                   parameters: api.parameters,
                   encoding: api.encoding,
                   headers: api.header)
        .validate(statusCode: 200..<500)
        .responseDecodable(of: MovieResponse.self) { response in
            switch response.result {
            case .success(let value):
                print("similar SUCCESS")
                completionHandler(value, nil)
                
            case .failure(let error):
                print("similar ERROR")
                print(error)
                completionHandler(nil, "잠시 후 다시 시도해주세요.")
            }
        }
    }
    
    func recommend(api: NetworkRequest, completionHandler: @escaping (MovieResponse?, String?) -> Void) {
        AF.request(api.endpoint,
                   method: api.method,
                   parameters: api.parameters,
                   encoding: api.encoding,
                   headers: api.header)
        .validate(statusCode: 200..<500)
        .responseDecodable(of: MovieResponse.self) { response in
            switch response.result {
            case .success(let value):
                print("recommend SUCCESS")
                completionHandler(value, nil)
                
            case .failure(let error):
                print("recommend ERROR")
                print(error)
                completionHandler(nil, "잠시 후 다시 시도해주세요.")
            }
        }
    }

//    func poster(api: NetworkRequest, completionHandler: @escaping (ImageResponse?, String?) -> Void) {
//        AF.request(api.endpoint,
//                   method: api.method,
//                   parameters: api.parameters,
//                   encoding: api.encoding,
//                   headers: api.header)
//        .validate(statusCode: 200..<500)
//        .responseDecodable(of: ImageResponse.self) { response in
//            switch response.result {
//            case .success(let value):
//                print("poster SUCCESS")
//                completionHandler(value, nil)
//                
//            case .failure(let error):
//                print("poster ERROR")
//                print(error)
//                completionHandler(nil, "잠시 후 다시 시도해주세요.")
//            }
//        }
//    }

    // MARK: - URLSession으로 변경해보기
    func poster(
        api: NetworkRequest,
        completionHandler: @escaping (ImageResponse?, String?) -> Void
    ) {
        let url = api.endpoint
        var request = URLRequest(url: url, timeoutInterval: 5)
        request.httpMethod = api.method.rawValue
        request.headers = api.header
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            // response
            if let error = error {
                print("poster ERROR")
                print(error)
                completionHandler(nil, "잠시 후 다시 시도해주세요.")
            } else if let data = data {
                let value = try? JSONDecoder().decode(ImageResponse.self, from: data)
                print("poster SUCCESS")
                completionHandler(value, nil)
            }
        }
        .resume()
    }
}

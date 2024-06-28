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
    
    func request<T: Decodable>(
        api: NetworkRequest,
        model: T.Type,
        completionHandler: @escaping (T?, String?) -> Void
    ) {
        AF.request(api.endpoint,
                   method: api.method,
                   parameters: api.parameters,
                   encoding: api.encoding,
                   headers: api.header)
        .validate(statusCode: 200..<500)
        .responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let value):
                completionHandler(value, nil)
                
            case .failure(let error):
                print(error)
                completionHandler(nil, "잠시 후 다시 시도해주세요.")
            }
        }
    }
    
    // URLSession
//    func poster(
//        api: NetworkRequest,
//        completionHandler: @escaping (ImageResponse?, String?) -> Void
//    ) {
//        let url = api.endpoint
//        var request = URLRequest(url: url, timeoutInterval: 5)
//        request.httpMethod = api.method.rawValue
//        request.headers = api.header
//        
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            // response
//            if let error = error {
//                print("poster ERROR")
//                print(error)
//                completionHandler(nil, "잠시 후 다시 시도해주세요.")
//            } else if let data = data {
//                let value = try? JSONDecoder().decode(ImageResponse.self, from: data)
//                print("poster SUCCESS")
//                completionHandler(value, nil)
//            }
//        }
//        .resume()
//    }
}

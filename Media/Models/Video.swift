//
//  Video.swift
//  Media
//
//  Created by 김성민 on 7/1/24.
//

import Foundation

struct VideoResponse: Decodable {
    let id: Int
    let results: [Video]
}

struct Video: Decodable {
    let name, key: String
    
    var videoURL: URL? {
        return URL(string: NetworkRequest.videoURL + key)
    }
}

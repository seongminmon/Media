//
//  ImageResponse.swift
//  Media
//
//  Created by 김성민 on 6/25/24.
//

import Foundation

struct ImageResponse: Decodable {
    let posters: [Backdrop]
}

struct Backdrop: Decodable {
    let filePath: String?

    enum CodingKeys: String, CodingKey {
        case filePath = "file_path"
    }
    
    var posterImageURL: URL? {
        return URL(string: NetworkRequest.imageURL + (filePath ?? ""))
    }
}

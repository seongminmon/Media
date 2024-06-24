//
//  Credit.swift
//  Media
//
//  Created by 김성민 on 6/24/24.
//

import Foundation

struct Credit: Decodable {
    let id: Int
    let cast, crew: [Cast]
}

struct Cast: Decodable {
    let profilePath: String?
    let name: String
    let character: String?
    let knownForDepartment: String
    
    enum CodingKeys: String, CodingKey {
        case profilePath = "profile_path"
        case name
        case character
        case knownForDepartment = "known_for_department"
    }
    
    var posterImageURL: URL? {
        return URL(string: "https://image.tmdb.org/t/p/w500/\(profilePath ?? "")")
    }
}

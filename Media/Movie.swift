//
//  Movie.swift
//  Media
//
//  Created by 김성민 on 6/24/24.
//

import Foundation

struct MovieResponse: Decodable {
    let page: Int
    let movieList: [Movie]
    let totalPages: Int
    let totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page
        case movieList = "results"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct Movie: Decodable {
    let backdropPath: String?
    let id: Int
    let originalTitle, overview, posterPath: String
    let mediaType: String
    let adult: Bool
    let title: String
    let originalLanguage: String
    let genreIdList: [Int]
    let popularity: Double
    let releaseDate: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case id
        case originalTitle = "original_title"
        case overview
        case posterPath = "poster_path"
        case mediaType = "media_type"
        case adult, title
        case originalLanguage = "original_language"
        case genreIdList = "genre_ids"
        case popularity
        case releaseDate = "release_date"
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

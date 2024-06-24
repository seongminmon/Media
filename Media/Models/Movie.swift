//
//  Movie.swift
//  Media
//
//  Created by 김성민 on 6/24/24.
//

import UIKit

struct MovieResponse: Decodable {
    let page: Int
    var movieList: [Movie]
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
    let id: Int
    let posterPath: String?
    let releaseDate: String
    let genreIdList: [Int]
    let title: String
    let overview: String
    let voteAverage: Double
    
    //
    let originalLanguage: String
    let originalTitle: String
    let mediaType: String?
    let adult: Bool
    let backdropPath: String?
    let popularity: Double
    let video: Bool
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
    
    static let genreDict: [Int: String] = [
        28: "Action",
        12: "Adventure",
        16: "Animation",
        35: "Comedy",
        80: "Crime",
        99: "Documentary",
        18: "Drama",
        10751: "Family",
        14: "Fantasy",
        36: "History",
        27: "Horror",
        10402: "Music",
        9648: "Mystery",
        10749: "Romance",
        878: "Science Fiction",
        10770: "TV Movie",
        53: "Thriller",
        10752: "War",
        37: "Western",
    ]
    
    var genreText: String {
        var ret = ""
        genreIdList.forEach { genreId in
            if let genre = Movie.genreDict[genreId] {
                ret += "#\(genre) "
            }
        }
        return ret
    }
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let date = formatter.date(from: releaseDate)!
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter.string(from: date)
    }
    
    var posterImageURL: URL? {
        return URL(string: APIURL.imageURL + (posterPath ?? ""))
    }
    
    var backdropImageURL: URL? {
        return URL(string: APIURL.imageURL + (backdropPath ?? ""))
    }
    
    var grade: String {
        return String(format: "%.1f", voteAverage)
    }
}

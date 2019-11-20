//
//  Movies.swift
//  MoviesList
//
//  Created by Zhassulan Aimukhambetov on 11/14/19.
//  Copyright © 2019 Zhassulan Aimukhambetov. All rights reserved.
//

import Foundation

struct Movie: Decodable {
    let id: Int
    let title: String
    let posterPath: String?
    let adult: Bool
    let overview: String
    let releaseDate: String?
    let originalTitle: String
    let originalLanguage: String
    let backdropPath: String?
    let popularity: Double
    let voteCount: Int
    let video: Bool
    let voteAverage: Double
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case posterPath = "poster_path"
        case adult
        case overview
        case releaseDate = "release_date"
        case originalTitle = "original_title"
        case originalLanguage = "original_language"
        case backdropPath = "backdrop_path"
        case popularity
        case voteCount = "vote_count"
        case video
        case voteAverage = "vote_average"
    }
}

struct Result: Decodable {
    let results: [Movie]
    let page: Int
    let total_pages: Int
    let total_results: Int
}

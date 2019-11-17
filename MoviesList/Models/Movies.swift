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
    let poster_path: String?
    let adult: Bool
    let overview: String
    let release_date: String?
    let original_title: String
    let original_language: String
    let backdrop_path: String?
    let popularity: Double
    let vote_count: Int
    let video: Bool
    let vote_average: Double
}

struct MovieJSON: Decodable {
    let results: [Movie]
    let page: Int
    let total_pages: Int
    let total_results: Int
}

//
//  MoviesViewModel.swift
//  MoviesList
//
//  Created by Zhassulan Aimukhambetov on 11/14/19.
//  Copyright © 2019 Zhassulan Aimukhambetov. All rights reserved.
//

import Foundation
import UIKit

class MovieViewModel {
    let id: Int
    let title: String
    let overview: String
    let poster_path: String?
    let release_date: String?
    let voteAverage: Double
    let original_title: String
    let original_language: String
    let backdrop_path: String?
    let popularity: String
    var rating: String {
        let star = "⋆"
        if voteAverage > 1 {
            let rate = Int(voteAverage/2)
            var stars = ""
            for _ in 1...rate {
                stars += star
            }
            return stars
        }
        return star
    }
    
    init(movie: Movie) {
        self.id = movie.id
        self.title = movie.title
        self.overview = movie.overview
        self.poster_path = movie.poster_path
        self.release_date = movie.release_date
        self.voteAverage = movie.vote_average
        self.backdrop_path = movie.backdrop_path
        self.original_language = movie.original_language
        self.original_title = movie.original_title
        self.popularity = String(movie.popularity)
    }
    
}



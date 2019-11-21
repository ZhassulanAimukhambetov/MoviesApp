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
    let posterPath: String?
    let releaseDate: String?
    let voteAverage: Double
    let originalTitle: String
    let originalLanguage: String
    let backdropPath: String?
    let popularity: String
    var isFavorite: Bool {
        get {
            return UserDefaults.standard.bool(forKey: String(self.id))
        }
        set {
            UserDefaults.standard.set(newValue, forKey: String(self.id))
        }
    }
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
        self.posterPath = movie.posterPath
        self.releaseDate = movie.releaseDate
        self.voteAverage = movie.voteAverage
        self.backdropPath = movie.backdropPath
        self.originalLanguage = movie.originalLanguage
        self.originalTitle = movie.originalTitle
        self.popularity = String(movie.popularity)
    }
}



//
//  Cell.swift
//  MoviesList
//
//  Created by Zhassulan Aimukhambetov on 11/14/19.
//  Copyright © 2019 Zhassulan Aimukhambetov. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {
    
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var posterImage1: UIImageView!
    @IBOutlet weak var titleLabel1: UILabel!
    @IBOutlet weak var dateLabel1: UILabel!
    @IBOutlet weak var ratingLabel1: UILabel!
    
    @IBOutlet weak var posterImage2: UIImageView!
    @IBOutlet weak var titleLabel2: UILabel!
    @IBOutlet weak var dateLabel2: UILabel!
    @IBOutlet weak var ratingLabel2: UILabel!
    
    func configureMoviePortraitCell(movieViewModel: MovieViewModel) {
        self.titleLabel.text = movieViewModel.title
        self.dateLabel.text = movieViewModel.release_date
        self.ratingLabel.text = movieViewModel.rating
        self.posterImage.image = nil
        NetworkService.shared.getImage(urlPath: movieViewModel.poster_path) { (image) in
            self.posterImage.image = image
        }
    }
    
    func configureMovieLandscapeCell(movieViewModelFirst: MovieViewModel, movieViewModelSecond: MovieViewModel) {
        self.titleLabel1.text = movieViewModelFirst.title
        self.dateLabel1.text = movieViewModelFirst.release_date
        self.ratingLabel1.text = movieViewModelFirst.rating
        self.posterImage1.image = nil
        NetworkService.shared.getImage(urlPath: movieViewModelFirst.poster_path) { (image) in
            self.posterImage1.image = image
        }
        
        self.titleLabel2.text = movieViewModelSecond.title
        self.dateLabel2.text = movieViewModelSecond.release_date
        self.ratingLabel2.text = movieViewModelSecond.rating
        self.posterImage2.image = nil
        NetworkService.shared.getImage(urlPath: movieViewModelSecond.poster_path) { (image) in
            self.posterImage2.image = image
        }
    }
}

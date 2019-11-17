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
    
    
    func configureMovieCell(movieViewModel: MovieViewModel) {
        self.titleLabel.text = movieViewModel.title
        self.dateLabel.text = movieViewModel.release_date
        self.ratingLabel.text = movieViewModel.rating
        self.posterImage.image = nil
        NetworkService.shared.getImage(urlPath: movieViewModel.poster_path) { (image) in
            self.posterImage.image = image
        }
        
    }
}

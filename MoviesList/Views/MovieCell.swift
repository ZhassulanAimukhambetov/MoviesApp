//
//  MovieCVCell.swift
//  MoviesList
//
//  Created by Zhassulan Aimukhambetov on 11/18/19.
//  Copyright © 2019 Zhassulan Aimukhambetov. All rights reserved.
//

import UIKit

class MovieCell: UICollectionViewCell {
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    weak var viewController: RootViewController?
    
    func configureMovieCVCell(movieViewModel: MovieViewModel) {
        self.titleLabel.text = movieViewModel.title
        self.dateLabel.text = movieViewModel.releaseDate
        self.ratingLabel.text = movieViewModel.rating
        self.posterImage.image = nil
        NetworkService.shared.getImage(urlPath: movieViewModel.posterPath) { (image) in
            self.posterImage.image = image
        }
        self.favoriteButton.setTitleColor(movieViewModel.isFavorite ? .orange: .gray, for: .normal)
    }

    @IBAction func buttonTouchDown(_ sender: Any) {
        viewController?.makeFavorite(cell: self)
    }
}

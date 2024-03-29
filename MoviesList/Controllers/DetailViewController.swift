//
//  DetailViewController.swift
//  MoviesList
//
//  Created by Zhassulan Aimukhambetov on 11/16/19.
//  Copyright © 2019 Zhassulan Aimukhambetov. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var popularityLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    
    var movieVM: MovieViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = movieVM?.title
        NetworkService.shared.getImage(urlPath: movieVM?.backdropPath) { (image) in
            self.posterImage.image = image
        }
        languageLabel.text = movieVM?.originalLanguage
        overviewLabel.text = movieVM?.overview
        titleLabel.text = movieVM?.originalTitle
        popularityLabel.text = movieVM?.popularity
    }
}

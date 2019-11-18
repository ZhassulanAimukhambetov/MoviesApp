//
//  ViewController.swift
//  MoviesList
//
//  Created by Zhassulan Aimukhambetov on 11/19/19.
//  Copyright © 2019 Zhassulan Aimukhambetov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var movieViewModels = [MovieViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchBar()
        NetworkService.shared.getMovies { (moviesJSON) in
            moviesJSON.results.forEach{self.movieViewModels.append(MovieViewModel(movie: $0))}
            self.collectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MovieCell
        cell.configureMovieCVCell(movieViewModel: movieViewModels[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension ViewController: UICollectionViewDelegate {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            if let cell = sender as? MovieCell {
                if let indexPath = collectionView.indexPath(for: cell){
                    let movieVM = movieViewModels[indexPath.row]
                    let detailVC = segue.destination as? DetailViewController
                    detailVC?.movieVM = movieVM
                }
            }
        }
        searchBar.endEditing(true)
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let searchText = searchBar.text ?? ""
        let lastItem = movieViewModels.count/2 - 1
        let page = movieViewModels.count/20 + 1
        if indexPath.row == lastItem {
            if searchText == "" {
                NetworkService.shared.getMovies(page: page) { (moviesJSON) in
                    moviesJSON.results.forEach{self.movieViewModels.append(MovieViewModel(movie: $0))}
                    self.collectionView.reloadData()
                }
            } else {
                NetworkService.shared.searchMovies(page: page, query: searchText) { (moviesJSON) in
                    if page < moviesJSON.total_pages{
                        moviesJSON.results.forEach{self.movieViewModels.append(MovieViewModel(movie: $0))}
                        self.collectionView.reloadData()
                    }
                }
            }
        }
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
}

// MARK: - Configure cell in orientation
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var yourWidth = collectionView.bounds.width
        if UIDevice.current.orientation.isLandscape {
            yourWidth = collectionView.bounds.width/2-2
        }
        let yourHeight = CGFloat(integerLiteral: 125)
        return CGSize(width: yourWidth, height: yourHeight)
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.reloadData()
    }
}

// MARK: - UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            NetworkService.shared.searchMovies(query: searchText) { (moviesJSON) in
                self.movieViewModels.removeAll()
                moviesJSON.results.forEach{self.movieViewModels.append(MovieViewModel(movie: $0))}
                self.collectionView.reloadData()
                self.noResultOfsearch()
            }
        } else {
            searchBar.endEditing(true)
            NetworkService.shared.getMovies { (moviesJSON) in
                self.movieViewModels.removeAll()
                moviesJSON.results.forEach{self.movieViewModels.append(MovieViewModel(movie: $0))}
                self.collectionView.reloadData()
                self.noResultOfsearch()
            }
        }
    }
    func configureSearchBar() {
        for view in searchBar.subviews {
            for subview in view.subviews {
                if subview .isKind(of: UITextField.self) {
                    let textField: UITextField = subview as! UITextField
                    textField.backgroundColor = UIColor(displayP3Red: 20/255, green: 20/255, blue: 20/255, alpha: 1)
                }
            }
        }
    }
    func noResultOfsearch() {
        if movieViewModels.count == 0 {
            collectionView.isHidden = true
        } else {
            collectionView.isHidden = false
        }
    }
}



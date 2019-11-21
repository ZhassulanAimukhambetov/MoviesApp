//
//  ViewController.swift
//  MoviesList
//
//  Created by Zhassulan Aimukhambetov on 11/19/19.
//  Copyright © 2019 Zhassulan Aimukhambetov. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var notifLabel: UILabel!
    
    var movieViewModels = [MovieViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        getMovies()
    }
}

// MARK: - UICollectionViewDataSource
extension RootViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MovieCell
        cell.configureMovieCVCell(movieViewModel: movieViewModels[indexPath.row]) {
            collectionView.performBatchUpdates({
                collectionView.reloadItems(at: [indexPath])
            })
        }
        cell.viewController = self
        return cell
    }
    
}

// MARK: - UICollectionViewDelegate
extension RootViewController: UICollectionViewDelegate {
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
    
    // Pagination
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let searchText = searchBar.text ?? ""
        let lastItem = movieViewModels.count - 1
        let page = movieViewModels.count/20 + 1
        if indexPath.row == lastItem {
            if searchText == "" {
                getMovies(page: page)
            } else {
                searchMovies(page: page, searchText: searchText)
            }
        }
    }
}

// MARK: - UISearchBarDelegate
extension RootViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            movieViewModels.removeAll()
            searchMovies(searchText: searchText)
        } else {
            movieViewModels.removeAll()
            searchBar.endEditing(true)
            getMovies()
        }
    }
}

// MARK: - Configure
extension RootViewController: UICollectionViewDelegateFlowLayout {
    
    //Configure cell in orientation
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
    
    //Configure RootViewController
    func configureVC() {
        collectionView.isHidden = true
        notifLabel.textColor = .gray
        notifLabel.text = "Загрузка..."
        configureSearchBar()
    }
    
    //Configure SearchBar
    func configureSearchBar() {
        searchBar.searchTextField.backgroundColor = UIColor(displayP3Red: 20/255, green: 20/255, blue: 20/255, alpha: 1)
    }
    //Get and search movies
    func getMovies(page: Int = 1) {
        NetworkService.shared.getMovies (page: page) { (moviesJSON) in
            guard let moviesJSON = moviesJSON else {
                self.collectionView.isHidden = true
                self.notifLabel.text = "Что-то пошло не так..."
                return
            }
            self.collectionView.isHidden = false
            moviesJSON.results.forEach{self.movieViewModels.append(MovieViewModel(movie: $0))}
            self.collectionView.reloadData()
            self.noResultOfsearch()
        }
    }
    
    func searchMovies(page: Int = 1, searchText: String) {
        NetworkService.shared.searchMovies(page: page, query: searchText) { (moviesJSON) in
            guard let moviesJSON = moviesJSON else {
                self.collectionView.isHidden = true
                self.notifLabel.text = "Что-то пошло не так..."
                return
            }
            self.collectionView.isHidden = false
            moviesJSON.results.forEach{self.movieViewModels.append(MovieViewModel(movie: $0))}
            self.collectionView.reloadData()
            self.noResultOfsearch()
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
    
    func noResultOfsearch() {
        if movieViewModels.count == 0 {
            collectionView.isHidden = true
        } else {
            collectionView.isHidden = false
            notifLabel.text = "Ничего не найдено"
        }
    }
    
    func makeFavorite(cell: UICollectionViewCell) {
        if let indexPath = collectionView.indexPath(for: cell) {
            movieViewModels[indexPath.row].isFavorite = movieViewModels[indexPath.row].isFavorite ? false : true
            collectionView.reloadItems(at: [indexPath])
        }
    }
}

//
//  ViewController.swift
//  MoviesList
//
//  Created by Zhassulan Aimukhambetov on 11/14/19.
//  Copyright © 2019 Zhassulan Aimukhambetov. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var movieViewModels = [MovieViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkService.shared.getMovies { (moviesJSON) in
            moviesJSON.results.forEach{self.movieViewModels.append(MovieViewModel(movie: $0))}
            self.tableView.reloadData()
        }
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        tableView.reloadData()
    }
}

//MARK: -  UITableViewDataSource
extension RootViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieViewModels.count/2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieCell
        if UIDevice.current.orientation.isLandscape {
            cell.configureMovieLandscapeCell(movieViewModelFirst: movieViewModels[indexPath.row * 2], movieViewModelSecond: movieViewModels[indexPath.row * 2 + 1])
        } else if UIDevice.current.orientation.isPortrait {
             cell.configureMoviePortraitCell(movieViewModel: movieViewModels[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let searchText = searchBar.text ?? ""
        let lastItem = movieViewModels.count/2 - 1
        let page = movieViewModels.count/20 + 1
        if indexPath.row == lastItem {
            if searchText == "" {
                NetworkService.shared.getMovies(page: page) { (moviesJSON) in
                    moviesJSON.results.forEach{self.movieViewModels.append(MovieViewModel(movie: $0))}
                    self.tableView.reloadData()
                }
            } else {
                NetworkService.shared.searchMovies(page: page, query: searchText) { (moviesJSON) in
                    if page < moviesJSON.total_pages{
                        moviesJSON.results.forEach{self.movieViewModels.append(MovieViewModel(movie: $0))}
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
}

//MARK: -  UITableViewDelegate
extension RootViewController: UITableViewDelegate {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        searchBar.endEditing(true)
        if segue.identifier == "toDetailVC" {
            if let cell = sender as? MovieCell {
                cell.setSelected(false, animated: true)
                if let indexPath = tableView.indexPath(for: cell){
                    let movieVM = movieViewModels[indexPath.row]
                    let detailVC = segue.destination as? DetailViewController
                    detailVC?.movieVM = movieVM
                }
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
}

//MARK: -  UISearchBarDelegate
extension RootViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            NetworkService.shared.searchMovies(query: searchText) { (moviesJSON) in
                self.movieViewModels.removeAll()
                moviesJSON.results.forEach{self.movieViewModels.append(MovieViewModel(movie: $0))}
                self.tableView.reloadData()
            }
        } else {
            searchBar.endEditing(true)
            NetworkService.shared.getMovies { (moviesJSON) in
                self.movieViewModels.removeAll()
                moviesJSON.results.forEach{self.movieViewModels.append(MovieViewModel(movie: $0))}
                self.tableView.reloadData()
            }
        }
    }
}

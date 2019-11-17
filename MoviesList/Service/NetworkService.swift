//
//  NetworkService.swift
//  MoviesList
//
//  Created by Zhassulan Aimukhambetov on 11/15/19.
//  Copyright © 2019 Zhassulan Aimukhambetov. All rights reserved.
//

import Foundation
import UIKit

class NetworkService {
    
    let urlAPI = "https://api.themoviedb.org/3"
    let urlNowPlaying = "/movie/now_playing"
    let urlSearch = "/search/movie"
    let apiKey = "a055f70548b7278f1f017fc33819dd5b"
    
    public static let shared = NetworkService()
    private init () {}
    
    func getMovies(page: Int = 1, complition: @escaping (_ movies: MovieJSON) -> ()) {
        let pageString = String(page)
        let url = URL(string: "\(urlAPI)\(urlNowPlaying)?api_key=\(apiKey)&language=ru&page=\(pageString)")
        let task = URLSession.shared.dataTask(with: url!) { (data, responce, error) in
            guard let data = data else { return }
            let moviesJSON = try! JSONDecoder().decode(MovieJSON.self, from: data)
            DispatchQueue.main.async {
                complition(moviesJSON)
            }
        }
        task.resume()
    }
    
    func getImage(urlPath: String?, complition: @escaping (UIImage?) -> ()) {
        if let urlPath = urlPath {
            let url = URL(string: "https://image.tmdb.org/t/p/w500" + urlPath)!
            let task = URLSession.shared.dataTask(with: url) { (data, responce, error) in
                guard let data = data else { return }
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        complition(image)
                    }
                }
            }
            task.resume()
        }
    }
    
    func searchMovies(page: Int = 1, query: String, complition: @escaping (_ movies: MovieJSON) -> ()) {
        let pageString = String(page)
        let queryUrl = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let url = URL(string: "\(urlAPI)\(urlSearch)?api_key=\(apiKey)&language=ru&page=\(pageString)&query=\(queryUrl!)")
        let task = URLSession.shared.dataTask(with: url!) { (data, responce, error) in
            guard let data = data else { return }
            let moviesJSON = try! JSONDecoder().decode(MovieJSON.self, from: data)
            DispatchQueue.main.async {
                complition(moviesJSON)
            }
        }
        task.resume()
    }
}

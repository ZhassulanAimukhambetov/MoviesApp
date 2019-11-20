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
    
    let urlAPI = "https://api.themoviedb.org/31"
    let apiKey = "a055f70548b7278f1f017fc33819dd5b"
    
    public static let shared = NetworkService()
    private init () {}
    
    func getMovies(page: Int = 1, completion: @escaping (_ data: Result?) -> ()) {
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a055f70548b7278f1f017fc33819dd5b&language=ru&page=\(page)")
        let request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10)
        let task1 = URLSession.shared.dataTask(with: request) { (data, responce, error) in
            DispatchQueue.main.async(execute: { () -> Void in
                if let httpResponse = responce as? HTTPURLResponse, httpResponse.statusCode < 299 {
                    guard let data = data else { return }
                    let moviesJSON = try! JSONDecoder().decode(Result.self, from: data)
                    completion(moviesJSON)
                    return
                } else {
                    completion(nil)
                }
                if error != nil {
                    print("Error -> \(String(describing: error))")
                    completion(nil)
                }
            })
        }
        task1.resume()
    }
    
    func searchMovies(page: Int = 1, query: String, completion: @escaping (_ movies: Result?) -> ()) {
        let pageString = String(page)
        let queryUrl = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let url = URL(string: "https://api.themoviedb.org/3/search/movie?language=ru&api_key=\(apiKey)&query=\(queryUrl)&page=\(pageString)")
        let task = URLSession.shared.dataTask(with: url!) { (data, responce, error) in
            DispatchQueue.main.async(execute: { () -> Void in
                if let httpResponse = responce as? HTTPURLResponse, httpResponse.statusCode < 299 {
                    guard let data = data else { return }
                    let moviesJSON = try! JSONDecoder().decode(Result.self, from: data)
                    completion(moviesJSON)
                    return
                } else {
                    completion(nil)
                }
            })
        }
        task.resume()
    }
    
    func getImage(urlPath: String?, completion: @escaping (UIImage?) -> ()) {
        if let urlPath = urlPath {
            let url = URL(string: "https://image.tmdb.org/t/p/w500" + urlPath)!
            let task = URLSession.shared.dataTask(with: url) { (data, responce, error) in
                guard let data = data else { return }
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        completion(image)
                    }
                }
            }
            task.resume()
        }
    }
}

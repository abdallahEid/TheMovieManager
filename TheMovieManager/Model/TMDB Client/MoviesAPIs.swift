//
//  MoviesAPIs.swift
//  TheMovieManager
//
//  Created by Abdallah Eid on 6/28/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation

class MoviesAPIs {
    class func getWatchlist(completion: @escaping ([Movie], Error?) -> Void) {
        TMDBClient.taskForGetRequest(url: TMDBClient.Endpoints.getWatchlist.url, response: MovieResults.self) { (response, error) in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    class func getFavorites(completion: @escaping ([Movie], Error?) -> Void) {
        TMDBClient.taskForGetRequest(url: TMDBClient.Endpoints.getFavorites.url, response: MovieResults.self) { (response, error) in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    class func searchMovies(query: String, completion: @escaping ([Movie], Error?) -> Void){
        TMDBClient.taskForGetRequest(url: TMDBClient.Endpoints.searchMovies(query).url, response: MovieResults.self) { (response, error) in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    class func markWatchList(movieId: Int, watchlist: Bool, completion: @escaping (Bool, Error?) -> Void){
        let requestBody = MarkWatchlist(mediaType: "movie", mediaId: movieId, watchlist: watchlist)
        TMDBClient.taskForPostRequest(url: TMDBClient.Endpoints.markWatchList.url, method: "POST", requestBody: requestBody, reponse: TMDBResponse.self) { (response, error) in
            if let response = response {
                completion(response.statusCode == 1 || response.statusCode == 12 || response.statusCode == 13 , nil)
            }
            else {
                completion(false, nil)
            }
        }
    }
    
    class func markFavorite(movieId: Int, favorite: Bool, completion: @escaping (Bool, Error?) -> Void){
        let requestBody = MarkFavorite(mediaType: "movie", mediaId: movieId, favorite: favorite)
        TMDBClient.taskForPostRequest(url: TMDBClient.Endpoints.markFavorite.url, method: "POST", requestBody: requestBody, reponse: TMDBResponse.self) { (response, error) in
            if let response = response {
                completion(response.statusCode == 1 || response.statusCode == 12 || response.statusCode == 13 , nil)
            }
            else {
                completion(false, nil)
            }
        }
    }
    
    class func downloadPosterImage(imagePath: String, completion: @escaping (Data?, Error?) -> Void){
        let task = URLSession.shared.dataTask(with: TMDBClient.Endpoints.getPosterImage(imagePath).url) { (data, response, error) in
            guard let data = data else{
                completion(nil, error)
                return
            }
            completion(data, error)
        }
        task.resume()
    }
}

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
}

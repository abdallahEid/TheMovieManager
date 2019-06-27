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
}

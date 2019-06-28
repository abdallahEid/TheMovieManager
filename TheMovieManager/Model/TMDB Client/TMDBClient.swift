//
//  TMDBClient.swift
//  TheMovieManager
//
//  Created by Owen LaRosa on 8/13/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation

class TMDBClient {
    
    static let apiKey = "34598197fdde2c0e7acc2c41bc1a18ab"
    
    struct Auth {
        static var accountId = 0
        static var requestToken = ""
        static var sessionId = ""
    }
    
    enum Endpoints {
        static let base = "https://api.themoviedb.org/3"
        static let apiKeyParam = "?api_key=\(TMDBClient.apiKey)"
        
        case getRequestToken
        case login
        case createSessionID
        case webAuth
        case logout
        
        case getWatchlist
        case getFavorites
        case searchMovies(String)
        case markWatchList
        case markFavorite
        case getPosterImage(String)
        
        var stringValue: String {
            switch self {
            case .getRequestToken:
                return Endpoints.base + "/authentication/token/new" + Endpoints.apiKeyParam
            case .login:
                return Endpoints.base + "/authentication/token/validate_with_login" + Endpoints.apiKeyParam
            case .createSessionID:
                return Endpoints.base + "/authentication/session/new" + Endpoints.apiKeyParam
            case .webAuth:
                return "https://www.themoviedb.org/authenticate/" + Auth.requestToken + "?redirect_to=themoviemanager:authenticate"
            case .logout:
                return "/authentication/session" + Endpoints.apiKeyParam
                
            case .getWatchlist:
                return Endpoints.base + "/account/\(Auth.accountId)/watchlist/movies" + Endpoints.apiKeyParam + "&session_id=\(Auth.sessionId)"
            case.getFavorites:
                return Endpoints.base + "/account/\(Auth.accountId)/favorite/movies" + Endpoints.apiKeyParam + "&session_id=\(Auth.sessionId)"
            case .searchMovies(let query):
                return Endpoints.base + "/search/movie" + Endpoints.apiKeyParam + "&query=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
            case .markWatchList:
                return Endpoints.base + "/account/\(Auth.accountId)/watchlist" + Endpoints.apiKeyParam + "&session_id=\(Auth.sessionId)"
            case .markFavorite:
                return Endpoints.base + "/account/\(Auth.accountId)/favorite" + Endpoints.apiKeyParam + "&session_id=\(Auth.sessionId)"
            case .getPosterImage(let path):
                return "https://image.tmdb.org/t/p/w500/\(path)"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func taskForGetRequest<ResponseType: Decodable>(url: URL, response: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> ()){
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(nil, error)
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                completion(responseObject, nil)
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    class func taskForPostRequest<ResponseType: Decodable, RequestBody: Encodable>(url: URL, method: String, requestBody: RequestBody ,reponse: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> () ){
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(requestBody)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completion(nil, error)
                return
            }
            do {
                let decoder = JSONDecoder()
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                completion(responseObject, nil)
            } catch {
                completion(nil, error)
            }
            
        }
        task.resume()
    }
    
}

//
//  AuthenticationAPIs.swift
//  TheMovieManager
//
//  Created by Abdallah Eid on 6/28/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

class AuthenticationAPIs {
    class func getRequestToken(completion: @escaping (Bool, Error?) -> Void){
        TMDBClient.taskForGetRequest(url: TMDBClient.Endpoints.getRequestToken.url, response: RequestTokenResponse.self) { (response, error) in
            if let response = response {
                TMDBClient.Auth.requestToken = response.requestToken
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void){
        let requestBody = LoginRequest(username: username, password: password, requestToken: TMDBClient.Auth.requestToken)
        TMDBClient.taskForPostRequest(url: TMDBClient.Endpoints.login.url, method: "POST", requestBody: requestBody, reponse: RequestTokenResponse.self) { (response, error) in
            if let response = response {
                TMDBClient.Auth.requestToken = response.requestToken
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func createSessionID(completion: @escaping (Bool, Error?) -> Void){
        let requestBody = PostSession(requestToken: TMDBClient.Auth.requestToken)
        TMDBClient.taskForPostRequest(url: TMDBClient.Endpoints.createSessionID.url, method: "POST", requestBody: requestBody, reponse: SessionResponse.self) { (response, error) in
            if let response = response {
                TMDBClient.Auth.sessionId = response.sessionId
                let saveRequestToken: Bool = KeychainWrapper.standard.set(TMDBClient.Auth.requestToken, forKey: "requestToken")
                let saveSessionId: Bool = KeychainWrapper.standard.set(TMDBClient.Auth.sessionId, forKey: "sessionId")
                if (saveSessionId && saveRequestToken){
                    completion(true, nil)
                } else {
                    completion(false, error)
                }
            } else {
                completion(false, error)
            }
        }
    }
    
    class func logout(completion: @escaping () -> ()){
        var request = URLRequest(url: TMDBClient.Endpoints.logout.url)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = LogoutRequest(sessionId: TMDBClient.Auth.sessionId)
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            TMDBClient.Auth.requestToken = ""
            TMDBClient.Auth.sessionId = ""
            let removeRequestToken: Bool = KeychainWrapper.standard.removeObject(forKey: "requestToken")
            let removeSessionId: Bool = KeychainWrapper.standard.removeObject(forKey: "sessionId")
            if removeRequestToken && removeSessionId {
                completion()
            } else{
                print("How")
            }
        }
        task.resume()
    }
}

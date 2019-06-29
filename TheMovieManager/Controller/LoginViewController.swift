//
//  LoginViewController.swift
//  TheMovieManager
//
//  Created by Owen LaRosa on 8/13/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginViaWebsiteButton: UIButton!
    @IBOutlet weak var activityController: UIActivityIndicatorView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        print("here")
        setLogginIn(logginIn: true)
        AuthenticationAPIs.getRequestToken(completion: getRequestCompletionHandler(success:error:))
    }
    
    @IBAction func loginViaWebsiteTapped() {
        setLogginIn(logginIn: true)
        AuthenticationAPIs.getRequestToken { (success, error) in
            if success {
                DispatchQueue.main.async {
                    UIApplication.shared.open(TMDBClient.Endpoints.webAuth.url, options: [:], completionHandler: nil)
                }
            }
        }
    }
    
    func getRequestCompletionHandler(success: Bool?, error: Error?){
        guard success != nil else {
            print(error?.localizedDescription ?? " ")
            return
        }
        print(TMDBClient.Auth.requestToken)
        DispatchQueue.main.async {
            AuthenticationAPIs.login(username: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "" , completion: self.loginCompletionHandler(success:error:))
        }
    }
    
    func loginCompletionHandler(success: Bool?, error: Error?){
        if success == false {
            DispatchQueue.main.async {
                self.showLoginFailure(message: error?.localizedDescription ?? " ")
            }
            return
        }
        print(TMDBClient.Auth.requestToken)
        AuthenticationAPIs.createSessionID(completion: createSessionCompletionHandler(success:error:))
    }
    
    func createSessionCompletionHandler(success: Bool?, error: Error?){
        setLogginIn(logginIn: false)
        if success == false {
            DispatchQueue.main.async {
                self.showLoginFailure(message: error?.localizedDescription ?? " ")
            }
            return
        }
        print(TMDBClient.Auth.sessionId)
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "completeLogin", sender: nil)
        }
    }
    
    func setLogginIn(logginIn: Bool){
        if logginIn{
            activityController.startAnimating()
        } else {
            DispatchQueue.main.async {
                self.activityController.stopAnimating()
            }
        }
        DispatchQueue.main.async {
            self.emailTextField.isEnabled = !logginIn
            self.passwordTextField.isEnabled = !logginIn
            self.loginButton.isEnabled = !logginIn
            self.loginViaWebsiteButton.isEnabled = !logginIn
        }
    }
    
    func showLoginFailure(message: String) {
        setLogginIn(logginIn: false)
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
}

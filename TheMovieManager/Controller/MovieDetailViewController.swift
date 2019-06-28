//
//  MovieDetailViewController.swift
//  TheMovieManager
//
//  Created by Owen LaRosa on 8/13/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var watchlistBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var favoriteBarButtonItem: UIBarButtonItem!
    
    var movie: Movie!
    
    var isWatchlist: Bool {
        return MovieModel.watchlist.contains(movie)
    }
    
    var isFavorite: Bool {
        return MovieModel.favorites.contains(movie)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = movie.title
        
        if let posterPath = movie.posterPath {
            MoviesAPIs.downloadPosterImage(imagePath: posterPath, completion: posterImageCompletionHandler(data:error:))
        }

        toggleBarButton(watchlistBarButtonItem, enabled: isWatchlist)
        toggleBarButton(favoriteBarButtonItem, enabled: isFavorite)
        
    }
    
    @IBAction func watchlistButtonTapped(_ sender: UIBarButtonItem) {
        MoviesAPIs.markWatchList(movieId: movie.id, watchlist: !isWatchlist, completion: watchlistCompletionHandler(success:error:))
    }
    
    @IBAction func favoriteButtonTapped(_ sender: UIBarButtonItem) {
        MoviesAPIs.markFavorite(movieId: movie.id, favorite: !isFavorite, completion: favoriteCompletionHandler(success:error:))
    }
    
    func toggleBarButton(_ button: UIBarButtonItem, enabled: Bool) {
        if enabled {
            button.tintColor = UIColor.primaryDark
        } else {
            button.tintColor = UIColor.gray
        }
    }
    
    func watchlistCompletionHandler(success: Bool, error: Error?){
        if success {
            if isWatchlist {
                MovieModel.watchlist = MovieModel.watchlist.filter(){
                     $0 != self.movie
                }
            } else {
                MovieModel.watchlist.append(movie)
            }
            DispatchQueue.main.async {
                self.toggleBarButton(self.watchlistBarButtonItem, enabled: self.isWatchlist)
            }
            
        }
    }
    
    func favoriteCompletionHandler(success: Bool, error: Error?){
        if success {
            if isFavorite {
                MovieModel.favorites = MovieModel.favorites.filter(){
                    $0 != self.movie
                }
            } else {
                MovieModel.favorites.append(movie)
            }
            DispatchQueue.main.async {
                self.toggleBarButton(self.favoriteBarButtonItem, enabled: self.isFavorite)
            }
        }
    }
    
    func posterImageCompletionHandler(data: Data?, error: Error?){
        guard let data = data else {
            return
        }
        DispatchQueue.main.async {
            self.imageView.image = UIImage(data: data)
        }
    }
    
    
}

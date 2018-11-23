//
//  MovieDetailsPresenter.swift
//  MovieApp
//
//  Created by Madan on 20/11/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import UIKit

class MovieDetailsPresenter: NSObject{
    
    var moiveDetailsData: Details?
    var collectionsMovies: CollectionMovies?
    var errorString:String?
    private let cellIdentifier = "MovieCollectionViewCell"

    
    let movieId: Int64?
    
        init(with movieId: Int64) {
        self.movieId = movieId
    }
    
    func registerCells(for collectionView: UICollectionView) {
        collectionView.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil),forCellWithReuseIdentifier: cellIdentifier)
    }
    
    
    func fetchMoviesDetails(completion: @escaping (() -> ())) {
        let serviceLayer = ServiceLayer()
        if let movieId = self.movieId {
            serviceLayer.servcieRequestDetails(urlString:"movie/\(movieId)") { (movieDetails, errString) in
                if let errString = errString{
                    self.errorString = errString
                    completion()
                }
                if let movieDetails = movieDetails{
                    self.moiveDetailsData = movieDetails as Details?
                    //print(movieDetails)
                    completion()
                }
            }
            
        }
        
    }
    
    func fetchCollectionMovies(completion: @escaping (() -> ())) {
        let serviceLayer = ServiceLayer()
        if let obj = self.moiveDetailsData {
            if (obj.belongsToCollection?.collectionId) != nil{
                
                if let collectionId = obj.belongsToCollection?.collectionId{
                    //print(collectionId)
                    let urlString = "collection/\(collectionId)"
                    serviceLayer.servcieRequestCollection(urlString:urlString) { (collectionMovies, errString) in
                        if let errString = errString{
                            self.errorString = errString
                            completion()
                        }
                        if let collectionMovies = collectionMovies{
                            self.collectionsMovies = collectionMovies as CollectionMovies?
                            //print(collectionMovies)
                            completion()
                        }
                    }
                }
                
            }else{
                self.errorString = "Simillar Collection Movies not available"
                //print("Simillar Collection Movies not available")
                completion()
            }
        }
    }
}

extension MovieDetailsPresenter: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        if let movieCount = self.collectionsMovies?.parts?.count {
            return movieCount
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? MovieCollectionViewCell
        
        if cell != nil {
            if let obj =  collectionsMovies?.parts?[indexPath.row]{
                
                cell?.posterImageView.image = UIImage(named: "defaultImage")
                if let posterImageString = obj.posterPath{
                    let formatedImageUrl = GlobalConstants.kImageBaseURL + posterImageString
                    let url = URL(string:formatedImageUrl)
                    DispatchQueue.global().async {
                        if let url = url{
                            let data = try? Data(contentsOf: url)
                            if let data = data{
                                DispatchQueue.main.async {
                                    cell?.posterImageView.image = UIImage(data: data)
                                }
                            }
                        }else{
                            //print("URL is not proper")
                        }
                    }
                }
                else{
                    //print("url string does not exists")
                }
            }
        }
        return cell!
    }
}
 


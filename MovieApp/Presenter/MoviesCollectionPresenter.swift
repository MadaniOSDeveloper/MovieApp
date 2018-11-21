//
//  MoviesCollectionPresenter.swift
//  MovieApp
//
//  Created by Madan on 20/11/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import UIKit

class MoviesCollectionPresenter: NSObject{
    
    var moiveDataSource:Movies?
    var errorString:String?
    private let cellIdentifier = "MoviesCollectionViewCell"
   
    func fetchMovies(completion: @escaping (() -> ())) {
        let serviceLayer = ServiceLayer()
        serviceLayer.servcieRequestMovies(urlString:GlobalConstants.kNowPlaying) { (movies, errString) in
            if let errString = errString{
                self.errorString = errString
                completion()
            }
            if let movies = movies{
                self.moiveDataSource = movies as Movies?
                completion()
            }
        }
    }
    func registerCells(for collectionView: UICollectionView) {
        collectionView.register(UINib(nibName: "MoviesCollectionViewCell", bundle: nil),forCellWithReuseIdentifier: cellIdentifier)
    }
}

extension MoviesCollectionPresenter: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        if let movieCount = moiveDataSource?.result?.count {
            return movieCount
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? MoviesCollectionViewCell
        
        if cell != nil {
            if let obj =  moiveDataSource?.result?[indexPath.row]{
                cell?.movieTitle.text = obj.title!
                cell?.moviePosterImageView.image = UIImage(named: "defaultImage")
                if let posterImage = obj.posterPath{
                    let formatedImageUrl = GlobalConstants.kImageBaseURL + posterImage
                    let url = URL(string:formatedImageUrl)
                    DispatchQueue.global().async {
                        if let url = url{
                            let data = try? Data(contentsOf: url)
                            if let data = data{
                                DispatchQueue.main.async {
                                    cell?.moviePosterImageView.image = UIImage(data: data)
                                }
                            }
                        }else{
                            print("URL does not exists")
                        }
                    }
                }
                print("URL does not exists")
                
            }
        }
        return cell!
    }
}

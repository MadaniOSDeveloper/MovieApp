//
//  MovieDetailViewController.swift
//  MovieApp
//
//  Created by Madan on 20/11/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var released: UILabel!
    
    @IBOutlet weak var overviewTextView: UITextView!
    
    @IBOutlet weak var movieCollectionLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func backAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    let presenter: MovieDetailsPresenter!
    init(with presenter: MovieDetailsPresenter) {
        self.presenter = presenter
        super.init(nibName: "MovieDetailViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadDetails(){
        self.presenter.fetchMoviesDetails { [weak self] in
            
            if let errorMessage = self?.presenter.errorString{
                let errorAlert  = UIAlertController(title: "Error!", message: errorMessage, preferredStyle: UIAlertController.Style.alert)
                let action  = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: { (action) in
                    errorAlert.dismiss(animated: true, completion: {
                        errorAlert.dismiss(animated: true, completion: nil)
                    })
                })
                errorAlert.addAction(action)
                DispatchQueue.main.async {
                    self?.present(errorAlert, animated: true, completion: nil)
                }
            }
            else{
                DispatchQueue.main.async {
                    self?.loadDetailView()
                    self?.fetchCollections()
                }
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCollectionView()
        self.loadDetails()
    }
    
    func fetchCollections(){
        self.presenter.fetchCollectionMovies { [weak self] in
            
            if let errorMessage = self?.presenter.errorString{
                let errorAlert  = UIAlertController(title: "Error!", message: errorMessage, preferredStyle: UIAlertController.Style.alert)
                let action  = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: { (action) in
                    errorAlert.dismiss(animated: true, completion: {
                        errorAlert.dismiss(animated: true, completion: nil)
                    })
                })
                errorAlert.addAction(action)
                DispatchQueue.main.async {
                    //self?.present(errorAlert, animated: true, completion: nil)
                    self?.collectionView.isHidden = true
                    self?.movieCollectionLabel.isHidden = true
                }
            }
            else{
                DispatchQueue.main.async {
                    self?.collectionView.isHidden = false
                    self?.movieCollectionLabel.isHidden = false
                    self?.collectionView.reloadData()
                }
            }
        }
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = presenter
        presenter.registerCells(for: collectionView)
    }
    
    func loadDetailView(){
        if let titleString = self.presenter.moiveDetailsData?.title{
            self.movieTitle.text = titleString
        }
        if let releaseDate = self.presenter.moiveDetailsData?.releaseDate{
            self.released.text = releaseDate
        }
        if let popularityString = self.presenter.moiveDetailsData?.popularity{
            self.status.text = "Popularity: \(popularityString)"
        }
        if let textView = self.presenter.moiveDetailsData?.overview{
            overviewTextView.text = "Overview : \(textView)"
        }

        if let imageUrlString = self.presenter.moiveDetailsData?.posterPath{
            let formatedImageUrl = GlobalConstants.kImageBaseURL + imageUrlString
            let url = URL(string:formatedImageUrl)
            DispatchQueue.global().async {
                if let url = url{
                    let data = try? Data(contentsOf: url)
                    if let data = data{
                        DispatchQueue.main.async {
                            self.moviePoster.image = UIImage(data: data)
                        }
                    }
                }
                
            }
        }
    }
}
extension MovieDetailViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

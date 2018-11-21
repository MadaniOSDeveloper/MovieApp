//
//  ViewController.swift
//  MovieApp
//
//  Created by Madan on 20/11/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let presenter: MoviesCollectionPresenter!
    var collectionView: UICollectionView!

    init(with presenter: MoviesCollectionPresenter){
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCollectionView() {
        collectionView = UICollectionView(frame: self.view.frame,collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = presenter
        presenter.registerCells(for: collectionView)
        self.view.addSubview(collectionView)
    }
    let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        let insetLeft: CGFloat = 5.0
        let insetRight: CGFloat = 5.0
        layout.sectionInset = UIEdgeInsets(top: 10,
                                           left: insetLeft,
                                           bottom: 5.0,
                                           right: insetRight)
        let itemWidth = UIScreen.main.bounds.width / 2 - (insetLeft + insetRight)
        layout.itemSize = CGSize(width: itemWidth, height: 300.0)
        return layout
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
            self.presenter.fetchMovies {[weak self] in
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
                        self?.collectionView.reloadData()
                        }
                }
        }
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let movieId = presenter.moiveDataSource?.result?[indexPath.row].id else { return }
        let detailsPresenter = MovieDetailsPresenter(with: movieId)
        let detailsController = MovieDetailViewController(with: detailsPresenter)
        self.present(detailsController, animated: true, completion: nil)    }
}

//
//  DetailViewController.swift
//  Movies
//
//  Created by Павел Калинин on 24.12.2024.
//

import UIKit

class DetailViewController: UIViewController {
    let detailView = DetailView()
    let imagesDataSource = ImagesDataSource(images: [])
    var movie: Movie?
    
    var error: String? {
        didSet {
            if let error = error {
                detailView.showErrorLabel(with: error)
            } else {
                detailView.hideErrorLabel()
            }
        }
    }
    
    lazy var rigthView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .bookmark
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(saveButtonTapped)))
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailView.imagesCollectionView.imagesCollectionView.delegate = self
        detailView.imagesCollectionView.imagesCollectionView.dataSource = imagesDataSource
        setupNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let movie = movie {
            let isMovieSaved = CoreDataManager.shared.isSaved(movieID: movie.id)
            rigthView.image = isMovieSaved ? .bookmarkFilled : .bookmark
        }
    }
    
    override func loadView() {
        view = detailView
    }
    
    private func setupNavigationBar() {
        let navBar = navigationController!.navigationBar
        navigationItem.title = "Подробно"
        navBar.tintColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rigthView)
        
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backButtonTapped))
    }
    
    func configure(with movie: Movie?) {
        guard let movie = movie else { return }
        self.movie = movie
        detailView.configure(with: movie)
        detailView.stopLoadingMovie()
        imagesDataSource.updateDataSource(movie.images ?? [])
        detailView.reloadCollectionView()
        detailView.imagesCollectionView.setupController()
        
        let isMovieSaved = CoreDataManager.shared.isSaved(movieID: movie.id)
        rigthView.image = isMovieSaved ? .bookmarkFilled : .bookmark
    }
    
    //MARK: objc methods
    @objc private func saveButtonTapped() {
        guard let movie = movie else { return }
        let isMovieSaved = CoreDataManager.shared.isSaved(movieID: movie.id)
        
        if isMovieSaved {
            CoreDataManager.shared.removeFromFavorites(movieID: movie.id)
        } else {
            CoreDataManager.shared.saveSavedMovie(movie: movie)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.rigthView.image = !isMovieSaved ? .bookmarkFilled : .bookmark
        }
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

extension DetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        detailView.imagesCollectionView.currentPage = indexPath.item + 1
        
        detailView.imagesCollectionView.pagers.forEach { pager in
            pager.constraints.forEach { constr in
                pager.removeConstraint(constr)
            }
            
            if detailView.imagesCollectionView.currentPage == pager.tag {
                pager.layer.opacity = 1
                detailView.imagesCollectionView.pagerWidthAnchor = pager.widthAnchor.constraint(equalToConstant: 20)
            } else {
                pager.layer.opacity = 0.5
                detailView.imagesCollectionView.pagerWidthAnchor = pager.widthAnchor.constraint(equalToConstant: 10)
            }
            
            detailView.imagesCollectionView.pagerWidthAnchor?.isActive = true
            pager.heightAnchor.constraint(equalToConstant: 10).isActive = true
        }
    }
}

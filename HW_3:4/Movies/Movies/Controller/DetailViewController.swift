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
    var isMovieSaved = false
    
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
        detailView.imagesCollectionView.setupController()
        setupNavigationBar()
    }
    
    override func loadView() {
        view = detailView
    }
    
    private func setupNavigationBar() {
        let navBar = navigationController!.navigationBar
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.title = "Подробно"
        navBar.tintColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rigthView)
        navigationItem.backBarButtonItem = backButton
    }
    
    func configure(with movie: Movie?) {
        guard let movie = movie else { return }
        self.movie = movie
        detailView.configure(with: movie)
        imagesDataSource.updateDataSource(movie.images ?? [])
        detailView.imagesCollectionView.reloadCollectionView()
    }
    
    //MARK: objc methods
    @objc func saveButtonTapped() {
        isMovieSaved.toggle()
        UIView.animate(withDuration: 0.3) {
            self.rigthView.image = self.isMovieSaved ? .bookmarkFilled : .bookmark
        }
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

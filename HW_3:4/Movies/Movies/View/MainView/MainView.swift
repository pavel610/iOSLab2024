//
//  MainView.swift
//  Movies
//
//  Created by Павел Калинин on 20.12.2024.
//

import UIKit

class MainView: UIView {
    lazy var searchView = SearchView()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        view.addSubview(topCollectionView)
        return view
    }()
    
    lazy var topCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 30
        layout.itemSize = CGSize(width: 145, height: 210)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TopCollectionViewCell.self, forCellWithReuseIdentifier: TopCollectionViewCell.reusableIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = AppColors.mainColor
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        return collectionView
    }()
    
    lazy var scrollView: UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
//        scrollView.isDirectionalLockEnabled = true
//        scrollView.canCancelContentTouches = false
//        scrollView.delaysContentTouches = false
        return scrollView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = AppColors.mainColor
        setupUI()
        //topCollectionView.panGestureRecognizer.require(toFail: scrollView.panGestureRecognizer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(searchView)
        addSubview(scrollView)
        scrollView.addSubview(contentView)

        searchView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            searchView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            searchView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            searchView.heightAnchor.constraint(equalToConstant: 45),
            
            scrollView.topAnchor.constraint(equalTo: searchView.bottomAnchor, constant: 10),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -55),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            topCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            topCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            topCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            topCollectionView.heightAnchor.constraint(equalToConstant: 250),
        ])
    }
}

//topCollectionView.topAnchor.constraint(equalTo: searchView.bottomAnchor, constant: 20),
//topCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
//topCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
//topCollectionView.heightAnchor.constraint(equalToConstant: 250)

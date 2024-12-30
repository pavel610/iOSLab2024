//
//  WatchListView.swift
//  Movies
//
//  Created by Павел Калинин on 23.12.2024.
//

import UIKit

class WatchListView: UIView {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 15
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 64, height: 130)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(WatchListCollectionViewCell.self, forCellWithReuseIdentifier: WatchListCollectionViewCell.reuseIdentifier)
        collectionView.backgroundColor = AppColors.mainColor
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = AppColors.mainColor
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 5),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -60),
        ])
    }
    
    func reloadSavedCollectionView() {
        collectionView.reloadData()
    }
}

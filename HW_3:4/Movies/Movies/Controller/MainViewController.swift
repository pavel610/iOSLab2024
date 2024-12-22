//
//  ViewController.swift
//  Movies
//
//  Created by Павел Калинин on 19.12.2024.
//

import UIKit

class MainViewController: UIViewController {
    let mainView = MainView()
    private let dataManager = DataManager.shared
    private var topListDataSource: TopListDataSource = TopListDataSource(movies: [])
        
    lazy var navigationTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Что хотите посмотреть?"
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        loadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.topCollectionView.delegate = self
        mainView.topCollectionView.dataSource = topListDataSource
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navigationTitleLabel)
    }

    override func loadView() {
        view = mainView
    }
    
    private func loadData() {
        Task {
            let movies = try await dataManager.obtainTopMovies()
            self.topListDataSource.updateMovies(movies)
            self.mainView.topCollectionView.reloadData()
        }
    }
}

extension MainViewController: UICollectionViewDelegate {}

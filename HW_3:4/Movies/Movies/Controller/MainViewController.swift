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
    private let topListDataSource: TopListDataSource = TopListDataSource(movies: [])
    private let allMoviesDataSource = AllMoviesDataSource(allMovies: [])
        
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
        mainView.customSegmentedControl.onSegmentSelected = {[weak self] city in
            guard let self = self else { return }
            Task {
                let allMovies = try await self.dataManager.obtainAllMovies(in: self.mainView.customSegmentedControl.getCurrentValue())
                self.allMoviesDataSource.updateDataSource(with: allMovies)
                self.mainView.listCollectionView.reloadData()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.topCollectionView.delegate = self
        mainView.topCollectionView.dataSource = topListDataSource
        mainView.listCollectionView.delegate = self
        mainView.listCollectionView.dataSource = allMoviesDataSource
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navigationTitleLabel)
    }

    override func loadView() {
        view = mainView
    }
    
    private func loadData() {
        Task {
            let movies = try await dataManager.obtainTopMovies()
            self.topListDataSource.updateMovies(movies)
            let cities = try await dataManager.obtainCities()
            mainView.customSegmentedControl.updateDataSource(with: cities)
            let allMovies = try await dataManager.obtainAllMovies(in: mainView.customSegmentedControl.getCurrentValue())
            allMoviesDataSource.updateDataSource(with: allMovies)
            
            mainView.activityIndicator.stopAnimating()
            mainView.reloadCityCollectionView()
            mainView.reloadTopCollectionView()
            mainView.reloadListCollectionView()
        }
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let dataSource = collectionView.dataSource as? (any DataSourceProtocol) else { return }
        Task {
            let movie = try await dataManager.obtainDetailInfoById(id: (dataSource.getItemByIndex(indexPath.item) as! Movie).id)
            let detailViewController = DetailViewController()
            detailViewController.configure(with: movie)
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}

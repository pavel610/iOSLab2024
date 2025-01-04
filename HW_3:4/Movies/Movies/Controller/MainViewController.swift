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
    
    private var error: String? {
        didSet {
            if let error = error {
                mainView.showErrorLabel(with: error)
            } else {
                mainView.hideErrorLabel()
            }
        }
    }
        
    private lazy var navigationTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Что хотите посмотреть?"
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        loadData()
        setupSegmentControlAction()
        
        mainView.topCollectionView.delegate = self
        mainView.topCollectionView.dataSource = topListDataSource
        
        mainView.listCollectionView.delegate = self
        mainView.listCollectionView.dataSource = allMoviesDataSource
        
        mainView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        mainView.refreshButton.addTarget(self, action: #selector(loadData), for: .touchUpInside)
        
        mainView.searchView.iconContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(findMovieByName)))
        mainView.searchView.searchTextField.delegate = self
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navigationTitleLabel)
    }

    override func loadView() {
        view = mainView
    }
    
    private func setupSegmentControlAction() {
        mainView.customSegmentedControl.onSegmentSelected = {[weak self] city in
            guard let self = self else { return }
            Task {
                self.mainView.startUpdatingAllMovies()
                let allMovies = try await self.dataManager.obtainInitialAllMovies(in: self.mainView.customSegmentedControl.getCurrentValue())
                //Обновление коллекции при смене города
                self.mainView.listCollectionView.performBatchUpdates({
                    let itemCount = self.allMoviesDataSource.getItems().count
                    let indexPaths = (0..<itemCount).map { IndexPath(item: $0, section: 0) }
                    self.allMoviesDataSource.removeAll()
                    self.mainView.listCollectionView.deleteItems(at: indexPaths)
                    
                    // После удаления добавляем новые элементы
                    self.allMoviesDataSource.updateDataSource(with: allMovies)
                    let newIndexPaths = (0..<self.allMoviesDataSource.getItems().count).map { IndexPath(item: $0, section: 0) }
                    self.mainView.listCollectionView.insertItems(at: newIndexPaths)
                }, completion: { isFinished in
                    self.mainView.finishUpdatingAllMovies()
                })
            }
        }
    }
    
    @objc private func loadData() {
        Task {
            do {
                let movies = try await dataManager.obtainTopMovies()
                self.topListDataSource.updateMovies(movies)
                let cities = try await dataManager.obtainCities()
                mainView.customSegmentedControl.updateDataSource(with: cities)
                let allMovies = try await dataManager.getInitialMovies(in: mainView.customSegmentedControl.getCurrentValue())
                allMoviesDataSource.updateDataSource(with: allMovies)
                
                mainView.stopLoadingPageAnimation()
                mainView.reloadCityCollectionView()
                mainView.reloadTopCollectionView()
                mainView.reloadListCollectionView()
            } catch {
                self.error = error.localizedDescription
            }
        }
    }
    
    @objc private func findMovieByName(){
        let name = mainView.searchView.getText()
        guard !name.isEmpty else { return }
        
        let allItems = allMoviesDataSource.getItems() + topListDataSource.getItems()
        if let movie = allItems.first(where: {$0.title.lowercased() == name.lowercased()}) {
            Task {
                let detailMovie = try await dataManager.obtainDetailInfoById(id: movie.id)
                let detailViewController = DetailViewController()
                detailViewController.configure(with: detailMovie)
                navigationController?.pushViewController(detailViewController, animated: true)
            }
        } else {
            let alert = UIAlertController(title: "", message: "Фильма с таким названием не найдено", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            })
            alert.addAction(ok)
            present(alert, animated: true)
        }
    }
    
    @objc private func nextButtonTapped(_ sender: UIButton) {
        Task {
            UIView.animate(withDuration: 0.3) {
                sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            } completion: { _ in
                UIView.animate(withDuration: 0.1) {
                    sender.transform = .identity
                }
            }
            let movies = try await dataManager.obtainNextPageAllMovies()
            
            mainView.listCollectionView.performBatchUpdates {
                allMoviesDataSource.addItems(movies)
                let items = allMoviesDataSource.getItems()
                let newIndexPaths = ((items.count - movies.count)..<items.count).map { IndexPath(item: $0, section: 0) }
                mainView.listCollectionView.insertItems(at: newIndexPaths)
            }
        }
    }
    
    @objc private func hideKeyboard(_ sender: UIView) {
        sender.endEditing(true)
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath),
              let dataSource = collectionView.dataSource as? (any CollectionDataSourceProtocol) else { return }
        
        let animator = UIViewPropertyAnimator(duration: 0.1, curve: .easeInOut) {
            cell.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }

        animator.addCompletion { _ in
            let returnAnimator = UIViewPropertyAnimator(duration: 0.1, curve: .easeInOut) {
                cell.transform = .identity
            }
            returnAnimator.startAnimation()
        }

        animator.startAnimation()

        let detailViewController = DetailViewController()
        navigationController?.pushViewController(detailViewController, animated: true)
        Task {
            do {
                let movie = try await dataManager.obtainDetailInfoById(id: (dataSource.getItemByIndex(indexPath.item) as! Movie).id)
                detailViewController.configure(with: movie)
            } catch {
                detailViewController.error = error.localizedDescription
            }
        }
    }
}

extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        findMovieByName()
        textField.resignFirstResponder()
        return true
    }
}

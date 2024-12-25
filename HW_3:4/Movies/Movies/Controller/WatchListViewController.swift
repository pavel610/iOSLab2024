//
//  ViewController2.swift
//  Movies
//
//  Created by Павел Калинин on 20.12.2024.
//

import UIKit

class WatchListViewController: UIViewController {
    let watchListView = WatchListView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    
    override func loadView() {
        view = watchListView
    }
    
    private func setupNavigationBar() {
        let navBar = navigationController!.navigationBar
        navigationItem.title = "Избранное"
        navBar.tintColor = .white
    }
}

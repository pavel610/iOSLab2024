//
//  MainViewController.swift
//  HW_2.2
//
//  Created by Павел Калинин on 06.04.2025.
//

import UIKit

class MainViewController: UIViewController {
    
    let mainViewModel = MainViewModel()
    
    lazy var taskListTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TaskListTableViewCell.self, forCellReuseIdentifier: TaskListTableViewCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupLayout()
        setupBindings()
    }
    
    private func setupNavigationBar() {
        //При нажатии на плюс показывает alert с полем для ввода
        let action = UIAction {[weak self] _ in
            let alert = UIAlertController(title: "Новая задача", message: "Введите текст", preferredStyle: .alert)
            
            let addAlertAction = UIAlertAction(title: "Добавить", style: .default) { action in
                if let text = alert.textFields?.first?.text, !text.isEmpty {
                    self?.mainViewModel.addTask(title: text)
                    self?.taskListTableView.reloadData()
                }
            }
            
            let cancelAlertAction = UIAlertAction(title: "Отмена", style: .cancel)
            
            alert.addTextField()
            alert.addAction(addAlertAction)
            alert.addAction(cancelAlertAction)
            
            self?.present(alert, animated: true)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .add, primaryAction: action)
    }
    
    private func setupLayout() {
        view.addSubview(taskListTableView)
        
        NSLayoutConstraint.activate([
            taskListTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            taskListTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            taskListTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            taskListTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupBindings() {
        mainViewModel.onTasksUpdated = {[weak self] _ in
            self?.taskListTableView.reloadData()
        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        mainViewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskListTableViewCell.reuseIdentifier) as? TaskListTableViewCell else { return UITableViewCell()}
        cell.configure(with: mainViewModel.items[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            mainViewModel.deleteTask(at: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mainViewModel.toggleTaskCompletion(at: indexPath.row)
    }
}

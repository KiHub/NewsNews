//
//  ListViewController.swift
//  NewsNews
//
//  Created by  Mr.Ki on 02.05.2022.
//

import UIKit

class ListViewController: UIViewController {

    let cellId = "cell"
    var tableView = UITableView()
    var savedNewsToDisplay = [PostList]()
    let refreshControl = UIRefreshControl()
    let converter = ColorConverter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        NotificationCenter.default.addObserver(forName: NSNotification.Name("loaded"), object: nil, queue: nil) { _ in
            self.downloadNewsFromList()
        }
    }

    func setup() {
        downloadNewsFromList()
        setupTableView()
        setupRefreshControl()
    }

    private func setupTableView() {
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.backgroundColor = converter.hexStringToUIColor(hex: "#212529")
        tableView.separatorStyle = .none
        
      //  tableView.tableFooterView = UIView()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
}

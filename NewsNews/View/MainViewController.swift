//
//  MainViewController.swift
//  NewsNews
//
//  Created by  Mr.Ki on 01.05.2022.
//

import UIKit

class MainViewController: UIViewController {
    
    lazy var newsPresenter = NewsPresenter(newsService: NewsService(), newsView: self)
    
    let cellId = "cell"
    var tableView = UITableView()
    var newsToDisplay = [Post]()
    let refreshControl = UIRefreshControl()
    let converter = ColorConverter()
    let animation = Animation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        setup()
        newsPresenter.getNews()
    }
    
    func setup() {
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


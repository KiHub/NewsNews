//
//  MainViewController.swift
//  NewsNews
//
//  Created by  Mr.Ki on 01.05.2022.
//

import UIKit

class MainViewController: UIViewController {
    
    var newsPresenter: NewsPresenterProtocol!
    
    let cellId = "cell"
    var tableView = UITableView()
    var newsToDisplay = [Post]()
    let refreshControl = UIRefreshControl()
    let animation = Animation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
    }
    
    func setup() {
        newsPresenter.getNews(url: url)
        setupTableView()
        setupHeaderView()
        setupRefreshControl()
        setStatusBar()
        navigationController?.navigationBar.isHidden = true
        
    }
    
    private func setStatusBar() {
        let statusbarSize = UIApplication.shared.statusBarFrame.size
        let frame = CGRect(origin: .zero, size: statusbarSize)
        let statusbarView = UIView(frame: frame)
        statusbarView.backgroundColor = appMainColor
        view.addSubview(statusbarView)
    }
    
    private func setupTableView() {
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.backgroundColor = appMainColor
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupHeaderView() {
        let header = HeaderMainView(frame: .zero)
        var size = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        size.width = UIScreen.main.bounds.width
        header.frame.size = size
        tableView.tableHeaderView = header
    }
    
}


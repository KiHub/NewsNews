//
//  MainViewController.swift
//  NewsNews
//
//  Created by  Mr.Ki on 01.05.2022.
//

import UIKit
import SafariServices

class MainViewController: UIViewController {
    
    lazy var newsPresenter = NewsPresenter(newsService: NewsService(), newsView: self)
    
    let cellId = "cell"
    var tableView = UITableView()
    var newsToDisplay = [Post]()
    let refreshControl = UIRefreshControl()
    let converter = ColorConverter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        setup()
        newsPresenter.getNews()
    }
    
    override func loadView() {
        view = tableView
    }
    
    func setup() {
        setupRefreshControl()
        tableView.backgroundColor = converter.hexStringToUIColor(hex: "#212529")
        tableView.separatorStyle = .none
        
    }
    
}


extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: cellId)
        cell.selectionStyle = .none
        cell.backgroundColor = converter.hexStringToUIColor(hex: "#212529")
        cell.textLabel?.textColor = converter.hexStringToUIColor(hex: "#95d5b2")
        cell.detailTextLabel?.textColor = converter.hexStringToUIColor(hex: "#c77dff")
        let newsViewData = newsToDisplay[indexPath.row]
        cell.textLabel?.text = newsViewData.title
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.text = String(newsViewData.points)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsToDisplay.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let news = newsToDisplay[indexPath.row]
        guard let url = URL(string: news.url ?? "https://hn.algolia.com") else {return}
        let configuration = SFSafariViewController.Configuration()
        let safariViewController = SFSafariViewController(url: url, configuration: configuration)
        safariViewController.modalPresentationStyle = .fullScreen
        present(safariViewController, animated: true)
        
    }
    
}

extension MainViewController: NewsView {
    func setNews(news: [Post]) {
        DispatchQueue.main.async {
            self.newsToDisplay = news
            self.tableView.reloadData()
        }
    }
    
    func setEmptyNews() {
        view.backgroundColor = .systemRed
    }
    
    
}

extension MainViewController {
    
    private func setupRefreshControl() {
        //  refreshControl.tintColor = appColor
        refreshControl.addTarget(self, action: #selector(refreshContent), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    @objc func refreshContent() {
        tableView.reloadData()
        print("refresh")
        let dispatchTime = DispatchTime.now() + Double(0.5)
        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
            self.tableView.refreshControl?.endRefreshing()
        })
    }
}

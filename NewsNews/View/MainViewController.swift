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
        
       
        setup()
        newsPresenter.getNews()
    }
    
//    override func loadView() {
//        view = tableView
//    }
    
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
        
//        tableView.backgroundColor = appColor
//        tableView.delegate = self
//        tableView.dataSource = self
        
//        tableView.register(AccountSummaryCell.self, forCellReuseIdentifier: AccountSummaryCell.reuseID)
//        tableView.register(SkeletonCell.self, forCellReuseIdentifier: SkeletonCell.reuseID)
//        tableView.rowHeight = AccountSummaryCell.rowHeight
        tableView.tableFooterView = UIView()
        
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
        cell.detailTextLabel?.text = "◉\(String(newsViewData.points))"
        
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let item = UIContextualAction(style: .normal, title: "Add to list") {  (contextualAction, view, boolValue) in
               print("Paperclip tapped")
            self.addNewsToList(indexPath: indexPath)
            
            }
            item.image = UIImage(systemName: "paperclip")
            item.backgroundColor = converter.hexStringToUIColor(hex: "#95d5b2")
        

            let swipeActions = UISwipeActionsConfiguration(actions: [item])
        
            return swipeActions
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
        refreshControl.tintColor = converter.hexStringToUIColor(hex: "#c77dff")
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

extension MainViewController {
    
    private func addNewsToList(indexPath: IndexPath) {
        
        CoreDataManager.shared.downloadNewsToDataBase(model: newsToDisplay[indexPath.row]) { result in
            switch result {
            case .success():
                print("Downloaded to DB")
                NotificationCenter.default.post(name: NSNotification.Name("loaded"), object: nil)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
//        DataPersistentManager.shared.downloadMovieToDataBase(model: movies[indexPath.row]) { result in
//            switch result {
//            case .success():
//                print("Downloaded to DB")
//                NotificationCenter.default.post(name: NSNotification.Name("loaded"), object: nil)
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//     //   print("Downloading \(movies[indexPath.row].title)")
    }
    
}

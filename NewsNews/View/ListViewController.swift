//
//  ListViewController.swift
//  NewsNews
//
//  Created by  Mr.Ki on 02.05.2022.
//

import UIKit
import SafariServices

class ListViewController: UIViewController {
    
 //   lazy var newsPresenter = NewsPresenter(newsService: NewsService(), newsView: self)
    
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
      //  newsPresenter.getNews()
    }
    
//    override func loadView() {
//        view = tableView
//    }
    
    func setup() {
        downloadNewsFromList()
        setupTableView()
        setupRefreshControl()
        
        
        
    }
    
    private func downloadNewsFromList() {
        CoreDataManager.shared.fetchNewsFromDataBase { [weak self] result in
            switch result {
            case .success(let news):
                self?.savedNewsToDisplay = news
                self?.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
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


extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: cellId)
        cell.selectionStyle = .none
        cell.backgroundColor = converter.hexStringToUIColor(hex: "#212529")
        cell.textLabel?.textColor = converter.hexStringToUIColor(hex: "#95d5b2")
        cell.detailTextLabel?.textColor = converter.hexStringToUIColor(hex: "#c77dff")
        let newsViewData = savedNewsToDisplay[indexPath.row]
        cell.textLabel?.text = newsViewData.title
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.text = "◉\(String(newsViewData.points))"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedNewsToDisplay.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let news = savedNewsToDisplay[indexPath.row]
        guard let url = URL(string: news.url ?? "https://hn.algolia.com") else {return}
        let configuration = SFSafariViewController.Configuration()
        let safariViewController = SFSafariViewController(url: url, configuration: configuration)
        safariViewController.modalPresentationStyle = .fullScreen
        present(safariViewController, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let item = UIContextualAction(style: .normal, title: "Delete") {  (contextualAction, view, boolValue) in
               print("delete")
            
            CoreDataManager.shared.deleteNewsFromDataBase(model: self.savedNewsToDisplay[indexPath.row]) { [weak self] result in
                switch result {
                case .success():
                    print("Deleted from database")
                case .failure(let error):
                    print(error.localizedDescription)
                }
                self?.savedNewsToDisplay.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            }
            item.image = UIImage(systemName: "trash")
            item.backgroundColor = converter.hexStringToUIColor(hex: "#95d5b2")
        

            let swipeActions = UISwipeActionsConfiguration(actions: [item])
        
            return swipeActions
        }
    
}

extension ListViewController: SavedNewsView {
    func setNews(news: [PostList]) {
        DispatchQueue.main.async {
            self.savedNewsToDisplay = news
            self.tableView.reloadData()
        }
    }
    
    func setEmptyNews() {
        view.backgroundColor = .systemRed
    }
    
    
}

extension ListViewController {
    
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


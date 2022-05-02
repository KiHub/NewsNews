//
//  MainVCExtensions.swift
//  NewsNews
//
//  Created by  Mr.Ki on 02.05.2022.
//

import UIKit
import SafariServices

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: cellId)
        cell.selectionStyle = .none
        cell.backgroundColor = appBackGroundColor
        cell.textLabel?.textColor = appMainColor
        cell.detailTextLabel?.textColor = appSecondColor
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
            self.animation.shake(view: view)

            }
            item.image = UIImage(systemName: "paperclip")
            item.backgroundColor = appSecondColor

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
    
     func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshContent), for: .valueChanged)
        refreshControl.tintColor = appSecondColor
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
    
    func addNewsToList(indexPath: IndexPath) {
        
        CoreDataManager.shared.downloadNewsToDataBase(model: newsToDisplay[indexPath.row]) { result in
            switch result {
            case .success():
                print("Downloaded to DB")
                NotificationCenter.default.post(name: NSNotification.Name("loaded"), object: nil)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

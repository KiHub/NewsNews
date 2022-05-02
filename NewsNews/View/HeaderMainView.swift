//
//  HeaderMainView.swift
//  NewsNews
//
//  Created by  Mr.Ki on 02.05.2022.
//

import UIKit

class HeaderMainView: UIView {
    
//    let newsService = NewsService()
//    lazy var newsPresenter = NewsPresenter(newsService: NewsService(), newsView: MainViewController())
//    let mainVC = MainViewController()
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var logo: UIImageView!
    
    override init(frame: CGRect) {
            super.init(frame: frame)
            commonInit()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            commonInit()
        }
        
        override var intrinsicContentSize: CGSize {
            return CGSize(width: UIView.noIntrinsicMetric, height: 150)
        }
        
        private func commonInit() {
            let bundle = Bundle(for: HeaderMainView.self)
            bundle.loadNibNamed("HeaderMainView", owner: self, options: nil)
            addSubview(contentView)
            contentView.backgroundColor = appMainColor
            contentView.translatesAutoresizingMaskIntoConstraints = false
            
            let contentViewConstraints = [
            contentView.topAnchor.constraint(equalTo: self.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ]
            NSLayoutConstraint.activate(contentViewConstraints)
        }
    
    
    @IBAction func segmentedControlAction(_ sender: UISegmentedControl) {
        
//        switch segmentedControl.selectedSegmentIndex {
//        case 0:
//            newsService.link = "https://hn.algolia.com/api/v1/search?tags=front_page"
//            print("1")
//            newsPresenter.getNews()
//            mainVC.newsPresenter.getNews()
//            mainVC.tableView.reloadData()
//        case 1:
//            newsService.link = "https://hn.algolia.com/api/v1/search_by_date?tags=story"
//            print("2")
//            newsPresenter.getNews()
//            mainVC.newsPresenter.getNews()
//            mainVC.tableView.reloadData()
//        case 2:
//            newsService.link = "https://hn.algolia.com/api/v1/search_by_date?tags=comment&numericFilters=created_at_i%3E100"
//            newsPresenter.getNews()
//            mainVC.newsPresenter.getNews()
//            mainVC.tableView.reloadData()
//            print("3")
//        default:
//            newsService.link = "https://hn.algolia.com/api/v1/search?tags=front_page"
//            print("default case")
//        }
      //  NotificationCenter.default.post(name: NSNotification.Name("updated"), object: nil)
    }
    
    }



   

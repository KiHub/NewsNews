//
//  Presenter.swift
//  NewsNews
//
//  Created by  Mr.Ki on 01.05.2022.
//

import Foundation


// A UIKit agnostic protocol to talk to the View.
protocol NewsView: AnyObject {
    func setNews(news: [Post])
    func setEmptyNews()
}
protocol NewsPresenterProtocol: AnyObject {
    init(newsService: NewsServiceProtocol, newsView: NewsView)
    func getNews(url: String)
}

class NewsPresenter: NewsPresenterProtocol {
   
    
    private let newsService: NewsServiceProtocol
    weak var newsView: NewsView?

    required init(newsService: NewsServiceProtocol, newsView: NewsView) {
        self.newsService = newsService
        self.newsView = newsView
    }
    
    func getNews(url: String) {
        
        newsService.getNews(url: url) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let news):
                    self?.newsView?.setNews(news: news)
                case .failure(let error):
                    self?.newsView?.setEmptyNews()
                    print(error.localizedDescription)
                }
            }
        }
    }
}

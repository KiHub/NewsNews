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

protocol SavedNewsView: AnyObject {
    func setNews(news: [PostList])
    func setEmptyNews()
}

class NewsPresenter {

    private let newsService: NewsService
    weak var newsView: NewsView?

    init(newsService: NewsService, newsView: NewsView) {
        self.newsService = newsService
        self.newsView = newsView
    }

    func getNews(){
        
        newsService.getNews { result in
            switch result {
            case .success(let news):
                self.newsView?.setNews(news: news)
            case .failure(let error):
                self.newsView?.setEmptyNews()
                print(error.localizedDescription)
            }
        }

    }
}

//
//  ModuleBuilder.swift
//  NewsNews
//
//  Created by  Mr.Ki on 24.05.2022.
//

import UIKit

protocol Builder {
    static func createMainModule() -> UIViewController
    static func createSecondModule() -> UIViewController
}

class ModuleBuilder: Builder {
    static func createMainModule() -> UIViewController {
        let newsService = NewsService()
        let mainView = MainViewController()
        let newsPresenter = NewsPresenter(newsService: newsService, newsView: mainView)
        mainView.newsPresenter = newsPresenter
        return mainView
    }
    
    static func createSecondModule() -> UIViewController {
 
        let listView = ListViewController()
        let listPresenter = ListPresenter(savedNewsView: listView)
        listView.savedNewsPresenter = listPresenter

        return listView
    }
    
}

//
//  PresenterList.swift
//  NewsNews
//
//  Created by  Mr.Ki on 24.05.2022.
//

import Foundation
import CoreData

protocol SavedNewsView: AnyObject {
    func setNews(news: [PostList])
    func setEmptyNews()
}

protocol ListPresenterProtocol: AnyObject {
    init(savedNewsView: SavedNewsView)
    func downloadNewsFromList()
}

class ListPresenter: ListPresenterProtocol {
    
    weak var savedNewsView: SavedNewsView?
    required init(savedNewsView: SavedNewsView) {
        
        self.savedNewsView = savedNewsView
    }
    
    func downloadNewsFromList() {
        CoreDataManager.shared.fetchNewsFromDataBase { [weak self] result in
            switch result {
            case .success(let news):
                self?.savedNewsView?.setNews(news: news)
            case .failure(let error):
                self?.savedNewsView?.setEmptyNews()
                print(error.localizedDescription)
            }
        }
    }
}

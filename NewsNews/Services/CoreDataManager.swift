//
//  CoreDataManager.swift
//  NewsNews
//
//  Created by  Mr.Ki on 02.05.2022.
//

import UIKit
import CoreData

class CoreDataManager {
    
    enum CoreDataErrors: Error {
        case failedToSave
        case failedToFetchData
        case failedToDelete
    }
    
    static let shared = CoreDataManager()
    
    func downloadNewsToDataBase(model: Post, completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        
        let item = PostList(context: context)
        
        item.object = model.objectID
        item.title = model.title
        item.points = Int64(model.points)
        item.url = model.url

        
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
                completion(.failure(CoreDataErrors.failedToSave))
            print(error.localizedDescription)
        }
    }
    
    func fetchNewsFromDataBase(completion : @escaping (Result<[PostList], Error>) -> Void) {
   
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
            let context = appDelegate.persistentContainer.viewContext
        
            let request: NSFetchRequest<PostList>
            request = PostList.fetchRequest()
           
        
        do {
           let news = try context.fetch(request)
            completion(.success(news))
        } catch {
            completion(.failure(CoreDataErrors.failedToFetchData))
        }
        
    }
    
    func deleteNewsFromDataBase(model: PostList, completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        context.delete(model)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(CoreDataErrors.failedToDelete))
        }
        
    }
    
}

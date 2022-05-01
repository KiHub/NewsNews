//
//  NetworkManager.swift
//  NewsNews
//
//  Created by  Mr.Ki on 01.05.2022.
//

import Foundation

enum NetworkError: Error {
    case serverError
    case decodingError
}

class NewsService {
    
    func getNews(completion: @escaping (Result<[Post],NetworkError>) -> Void) {
        guard let url = URL(string: "https://hn.algolia.com/api/v1/search?tags=front_page") else {return}
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(.serverError))
                return
            }
            do {
                let results = try JSONDecoder().decode(Results.self, from: data)
                completion(.success(results.hits))
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
    
    
}

//
//  NetworkManager.swift
//  NewsNews
//
//  Created by  Mr.Ki on 01.05.2022.
//

import Foundation

protocol NewsServiceProtocol {
    func getNews(url: String, completion: @escaping (Result<[Post],NetworkError>) -> Void)
}

enum NetworkError: Error {
    case serverError
    case decodingError
}

class NewsService: NewsServiceProtocol {
    
    func getNews(url: String, completion: @escaping (Result<[Post],NetworkError>) -> Void) {
        guard let url = URL(string: url) else {return}
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

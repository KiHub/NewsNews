//
//  Model.swift
//  NewsNews
//
//  Created by  Mr.Ki on 01.05.2022.
//

import Foundation

struct Results: Decodable {
    let hits: [Post]
}

struct Post: Decodable {
//    var id: String {
//        return objectID
//    }
    let objectID: String
    let points: Int
    let title: String
    let url: String?
}

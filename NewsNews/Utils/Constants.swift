//
//  Constants.swift
//  NewsNews
//
//  Created by  Mr.Ki on 02.05.2022.
//

import Foundation

let converter = ColorConverter()

let appBackGroundColor = converter.hexStringToUIColor(hex: "#212529")
let appMainColor = converter.hexStringToUIColor(hex: "#95d5b2")
let appSecondColor = converter.hexStringToUIColor(hex: "#c77dff")

var url = "https://hn.algolia.com/api/v1/search?tags=front_page"

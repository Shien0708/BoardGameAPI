//
//  GameLists.swift
//  BoardGameAPI
//
//  Created by Shien on 2022/6/2.
//

import Foundation


struct GameLists: Codable {
    var lists: [List]
}

struct List: Codable {
    var name: String
    var gameCount: Int
    var imageUrl: URL
    var url: String
    var images: Images
}

struct Images: Codable {
    var small: URL
    var medium: URL
    var large: URL
}

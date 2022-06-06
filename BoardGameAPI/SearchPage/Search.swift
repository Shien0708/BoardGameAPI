//
//  Search.swift
//  BoardGameAPI
//
//  Created by Shien on 2022/6/3.
//

import Foundation

struct Search: Codable {
    var games: [Game]
}

struct Game: Codable {
    var name: String
    var image_url: URL
    var price: String
    var price_ca: String
    var price_uk: String
    var price_au: String
    var discount: String
    var year_published: Int
    var min_players: Int
    var max_players: Int
    var min_playtime: Int
    var max_playtime: Int
    var min_age: Int
    var description: String
    var primary_designer: PrimaryDesigner?
    var official_url: URL?
}

struct PrimaryDesigner: Codable {
    var name: String?
    var url: URL?
}

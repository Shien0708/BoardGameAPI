//
//  Videos.swift
//  BoardGameAPI
//
//  Created by Shien on 2022/6/2.
//

import Foundation

struct VideoList: Codable {
    var videos: [Video]
}

struct Video: Codable {
    var url: URL
    var title: String
    var channel_name: String
    var image_url: URL
}

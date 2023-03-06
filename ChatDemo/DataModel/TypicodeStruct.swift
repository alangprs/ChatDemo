//
//  TypicodeStruct.swift
//  ChatDemo
//
//  Created by cm0768 on 2023/2/22.
//

import Foundation

struct TypicodeStruct: Codable {
    let albumID: Int
    let id: Int
    let title: String
    let thumbnailURL: String

    enum CodingKeys: String, CodingKey {
        case albumID = "albumId"
        case id, title
        case thumbnailURL = "thumbnailUrl"
    }
}

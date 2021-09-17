//
//  AllCategoriesResponse.swift
//  Spotify
//
//  Created by Amr Hossam on 17/09/2021.
//

import Foundation


struct AllCategoriesResponse: Codable {
    let categories: Catagories
}

struct Catagories: Codable {
    let items: [Category]
}

struct Category: Codable {
    let id: String
    let name: String
    let icons: [APIImage]
}

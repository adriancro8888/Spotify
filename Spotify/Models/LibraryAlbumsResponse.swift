//
//  LibraryAlbumsResponse.swift
//  Spotify
//
//  Created by Amr Hossam on 25/09/2021.
//

import Foundation

struct LibraryAlbumsResponse: Codable {
    let items: [SavedAlbum]
}

struct SavedAlbum: Codable {
    let added_at: String
    let album: Album
}

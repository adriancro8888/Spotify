//
//  SearchResult.swift
//  Spotify
//
//  Created by Amr Hossam on 17/09/2021.
//

import Foundation

enum SearchResult {
    case artist(model: Artist)
    case album(model: Album)
    case track(model: AudioTrack)
    case playlist(model: Playlist)
}

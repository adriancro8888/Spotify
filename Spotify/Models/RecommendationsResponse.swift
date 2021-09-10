//
//  RecommendationsResponse.swift
//  Spotify
//
//  Created by Amr Hossam on 09/09/2021.
//

import Foundation

struct RecommendationsResponse: Codable {
    let tracks: [AudioTrack]
}


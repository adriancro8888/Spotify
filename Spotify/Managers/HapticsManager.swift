//
//  HapticsManager.swift
//  Spotify
//
//  Created by Amr Hossam on 30/08/2021.
//

import Foundation
import UIKit

final class HapticsManager {
    static let shared = HapticsManager()
    
    private init(){}
    
    public func vibrateForSelection() {
        DispatchQueue.main.async {
            let generator = UISelectionFeedbackGenerator()
            generator.prepare()
            generator.selectionChanged()
        }
    }
    
    public func vibrate(for type: UINotificationFeedbackGenerator.FeedbackType) {
        DispatchQueue.main.async {
            let generate = UINotificationFeedbackGenerator()
            generate.prepare()
            generate.notificationOccurred(type)
        }
    }
    
}

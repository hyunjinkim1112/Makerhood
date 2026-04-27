//
//  InspirationalQuoteHelper.swift
//  Makerhood
//
//  Created by Hyunjin Kim on 24/4/26.
//

import SwiftUI

struct InspirationalQuoteHelper {
    /// Array of inspirational quote image names from Assets
    /// Update this array with your actual image names in the inspirational-quotes folder
    static let quoteImages: [String] = [
        "quote1",
        "quote2",
        "quote3",
        "quote4",
        "quote5",
        "quote6"
        // Add more quote image names here as needed
    ]
    
    /// Returns a randomly selected inspirational quote image name
    static func randomQuote() -> String {
        quoteImages.randomElement() ?? "inspirational-quotes/quote1"
    }
}

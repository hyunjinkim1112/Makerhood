//
//  ViewExtensions.swift
//  Makerhood
//
//  Created by Hyunjin Kim on 21/4/26.
//

import SwiftUI
import UIKit

// MARK: - Rounded Corners Extension

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

// MARK: - Time Ago Extension

extension Date {
    func timeAgoDisplay() -> String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.year, .month, .weekOfYear, .day, .hour, .minute, .second], from: self, to: now)
        
        if let year = components.year, year >= 1 {
            return "\(year)y"
        }
        
        if let month = components.month, month >= 1 {
            return "\(month)mo"
        }
        
        if let week = components.weekOfYear, week >= 1 {
            return "\(week)w"
        }
        
        if let day = components.day, day >= 1 {
            return "\(day)d"
        }
        
        if let hour = components.hour, hour >= 1 {
            return "\(hour)h"
        }
        
        if let minute = components.minute, minute >= 1 {
            return "\(minute)m"
        }
        
        return "now"
    }
}

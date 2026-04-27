//
//  Date+TimeAgo.swift
//  Makerhood
//
//  Created by Hyunjin Kim on 21/4/26.
//

import Foundation

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

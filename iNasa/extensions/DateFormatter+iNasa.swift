//
//  DateFormatter+iNasa.swift
//  iNasa
//
//  Created by Jeffrey Cripe on 5/5/20.
//  Copyright © 2020 Jeffrey Cripe. All rights reserved.
//

import Foundation

extension DateFormatter {
    static var iNasaFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.timeStyle = .none
        formatter.dateStyle = .short
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    static func string(from date: Date) -> String {
        // Wow, time formatter wasnt giving me the correct date unless I had the time on the date.
        // However, api needs it in short form without a date so just strip that info. as this is just a quick kata
        return String(self.iNasaFormatter.string(from: date).split(separator: " ").first ?? "")
    }
}

//
//  DateFormatter+iNasa.swift
//  iNasa
//
//  Created by Tacenda on 5/5/20.
//  Copyright © 2020 Tacenda. All rights reserved.
//

import Foundation

extension DateFormatter {
    static var picOfDayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateFormat = "yyyy-mm-dd"
        return formatter
    }()
}

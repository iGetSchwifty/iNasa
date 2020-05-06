//
//  PicOfDayAPIEntity.swift
//  iNasa
//
//  Created by Jeffrey Cripe on 5/5/20.
//  Copyright © 2020 Jeffrey Cripe. All rights reserved.
//

struct PicOfDayAPIEntity: Codable {
    var copyright: String?
    var date: String
    var explanation: String
    var title: String
    var url: String
}

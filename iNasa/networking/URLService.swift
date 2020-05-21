//
//  URLService.swift
//  iNasa
//
//  Created by Tacenda on 5/21/20.
//  Copyright © 2020 Tacenda. All rights reserved.
//

import Foundation

class URLService {
    public static let picOfDay = URL(string: "https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY")!
    public static func nearEarthObjects(forDate strDate: String) -> URL {
        return URL(string: "https://api.nasa.gov/neo/rest/v1/feed?start_date=\(strDate)&end_date=\(strDate)&api_key=DEMO_KEY")!
    }
}

//
//  NEOAPIEntity.swift
//  iNasa
//
//  Created by Tacenda on 5/5/20.
//  Copyright © 2020 Tacenda. All rights reserved.
//

struct NEOAPIEntity: Codable {
    var id: String
    var name: String
    var estimatedDiameter: NeoSize
    var isPotentiallyHazardous: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case estimatedDiameter = "estimated_diameter"
        case isPotentiallyHazardous = "is_potentially_hazardous_asteroid"
    }
}

struct NeoSize: Codable {
    var meters: Estimated_Size
}

struct Estimated_Size: Codable {
    var min: Float
    var max: Float
    
    enum CodingKeys: String, CodingKey {
        case min = "estimated_diameter_min"
        case max = "estimated_diameter_max"
    }
}



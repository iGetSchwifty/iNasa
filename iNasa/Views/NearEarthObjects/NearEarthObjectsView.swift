//
//  NearEarthObjects.swift
//  iNasa
//
//  Created by Jeffrey Cripe on 5/5/20.
//  Copyright © 2020 Jeffrey Cripe. All rights reserved.
//

import SwiftUI

struct NearEarthObjectsView: View {
    var model = NearEarthObjectsViewModel()
    
    @FetchRequest(entity: NEO_Date.entity(),
                  sortDescriptors: [],
                  predicate: NSPredicate(format: "%K = %@",
                                         #keyPath(NEO_Date.time),
                                         DateFormatter.string(from: Date())
                             )
    )
    var nearObjects: FetchedResults<NEO_Date>
    
    var body: some View {
        List(0..<nearObjects.count) { index in
            //print(nearObjects[index])
            Text("\(index)")
        }
    }
}

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
    
    @FetchRequest(entity: NearEarthObject.entity(),
                  sortDescriptors: [],
                  predicate: NSPredicate(format: "eventDate.time = %@",
                                         DateFormatter.string(from: Date())
                             )
    )
    var nearObjects: FetchedResults<NearEarthObject>
    
    var body: some View {
        return VStack {
            Text("Items For: \(DateFormatter.string(from: Date()))")
            if nearObjects.first != nil {
                List(nearObjects, id: \.id) { neo in
                    VStack(alignment: .leading) {
                        Text("Name: \(neo.name ?? "")")
                        
                        if neo.is_potentially_hazardous {
                            HStack {
                                Text("Potentially Hazardous: ")
                                    .font(.system(.body))
                                
                                Text("YES")
                                    .font(.system(.body))
                                    .foregroundColor(.red)
                            }
                            .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 5))
                        } else {
                            HStack {
                                Text("Potentially Hazardous: ")
                                    .font(.system(.body))
                                
                                Text("NO")
                                    .font(.system(.body))
                                    .foregroundColor(.green)
                            }
                            .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 5))
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Estimated Diameter")
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
                            HStack {
                                Text("Min (Meters): \(String(neo.estimated_min_meters))")
                                    .font(.system(.footnote))
                                
                                Text("Max (Meters): \(String(neo.estimated_max_meters))")
                                    .font(.system(.footnote))
                            }
                        }.padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 5))
                    }
                }
            } else {
                Text("Loading...")
            }
        }
    }
}

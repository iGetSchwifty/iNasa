//
//  PicOfDay.swift
//  iOS-Kata
//
//  Created by Tacenda on 5/5/20.
//  Copyright © 2020 Tacenda. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

struct PicOfDayView: View {
    @ObservedObject var model = PicOfDayViewModel()
    
    @FetchRequest(entity: PictureOfTheDay.entity(),
                  sortDescriptors: [NSSortDescriptor(key: #keyPath(PictureOfTheDay.date), ascending: false)])
    var pictureOfTheDay: FetchedResults<PictureOfTheDay>
    
    var body: some View {
        VStack {
            if pictureOfTheDay.first != nil {
                Text(pictureOfTheDay.first?.title ?? "")
                Image(uiImage: model.picImage)
                    .resizable()
                    .cornerRadius(42)
                    .frame(width: 200, height: 200)
                
                //Image(PicOfDayService.imageFrom(url: pictureOfTheDay.first?.url))
                Text(pictureOfTheDay.first?.explanation ?? "")
                
                //Text(pictureOfTheDay.first?.date ?? "")
                
                Text(pictureOfTheDay.first?.copyright ?? "")
            } else {
                Text("Loading...")
            }
            //Text(self.model.pictureOfTheDay.first?.title ?? "Loading...")
        }
    }
}

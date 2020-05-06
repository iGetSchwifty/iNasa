//
//  PicOfDay.swift
//  iOS-Kata
//
//  Created by Jeffrey Cripe on 5/5/20.
//  Copyright © 2020 Jeffrey Cripe. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

//
//  TODO: The way we have it set up is that every pic they see we should be able to capture and show them again
//  we just need to build the UI that displays the core data entities
//

struct PicOfTheDayView: View {
    @ObservedObject var model = PicOfDayViewModel()
    
    @FetchRequest(entity: PictureOfTheDay.entity(),
                  sortDescriptors: [NSSortDescriptor(key: #keyPath(PictureOfTheDay.date), ascending: false)])
    var pictureOfTheDay: FetchedResults<PictureOfTheDay>
    
    var body: some View {
        VStack {
            if pictureOfTheDay.first != nil {
                
                NavigationLink(destination: PicOfTheDayDetailView(image: model.picImage)) {
                    VStack {
                        Image(uiImage: model.picImage)
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: ContentMode.fit)
                            .cornerRadius(42)
                            .padding()
                        
                        Text("Click me!").font(.system(size: 10))
                    }
                }
                
                ScrollView {
                    Text(pictureOfTheDay.first?.title ?? "")
                        .font(.system(size: 24)).padding()
                    
                    Text(self.model.textFrom(date: pictureOfTheDay.first?.date))
                        .font(.system(.caption)).padding()
                    
                    Text(pictureOfTheDay.first?.explanation ?? "")
                        .font(.body).padding()
                    
                    Text(pictureOfTheDay.first?.copyright ?? "")
                        .font(.system(.caption)).padding()
                }
            } else {
                Text("Loading...")
            }
        }
        .navigationBarTitle("Picture of the day", displayMode: .inline)
    }
}

struct PicOfTheDayView_Previews: PreviewProvider {
    static var previews: some View {
        PicOfTheDayView()
    }
}

//
//  ContentView.swift
//  iOS-Kata
//
//  Created by Tacenda on 5/5/20.
//  Copyright © 2020 Tacenda. All rights reserved.
//

import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            
            NavigationView {
                PicOfTheDayView()
            }.tabItem {
                Image(systemName: "photo.fill")
                Text("APOD")
            }.tag(1)
            
            NearEarthObjects()
            .tabItem {
                Image(systemName: "circle")
                Text("Near Earth Objects")
            }.tag(2)
        }
    }
}

struct AppView: View {
    var body: some View {
        TabBarView()
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}

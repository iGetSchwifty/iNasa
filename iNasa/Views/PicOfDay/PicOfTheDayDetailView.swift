//
//  PicOfTheDayDetailView.swift
//  iNasa
//
//  Created by Jeffrey Cripe on 5/5/20.
//  Copyright © 2020 Jeffrey Cripe. All rights reserved.
//

import SwiftUI

struct PicOfTheDayDetailView: View {
    var image: UIImage
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                Rectangle()
                    .frame(width: geometry.size.width, height: geometry.size.height)
            }.foregroundColor(.black)
            
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .navigationBarBackButtonHidden(false)
        }
    }
}

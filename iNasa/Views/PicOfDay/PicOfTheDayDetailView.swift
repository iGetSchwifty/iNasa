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
        Image(uiImage: image)
            .resizable()
            .scaledToFit()
            .navigationBarBackButtonHidden(false)
    }
}

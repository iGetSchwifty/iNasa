//
//  PicOfDayViewModel.swift
//  iOS-Kata
//
//  Created by Tacenda on 5/5/20.
//  Copyright © 2020 Tacenda. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class PicOfDayViewModel: ObservableObject {
    var disposeBag = Set<AnyCancellable>()
    
    @Published var picImage = UIImage()
    
    init() {
        fetch()
    }
    
    func fetch() {
        PicOfDayService.fetch()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] url in
                guard let self = self else { return }
                guard url.isEmpty == false else { return }
                
                self.imageFrom(url: url)
            }.store(in: &self.disposeBag)
    }
    
    func textFrom(date: Date?) -> String {
        if let date = date {
            return DateFormatter.picOfDayFormatter.string(from: date)
        }
        return ""
    }
    
    private func imageFrom(url: String?) {
        PicOfDayService.imageFrom(url: url)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                guard let self = self else { return }
                self.picImage = image
            }.store(in: &disposeBag)
    }
}

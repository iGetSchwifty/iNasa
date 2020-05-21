//
//  PicOfDayViewModel.swift
//  iNasa
//
//  Created by Jeffrey Cripe on 5/5/20.
//  Copyright © 2020 Jeffrey Cripe. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class PicOfDayViewModel: ObservableObject {
    var disposeBag = Set<AnyCancellable>()
    
    @Published var picImage = UIImage()
    
    private var provider: NetworkingProtocol
    
    init(provider: NetworkingProtocol = NetworkingPublisher()) {
        self.provider = provider
        fetch()
    }
    
    func fetch() {
        PicOfDayService.fetch(provider: provider)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] url in
                guard let self = self else { return }
                guard url.isEmpty == false else { return }
                
                self.imageFrom(url: url)
            }.store(in: &self.disposeBag)
    }
    
    func textFrom(date: Date?) -> String {
        if let date = date {
            return DateFormatter.string(from: date)
        }
        return ""
    }
    
    private func imageFrom(url: String?) {
        PicOfDayService.imageFrom(url: url, provider: provider)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                guard let self = self else { return }
                self.picImage = image
            }.store(in: &disposeBag)
    }
}

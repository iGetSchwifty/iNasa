//
//  NearEarthObjectsViewModel.swift
//  iNasa
//
//  Created by Jeffrey Cripe on 5/5/20.
//  Copyright © 2020 Jeffrey Cripe. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class NearEarthObjectsViewModel {
    var disposeBag = Set<AnyCancellable>()
    private var provider: NetworkingProtocol
    
    init(provider: NetworkingProtocol = NetworkingPublisher()) {
        self.provider = provider
        fetch()
    }
    
    func fetch() {
        NearEarthObjectsService.fetch(date: Date(), provider: provider)
            .receive(on: DispatchQueue.main)
            .sink { _ in }.store(in: &self.disposeBag)
    }
}

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
    
    init() {
        fetch()
    }
    
    func fetch() {
        NearEarthObjectsService.fetch(date: Date())
            .receive(on: DispatchQueue.main)
            .sink { _ in }.store(in: &self.disposeBag)
    }
}

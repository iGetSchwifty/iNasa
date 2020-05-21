//
//  networkingProtocol.swift
//  iOSKata
//
//  Created by Jeff on 5/13/20.
//  Copyright © 2020 Jeffrey. All rights reserved.
//
import Combine
import Foundation

class NetworkingPublisher: NetworkingProtocol {
    func dataTaskPublisher(for request: URL) -> AnyPublisher<Data, URLSession.DataTaskPublisher.Failure> {
        return session.dataTaskPublisher(for: request)
            .map { $0.data }
            .eraseToAnyPublisher()
    }

    var session: URLSession

    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
}

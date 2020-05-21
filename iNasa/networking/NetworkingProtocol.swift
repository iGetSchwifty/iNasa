//
//  NetworkingProtocol.swift
//  iOSKata
//
//  Created by Jeff on 5/13/20.
//  Copyright © 2020 Jeffrey. All rights reserved.
//
import Combine
import Foundation

protocol NetworkingProtocol {
    func dataTaskPublisher(for request: URL) -> AnyPublisher<Data, URLSession.DataTaskPublisher.Failure>
}

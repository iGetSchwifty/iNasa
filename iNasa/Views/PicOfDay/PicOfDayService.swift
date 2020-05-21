//
//  PicOfDayService.swift
//  iNasa
//
//  Created by Jeffrey Cripe on 5/5/20.
//  Copyright © 2020 Jeffrey Cripe. All rights reserved.
//

import Combine
import CoreData
import Foundation
import UIKit

class PicOfDayService {
    static var isFetching = false
    static func fetch(provider: NetworkingProtocol) -> AnyPublisher<String, Never> {
        let url = checkForCache(date: Date())
        guard url == nil else {
            return Just(url ?? "").eraseToAnyPublisher()
        }
        
        guard isFetching == false else { return Just(url ?? "").eraseToAnyPublisher() }
        
        isFetching = true
        
        return provider
            .dataTaskPublisher(for: URLService.picOfDay)
            .map({ data -> String in
                do {
                    let picOfDay = try JSONDecoder().decode(PicOfDayAPIEntity.self, from: data)
                    saveObject(picOfDay: picOfDay)
                    return picOfDay.url
                } catch let error {
                    // TODO: If this was a real project we would do something meaningful with this error
                    // for now we just print
                    print(error)
                }
                return ""
            })
            .handleEvents(receiveCompletion: { _ in
                isFetching = false
            }, receiveCancel: {
                isFetching = false
            })
            .replaceError(with: "")
            .eraseToAnyPublisher()
    }
    
    static func imageFrom(url: String?, provider: NetworkingProtocol) -> AnyPublisher<UIImage, Never> {
        guard let url = url, let realURL = URL(string: url) else { return Just(UIImage()).eraseToAnyPublisher() }
        
        return provider.dataTaskPublisher(for: realURL)
            .map { UIImage(data: $0)}
            .replaceError(with: nil)
            .replaceNil(with: UIImage())
            .eraseToAnyPublisher()
    }
    
    private static func saveObject(picOfDay: PicOfDayAPIEntity) {
        let context = PersistentContainer.newBackgroundContext()
        
        context.performAndWait {
            let newPic = PictureOfTheDay(context: context)
            newPic.copyright = picOfDay.copyright
            newPic.date = DateFormatter.iNasaFormatter.date(from: picOfDay.date) ?? Date()
            newPic.explanation = picOfDay.explanation
            newPic.title = picOfDay.title
            newPic.url = picOfDay.url
            do {
                try context.save()
            } catch let error {
                // TODO: If this was a real project we would do something meaningful with this error
                // for now we just print
                print(error)
            }
        }
    }
    
    private static func checkForCache(date: Date?) -> String? {
        guard let date = date else { return nil }
        
        let context = PersistentContainer.newBackgroundContext()
        var returnVal: String?
        context.performAndWait {
            let fetchReq: NSFetchRequest<PictureOfTheDay> = PictureOfTheDay.fetchRequest()
            fetchReq.sortDescriptors = [NSSortDescriptor(key: #keyPath(PictureOfTheDay.date), ascending: false)]
            
            do {
                let foundObjects = try context.fetch(fetchReq)
                if DateFormatter.string(from: foundObjects.first?.date ?? Date()) == DateFormatter.string(from: date) {
                    returnVal = foundObjects.first?.url
                }
            } catch let error {
                // TODO: If this was a real project we would do something meaningful with this error
                // for now we just print
                print(error)
            }
        }
        return returnVal
    }
}

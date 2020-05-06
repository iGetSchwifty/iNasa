//
//  PicOfDayService.swift
//  iOS-Kata
//
//  Created by Tacenda on 5/5/20.
//  Copyright © 2020 Tacenda. All rights reserved.
//

import Combine
import CoreData
import Foundation
import UIKit

class PicOfDayService {
    static var isFetching = false
    static func fetch() -> AnyPublisher<String, Never> {
        let url = checkForCache(date: Date())
        guard url == nil else {
            return Just(url ?? "").eraseToAnyPublisher()
        }
        
        guard isFetching == false else { return Just(url ?? "").eraseToAnyPublisher() }
        
        isFetching = true
        
        let request = URLRequest(url: URL(string: "https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY")!)
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .map({ (data, response) -> String in
                if let picOfDay = try? JSONDecoder().decode(PicOfDayAPIEntity.self, from: data) {
                    let cachedURL = checkForCache(date: DateFormatter.picOfDayFormatter.date(from: picOfDay.date))
                    guard cachedURL == nil else { return cachedURL ?? "" }
                    
                    let context = PersistentContainer.persistentContainer.newBackgroundContext()
   
                    context.performAndWait {
                        let newPic = PictureOfTheDay(context: context)
                        newPic.copyright = picOfDay.copyright
                        newPic.date = DateFormatter.picOfDayFormatter.date(from: picOfDay.date) ?? Date()
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
                    return picOfDay.url
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
    
    static func imageFrom(url: String?) -> AnyPublisher<UIImage, Never> {
        guard let url = url, let realURL = URL(string: url) else { return Just(UIImage()).eraseToAnyPublisher() }
        
        return URLSession.shared.dataTaskPublisher(for: realURL)
            .map { UIImage(data: $0.data)}
            .replaceError(with: nil)
            .replaceNil(with: UIImage())
            .eraseToAnyPublisher()
    }
    
    private static func checkForCache(date: Date?) -> String? {
        guard let date = date else { return nil }
        
        let context = PersistentContainer.persistentContainer.newBackgroundContext()
        var returnVal: String?
        context.performAndWait {
            let fetchReq: NSFetchRequest<PictureOfTheDay> = PictureOfTheDay.fetchRequest()
            fetchReq.sortDescriptors = [NSSortDescriptor(key: #keyPath(PictureOfTheDay.date), ascending: false)]
            
            do {
                let foundObjects = try context.fetch(fetchReq)
                for object in foundObjects {
                    if let oldDate = object.date, oldDate <= date {
                        returnVal = object.url
                        break
                    }
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

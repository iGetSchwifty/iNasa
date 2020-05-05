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
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateFormat = "yyyy-mm-dd"
        guard checkForCache(date: Date()) == false else {
            return Just("").eraseToAnyPublisher() // TODO:
        }
        
        guard isFetching == false else { return Just("").eraseToAnyPublisher() } // TODO:
        
        isFetching = true
        
        let request = URLRequest(url: URL(string: "https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY")!)
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .map({ (data, response) -> String in
                if let picOfDay = try? JSONDecoder().decode(PicOfDayAPIEntity.self, from: data) {
                    
                    guard checkForCache(date: formatter.date(from: picOfDay.date)) == false else { return "" }
                    
                    let context = PersistentContainer.persistentContainer.viewContext
   
                    context.performAndWait {
                        let newPic = PictureOfTheDay(context: context)
                        newPic.copyright = picOfDay.copyright
                        newPic.date = formatter.date(from: picOfDay.date) ?? Date()
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
    
    private static func checkForCache(date: Date?) -> Bool {
        guard let date = date else { return false }
        
        let context = PersistentContainer.persistentContainer.viewContext
        var returnVal = false
        context.performAndWait {
            let fetchReq: NSFetchRequest<PictureOfTheDay> = PictureOfTheDay.fetchRequest()
            fetchReq.sortDescriptors = [NSSortDescriptor(key: #keyPath(PictureOfTheDay.date), ascending: false)]
            
            do {
                let foundObjects = try context.fetch(fetchReq)
                for object in foundObjects {
                    if let oldDate = object.date, oldDate <= date {
                        returnVal = true
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

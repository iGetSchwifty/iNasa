//
//  NearEarthObjectsService.swift
//  iNasa
//
//  Created by Jeffrey Cripe on 5/5/20.
//  Copyright © 2020 Jeffrey Cripe. All rights reserved.
//

import Combine
import CoreData
import Foundation
import UIKit

class NearEarthObjectsService {
    static var isFetching = false
    static func fetch(date: Date?, provider: NetworkingProtocol) -> AnyPublisher<Bool, Never> {
        let date = date ?? Date()
        guard checkForCache(date: date) == false else { return Just(true).eraseToAnyPublisher() }

        guard isFetching == false else { return Just(true).eraseToAnyPublisher() }
        
        isFetching = true
        let strDate = DateFormatter.string(from: date)
        return provider
            .dataTaskPublisher(for: URLService.nearEarthObjects(forDate: strDate))
            .map({ data -> [NEOAPIEntity] in
                var returnObjects = [NEOAPIEntity]()
                // Need to parse as dict due to the fact that the api returns the date as a key value.
                let neoData = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
                if let nearEarthObjects = neoData?["near_earth_objects"] as? [String : AnyObject] {
                    for (_, objs) in nearEarthObjects {
                        if let objData = try? JSONSerialization.data(withJSONObject: objs, options: .fragmentsAllowed) {
                            if let neoObjects = try? JSONDecoder().decode([NEOAPIEntity].self, from: objData) {
                                returnObjects.append(contentsOf: neoObjects)
                            }
                        }
                    }
                }
                return returnObjects
            })
            .map({ entities -> Bool in
                var returnVal = false
                if entities.count > 0 {
                    returnVal = true
                    save(strDate: strDate, entities: entities)
                }
                return returnVal
            })
            .handleEvents(receiveCompletion: { _ in
                isFetching = false
            }, receiveCancel: {
                isFetching = false
            })
            .replaceError(with: false)
            .eraseToAnyPublisher()
    }
    
    private static func save(strDate: String, entities: [NEOAPIEntity]) {
        let context = PersistentContainer.newBackgroundContext()
        context.performAndWait {
            let neoDate = NEO_Date(context: context)
            neoDate.time = strDate
            entities.forEach { entity in
                let nearEarthObject = NearEarthObject(context: context)
                nearEarthObject.eventDate = neoDate
                nearEarthObject.name = entity.name
                nearEarthObject.estimated_max_meters = entity.estimatedDiameter.meters.max
                nearEarthObject.estimated_min_meters = entity.estimatedDiameter.meters.min
                nearEarthObject.id = entity.id
                nearEarthObject.is_potentially_hazardous = entity.isPotentiallyHazardous
                neoDate.addToNeoObjects(nearEarthObject)
            }
            do {
                try context.save()
            } catch let error {
                // TODO: If this was a real project we would do something meaningful with this error
                // for now we just print
                print(error)
            }
        }
    }
    
    private static func checkForCache(date: Date?) -> Bool {
        guard let date = date else { return false }
        
        let context = PersistentContainer.newBackgroundContext()
        var returnVal = false
        context.performAndWait {
            let fetchReq: NSFetchRequest<NEO_Date> = NEO_Date.fetchRequest()
            fetchReq.predicate = NSPredicate(format: "%K = %@", #keyPath(NEO_Date.time), DateFormatter.string(from: date))

            do {
                let foundObjects = try context.fetch(fetchReq)
                guard foundObjects.count != 0 else { return }
                returnVal = true
            } catch let error {
                // TODO: If this was a real project we would do something meaningful with this error
                // for now we just print
                print(error)
            }
        }
        return returnVal
    }
}

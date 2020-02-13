//
//  CreateTestData.swift
//  Safe Sailor
//
//  Created by Dimopoulos Stavros tou Athanasiou on 12/2/20.
//  Copyright © 2020 Dimopoulos Stavros tou Athanasiou. All rights reserved.
//

import Foundation
import CoreData
class CreateCoreData {
    func CreateTestData (dataController:DataController){
        
           let testString = """
                 [{"MMSI":"304010417","IMO":"9015462","SHIP_ID":"359396","LAT":"47.758499","LON":"-5.154223","SPEED":"74","HEADING":"329","COURSE":"327","STATUS":"0","TIMESTAMP":"2017-05-19T09:39:57","DSRC":"TER","UTC_SECONDS":"54"},{"MMSI":"215819000","IMO":"9034731","SHIP_ID":"150559","LAT":"47.926899","LON":"-5.531450","SPEED":"122","HEADING":"162","COURSE":"157","STATUS":"0","TIMESTAMP":"2017-05-19T09:44:27","DSRC":"TER","UTC_SECONDS":"28"},{"MMSI":"255925000","IMO":"9184433","SHIP_ID":"300518","LAT":"47.942631","LON":"-5.116510","SPEED":"79","HEADING":"316","COURSE":"311","STATUS":"0","TIMESTAMP":"2017-05-19T09:43:53","DSRC":"TER","UTC_SECONDS":"52"}]
                 """.data(using: .utf8)

                // Cleare existing ships in the database
                 let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Ship")
                           fetch.predicate = NSPredicate(value: true)
                           let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetch)
                           let _ = try? dataController.viewContext.execute(deleteRequest)
        
                 // Add test ships in the database
                    do {
                     let ships = try JSONDecoder().decode([ShipStruct].self, from: testString!)
                            
                     for ship in ships{
                                  let newShip = Ship(context: dataController.viewContext)
                                  newShip.course = ship.course
                                  newShip.dsrc = ship.dsrc
                                  newShip.heading = ship.heading
                                  newShip.imo = ship.imo
                                  newShip.latitude = ship.latitude
                                  newShip.longitude = ship.longitude
                                  newShip.mmsi = ship.mmsi
                                  newShip.shipId = ship.shipId
                                  newShip.speed = ship.speed
                                  newShip.status = ship.status
                                  newShip.timeStamp = ship.timeStamp
                                  newShip.utcSeconds = ship.utcSeconds
                                  try? dataController.viewContext.save()
                              }

                     } catch DecodingError.dataCorrupted(let context) {
                         print(context)
                     } catch DecodingError.keyNotFound(let key, let context) {
                         print("Key '\(key)' not found:", context.debugDescription)
                         print("codingPath:", context.codingPath)
                     } catch DecodingError.valueNotFound(let value, let context) {
                         print("Value '\(value)' not found:", context.debugDescription)
                         print("codingPath:", context.codingPath)
                     } catch DecodingError.typeMismatch(let type, let context)  {
                         print("Type '\(type)' mismatch:", context.debugDescription)
                         print("codingPath:", context.codingPath)
                     } catch {
                         print("error: ", error)
                     }
       }
}

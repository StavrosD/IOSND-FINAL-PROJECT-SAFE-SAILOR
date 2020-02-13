//
//  NetworkClient.swift
//  Safe Sailor
//
//  Created by Dimopoulos Stavros tou Athanasiou on 12/2/20.
//  Copyright © 2020 Dimopoulos Stavros tou Athanasiou. All rights reserved.
//

import Foundation
import CoreData
import Alamofire

class NetworkClient {
    static var apiKey: String = ""
    
    class func GetShipsInArea(minLatitude: Double, maxLatitude: Double, minLongitude: Double, maxLongitude: Double, timespan:Int? = 0, dataController:DataController, completion: @escaping (Bool, String?)->Void) {
        apiKey = UserDefaults.standard.string(forKey: "apiKey")!
        let baseURL = "https://services.marinetraffic.com/api/exportvessels/v:8/\(apiKey)/MINLAT:\(String(format: "%.4f", minLatitude ))/MAXLAT:\(String(format: "%.4f",maxLatitude))/MINLON:\(String(format: "%.4f",minLongitude))/MAXLON:\(String(format: "%.4f",maxLongitude))/timespan:60/protocol:jsono"
        print(baseURL)
        
        // Networking in Alamofire is done asynchronously
        AF.request(baseURL).responseDecodable(of: [ShipStruct].self){
            (response) in
    
            // Early exit if there is an error
            if response.error != nil {
            completion(false, response.error?.localizedDescription)
            }
            
            // Delete existing records
            let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Ship")
            fetch.predicate = NSPredicate(value: true)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetch)
            let _ = try? dataController.viewContext.execute(deleteRequest)
            if response.value == nil {
                completion(false,"Cannot parse API response! Did you use the correct API key?")
                return
            }
            
            // Write new records
            for ship in response.value!{
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
            completion(true, nil)
        }
    }
}

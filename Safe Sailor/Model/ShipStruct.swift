//
//  Ships.swift
//  Safe Sailor
//
//  Created by Dimopoulos Stavros tou Athanasiou on 12/2/20.
//  Copyright © 2020 Dimopoulos Stavros tou Athanasiou. All rights reserved.
//

import Foundation
struct ShipStruct: Codable {
    var course: Int32
    var dsrc: String
    var heading: Int16
    var imo: Int64
    var latitude: Double
    var longitude: Double
    var mmsi: Int16
    var shipId: Int32
    var speed: Int16
    var status: Int16
    var timeStamp: Date?
    var utcSeconds: Int64
    
    private enum CodingKeys: String, CodingKey {
        case course = "COURSE"
        case dsrc = "DSRC"
        case heading = "HEADING"
        case imo = "IMO"
        case latitude = "LAT"
        case longitude = "LON"
        case mmsi = "MMSI"
        case shipId = "SHIP_ID"
        case speed = "SPEED"
        case status = "STATUS"
        case timeStamp = "TIMESTAMP"
        case utcSeconds = "UTC_SECONDS"
    }
    
    internal init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let courseString = try? container.decode(String.self, forKey: .course) {
            course = Int32(courseString)!
        } else {
            course = 0
        }
        
        if let longitudeString = try? container.decode(String.self, forKey: .longitude) {
            longitude = Double(longitudeString)!
        } else {
            longitude = 0
        }
        if let latitudeString = try? container.decode(String.self, forKey: .latitude) {
            latitude = Double(latitudeString)!
        } else {
            latitude = 0
        }
        if let imoString = try? container.decode(String.self, forKey: .imo) {
            imo = Int64(imoString)!
        } else {
            imo = 0
        }
        if let headingString = try? container.decode(String.self, forKey: .heading) {
            heading = Int16(headingString)!
        } else {
            heading = 0
        }
        if let statusString = try? container.decode(String.self, forKey: .status) {
            status = Int16(statusString)!
        } else {
            imo = 0
        }
        if let mmsiString = try? container.decode(String.self, forKey: .mmsi) {
            mmsi = Int16(mmsiString) ?? 0
        } else {
            mmsi = 0
        }
        if let shipIdString = try? container.decode(String.self, forKey: .shipId) {
            shipId = Int32(shipIdString) ?? 0
        } else {
            shipId = 0
        }
        if let speedString = try? container.decode(String.self, forKey: .speed) {
            speed = Int16(speedString) ?? 0
        } else {
            speed = 0
        }
        if let statusString = try? container.decode(String.self, forKey: .status) {
            status = Int16(statusString) ?? 0
        } else {
            status = 0
        }
        if let utcSecondsString = try? container.decode(String.self, forKey: .utcSeconds) {
            utcSeconds = Int64(utcSecondsString)!
        } else {
            utcSeconds = 0
        }
        if let timeStampString = try? container.decode(String.self, forKey: .timeStamp) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            timeStamp = dateFormatter.date(from: timeStampString)!
        }
        dsrc = try! container.decode(String.self, forKey: .dsrc)
    }
    
}

//
//  MainViewControllerUtilityFunctions.swift
//  Safe Sailor
//
//  Created by Dimopoulos Stavros tou Athanasiou on 13/2/20.
//  Copyright © 2020 Dimopoulos Stavros tou Athanasiou. All rights reserved.
//

import Foundation
import  UIKit
import  MapKit
extension MainViewController {
    
    func randomiseSpeedHeading(){
        heading = Int.random(in: 0...359)
        speed = Int.random(in: 0...100)
    }
    
    // If it is the first time the user runs the application, then :
    // 1. Display the information screen
    // 2. Request the API key
    func ifFirstRun() {
        if !UserDefaults.standard.bool(forKey: "displayedInfoScreen"){
            UserDefaults.standard.set(true, forKey: "displayedInfoScreen")
            performSegue(withIdentifier: "displayInfoSegue", sender: self)
        }
        if !UserDefaults.standard.bool(forKey: "hasValidApiKey") { // Ask for the API key.
            setupApiKey(self)
            CreateCoreData().CreateTestData(dataController: dataController) // This is the first run, create some demo data
        }
    }
    
    // Handler for the API request
    func downloadDataHandler (status: Bool, errorMessage:String?) {
        if status == false {
            alert(title: "Update error!", message: errorMessage!)
        } else {
            redrawPins()
        }
    }
        // 	modified from https://stackoverflow.com/a/45931831
    func linesIntersect(line1: (a: CLLocationCoordinate2D, b: CLLocationCoordinate2D), line2: (a: CLLocationCoordinate2D, b: CLLocationCoordinate2D)) -> Bool {
        
        let distance = (line1.b.latitude - line1.a.latitude) * (line2.b.longitude - line2.a.longitude) - (line1.b.longitude - line1.a.longitude) * (line2.b.latitude - line2.a.latitude)
        if distance == 0 {
            return false // Either it is our location either the ship have already crashed 
        }
        let u = ((line2.a.latitude - line1.a.latitude) * (line2.b.longitude - line2.a.longitude) - (line2.a.longitude - line1.a.longitude) * (line2.b.latitude - line2.a.latitude)) / distance
        let v = ((line2.a.latitude - line1.a.latitude) * (line1.b.longitude - line1.a.longitude) - (line2.a.longitude - line1.a.longitude) * (line1.b.latitude - line1.a.latitude)) / distance
        if (u > 0.0 && u < 1.0) {
            return true
        }
        if (v > 0.0 && v < 1.0) {
            return true
        }
        return false
    }
}

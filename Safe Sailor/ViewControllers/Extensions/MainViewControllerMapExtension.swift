//
//  MainViewControllerMapExtension.swift
//  Safe Sailor
//
//  Created by Dimopoulos Stavros tou Athanasiou on 13/2/20.
//  Copyright © 2020 Dimopoulos Stavros tou Athanasiou. All rights reserved.
//

import Foundation
import MapKit
import CoreData

extension MainViewController:MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor(red: 0.65, green: 0.58, blue: 1.0, alpha: 1)
        renderer.lineWidth = 5.0
        return renderer
    }
    
    func redrawPins(){
        // Clear existing annotations and ship tracks
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
        // Draw new annotations and ship tracks
        let fetchRequest:NSFetchRequest<Ship> = Ship.fetchRequest()
        var collisionDanger:Bool = false
        center = mapView.centerCoordinate
        if gpsEnabled {
                       if let center = locationManager?.location?.coordinate {
                           self.center = center
                           mapView.isScrollEnabled = false
                           mapView.setCenter(center, animated: true)
                           mapView.region.span.longitudeDelta = 0.0001
                                      mapView.region.span.latitudeDelta = 0.0001
                       } else {
                           mapView.isScrollEnabled = true
                       }
                   } else {
                       mapView.isScrollEnabled = true
                   }
        // draw my estimated path
               let speed = Double(self.speed) * 0.001852
               let heading = Double(self.heading - 90) * Double.pi / 180
               let myEstimatedCoordinate = CLLocationCoordinate2D(latitude: center.latitude -  MKMapPointsPerMeterAtLatitude(center.latitude) * speed * sin(heading) , longitude: center.longitude + MKMapPointsPerMeterAtLatitude(center.latitude) * speed * cos(heading))
               let coords:[CLLocationCoordinate2D] = [center, myEstimatedCoordinate]
               let line = MKPolyline(coordinates: coords, count:2 )
               mapView.addOverlay(line, level: .aboveRoads)
        
        if let results = try? dataController.viewContext.fetch(fetchRequest){
            print("----------------------------")
            print("Loading saved data")
            print("----------------------------")
            for pin in results {
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
                mapView.addAnnotation(annotation)
                if (pin.heading != 511) && (pin.heading != -1) {  // -1 or 511 = not available
                    let speed = Double(pin.speed) * 0.0001852
                    let heading = Double(-pin.heading + 180 ) * Double.pi / 180
                    let estimatedCoordinate = CLLocationCoordinate2D(latitude: annotation.coordinate.latitude -  MKMapPointsPerMeterAtLatitude(pin.latitude) * speed * sin(heading) , longitude: annotation.coordinate.longitude + MKMapPointsPerMeterAtLatitude(pin.latitude) * speed * cos(heading))
                    let coords:[CLLocationCoordinate2D] = [annotation.coordinate, estimatedCoordinate]
                    let line = MKPolyline(coordinates: coords, count:2 )
                    mapView.addOverlay(line, level: .aboveLabels)
                    
                    // check if there are any other ships in our route
                    if linesIntersect(line1: (a: annotation.coordinate,b: estimatedCoordinate ), line2: (a: center, b: myEstimatedCoordinate)) {
                        collisionDanger = true
                        print ("Collission")
                    }
                }
            } // end for
            print("----------------------------")
            print("Loading is complete!")
            print("----------------------------")
           
            if collisionDanger {
                collisionMessage.isHidden = false
            } else {
                collisionMessage.isHidden = true
                
            }
            
       
            
        
        } // end if
    }
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        redrawPins()
    }
}

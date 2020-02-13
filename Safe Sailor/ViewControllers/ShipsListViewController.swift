//
//  ShipsListViewController.swift
//  Safe Sailor
//
//  Created by Dimopoulos Stavros tou Athanasiou on 12/2/20.
//  Copyright © 2020 Dimopoulos Stavros tou Athanasiou. All rights reserved.
//

import UIKit
import  CoreData
class ShipsListViewController: UITableViewController,AlertProtocol {
    var dataController:DataController!
    var fetchedResultsController:NSFetchedResultsController<Ship>!
    fileprivate func setupFetchedResultsController() {
        let fetchRequest:NSFetchRequest<Ship> = Ship.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "shipId", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFetchedResultsController()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFetchedResultsController()
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: false)
            tableView.reloadRows(at: [indexPath], with: .fade)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fetchedResultsController = nil
    }
    // -------------------------------------------------------------------------
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let aShip = fetchedResultsController.object(at: indexPath)
        alert(title: "Ship info", message: "IMO: \(aShip.imo)\r\nLatitude: \(aShip.latitude)\r\n Longitude: \(aShip.longitude)\r\nHeading: \(aShip.heading) \r\nSpeed: \(Double(aShip.speed)/10) Knots")
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[0].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aShip = fetchedResultsController.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier:  "shipCell", for: indexPath) as! ShipTableViewCell
        
        // Configure cell
        cell.cellText.text  = "IMO: \(aShip.imo)\r\nLatitude: \(aShip.latitude) Longitude: \(aShip.longitude)\r\nHeading: \(aShip.heading) Speed: \(Double(aShip.speed)/10) Knots"
        
        return cell
    }
    
}

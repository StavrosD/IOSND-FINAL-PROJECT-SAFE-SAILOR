//
//  Alert.swift
//  IOSND-OnTheMap
//
//  Created by Dimopoulos Stavros tou Athanasiou on 30/1/20.
//  Copyright © 2020 Dimopoulos Stavros tou Athanasiou. All rights reserved.
//

import UIKit


protocol AlertProtocol {
    // Display a message to the user
    func alert(title:String, message:String)
    func alert (message:String) // It sets title = "Error"
}

extension AlertProtocol where Self:UIViewController{
    // Display a message to the user
    func alert(title:String, message:String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("Error: \(message)")
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func alert(message:String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("Error: \(message)")
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
  
}

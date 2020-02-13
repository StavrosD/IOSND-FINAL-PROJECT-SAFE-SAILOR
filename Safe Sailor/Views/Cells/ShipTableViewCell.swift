//
//  ShipTableViewCell.swift
//  Safe Sailor
//
//  Created by Dimopoulos Stavros tou Athanasiou on 13/2/20.
//  Copyright © 2020 Dimopoulos Stavros tou Athanasiou. All rights reserved.
//

import UIKit

class ShipTableViewCell: UITableViewCell {
    @IBOutlet weak var cellText: UILabel!
    override func prepareForReuse() {
        cellText.text = nil
    }
}

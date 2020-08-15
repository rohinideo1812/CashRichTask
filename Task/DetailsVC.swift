//
//  DetailsVC.swift
//  Task
//
//  Created by Rohini Deo on 15/08/20.
//  Copyright © 2020 Taxgenie. All rights reserved.
//

import UIKit

class DetailsVC: UIViewController {

    //Mark:IBOutlets:
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var lat: UILabel!
    @IBOutlet weak var long: UILabel!
    @IBOutlet weak var temp: UILabel!
    
    //Mark:Properties:
    var strHumidity = ""
    var strLat = ""
    var strLong = ""
    var strTemp = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.temp.text = "Temperature- " + self.strTemp
        self.humidity.text =  "Humidity- " + self.strHumidity
        self.lat.text =  "Selected Lattitude- " + self.strLat
        self.long.text =  "Selected Longitude- " + self.strLong
    }
}

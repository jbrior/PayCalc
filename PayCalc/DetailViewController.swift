//
//  DetailViewController.swift
//  PayCalc
//
//  Created by Jesse Brior on 1/7/20.
//  Copyright © 2020 Jesse Brior. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var w1Label: UILabel!
    @IBOutlet var w2Label: UILabel!
    @IBOutlet var amountLabel: UILabel!
    
    var info = [String:Any]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let price = String(format: "$%.02f", info["amount"] as! Float)
        let w1 = info["w1H"] as! Int
        let w2 = info["w2H"] as! Int
        
        dateLabel.text = info["date"] as? String
        w1Label.text = String(w1)
        w2Label.text = String(w2)
        amountLabel.text = price

    }

}

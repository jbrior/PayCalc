//
//  ResultsViewController.swift
//  PayCalc
//
//  Created by Jesse Brior on 1/6/20.
//  Copyright © 2020 Jesse Brior. All rights reserved.
//

import UIKit
import Firebase

class ResultsViewController: UIViewController {
    @IBOutlet var grossLabel: UILabel!
    @IBOutlet var netLabel: UILabel!
    @IBOutlet var taxLabel: UILabel!
    @IBOutlet var saveBtn: UIButton!
    @IBOutlet var cancelBtn: UIButton!
    @IBOutlet var detailsTextView: UITextView!
    @IBOutlet var staticGrossLabel: UILabel!
    @IBOutlet var staticNetLabel: UILabel!
    @IBOutlet var staticTaxLabel: UILabel!
    @IBOutlet var staticDetailLabel: UILabel!
    
    var hours = [Float]() // List that was passed
    let db = Firestore.firestore()
    
    var gross_amount = Float()
    var net_amount = Float()
    var taxes_taken = Float()
    var w1_ot_hours = Float(0.0)
    var w2_ot_hours = Float(0.0)
    var w1_reg_hours = Float(0.0)
    var w2_reg_hours = Float(0.0)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveBtn.layer.borderWidth = 1
        saveBtn.layer.borderColor = UIColor(red: 0.2353, green: 0.698, blue: 0.2275, alpha: 1.0).cgColor
        saveBtn.layer.cornerRadius = 53
        saveBtn.setTitleColor(UIColor(red: 0.2353, green: 0.698, blue: 0.2275, alpha: 1.0), for: .normal)
        
        cancelBtn.layer.borderWidth = 1
        cancelBtn.layer.borderColor = UIColor(red: 0.949, green: 0.2078, blue: 0.2078, alpha: 1.0).cgColor
        cancelBtn.layer.cornerRadius = 53
        cancelBtn.setTitleColor(UIColor(red: 0.949, green: 0.2078, blue: 0.2078, alpha: 1.0), for: .normal)
        
        grossLabel.layer.masksToBounds = true
        grossLabel.layer.cornerRadius = 31
        netLabel.layer.masksToBounds = true
        netLabel.layer.cornerRadius = 31
        taxLabel.layer.masksToBounds = true
        taxLabel.layer.cornerRadius = 31
        
        calculate()
    }
    
    // Calculate OT hours of each week
    func calculate() {
        if hours[0] > 40.0 {
            w1_reg_hours = 40.0
            w1_ot_hours = hours[0] - 40.0
        }else{
            w1_reg_hours = hours[0]
        }
        
        if hours[1] > 40.0 {
            w2_reg_hours = 40.0
            w2_ot_hours = hours[1] - 40.0
        }else{
            w2_reg_hours = hours[1]
        }
        
        // Calculate Final Amounts
        let w1_gross = Float((w1_reg_hours * HOURLY_RATE) + (w1_ot_hours * OT_RATE))
        let w2_gross = Float((w2_reg_hours * HOURLY_RATE) + (w2_ot_hours * OT_RATE))
        
        gross_amount = Float(w1_gross + w2_gross)
        
        taxes_taken = Float(gross_amount * TAX_DEDUCTS)
        
        net_amount = Float(gross_amount - taxes_taken)
        
        // Set Label Text
        grossLabel.text = String(format: "$%.02f", gross_amount)
        netLabel.text = String(format: "$%.02f", net_amount)
        taxLabel.text = String(format: "$%.02f", taxes_taken)
        
        detailsTextView.text = """
        w1 Hours: \(hours[0])
        w1 OT Hours: \(w1_ot_hours)
        w2 Hours: \(hours[1])
        w2 OT Hours: \(w2_ot_hours)
        """
    }
    
    func talkWithDatabase() {
        db.collection("history").document().setData([
            "amount": net_amount,
            "date": Timestamp(date: Date()),
            "w1_hours": hours[0],
            "w2_hours": hours[1]
        ]) { err in
            if let err = err {
                print("error writing document: \(err)")
            }else{
                print("Document successfully written!")
            }
        }
    }
    
    @IBAction func savePressed(_ sender: Any) {
        talkWithDatabase()
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "toHome", sender: self)
    }
    
}

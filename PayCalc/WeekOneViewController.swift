//
//  WeekOneViewController.swift
//  PayCalc
//
//  Created by Jesse Brior on 1/6/20.
//  Copyright © 2020 Jesse Brior. All rights reserved.
//

import UIKit
import Firebase

class WeekOneViewController: UIViewController {
    
    let db = Firestore.firestore()
    
    var hours = Float()
    
    @IBOutlet var hoursTextField: UITextField!
    @IBOutlet var nextBtn: UIButton!
    @IBOutlet var historyBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextBtn.layer.cornerRadius = 45
        
        historyBtn.setTitleColor(UIColor(red: 0.898, green: 0.4314, blue: 0, alpha: 1.0), for: .normal)
        historyBtn.layer.cornerRadius = 75
        historyBtn.layer.borderColor = UIColor(red: 0.898, green: 0.4314, blue: 0, alpha: 1.0).cgColor
        historyBtn.layer.borderWidth = 1
        
    }
    @IBAction func textFieldChanged(_ sender: Any) {
        let s = hoursTextField.text as NSString?
        hours = s!.floatValue
        
        if let text = hoursTextField.text, !text.isEmpty {
            nextBtn.isEnabled = true
            nextBtn.setTitleColor(.white, for: .normal)
        }else{
            nextBtn.isEnabled = false
            nextBtn.setTitleColor(.lightGray, for: .normal)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? WeekTwoViewController {
            vc.w1Hours = hours
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        hoursTextField.endEditing(true)
        self.view.resignFirstResponder()
    }

}

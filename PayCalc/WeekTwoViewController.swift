//
//  WeekTwoViewController.swift
//  PayCalc
//
//  Created by Jesse Brior on 1/6/20.
//  Copyright © 2020 Jesse Brior. All rights reserved.
//

import UIKit

class WeekTwoViewController: UIViewController {
    
    var hours = Float()
    
    @IBOutlet var hoursTextField: UITextField!
    @IBOutlet var nextBtn: UIButton!
    
    var w1Hours = Float()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextBtn.layer.cornerRadius = 45
        
    }
    
    @IBAction func hoursChanged(_ sender: Any) {
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
        if let vc = segue.destination as? ResultsViewController {
            vc.hours = [w1Hours, hours]
        }
    }
    
}

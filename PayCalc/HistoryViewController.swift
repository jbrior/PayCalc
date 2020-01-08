//
//  HistoryViewController.swift
//  PayCalc
//
//  Created by Jesse Brior on 1/6/20.
//  Copyright © 2020 Jesse Brior. All rights reserved.
//

import UIKit
import Firebase

class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let db = Firestore.firestore()
    var dataArray = [[String: Any]]()
    var selectedRow = Int()
    var date = String()
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        db.collection("history").order(by: "date", descending: true).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.dataArray.append(document.data())
                }
                //self.readData()
                self.tableView.reloadData()
                self.tableView.tableFooterView = UIView()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //let amount = dataArray[indexPath.row]["amount"] as! Float
        let amount = (dataArray[indexPath.row]["amount"] as? NSNumber)?.floatValue
        cell.detailTextLabel?.text = String(format: "$%.02f", amount!)
        cell.textLabel?.text = "\(dateFormatter(d: dataArray[indexPath.row]["date"]! as! Timestamp))"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        selectedRow = indexPath.row
        date = dateFormatter(d: dataArray[selectedRow]["date"]! as! Timestamp)
        
        self.performSegue(withIdentifier: "toDetail", sender: self)
    }
    
    func dateFormatter(d: Timestamp) -> String {
        let date = d
        let fdate = Date(timeIntervalSince1970: TimeInterval(date.seconds))
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_US")
        let finalDate = dateFormatter.string(from: fdate)
        
        return finalDate
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? DetailViewController {
            let a = (dataArray[selectedRow]["amount"] as? NSNumber)?.floatValue
            let newArray = [
                "amount": a!,
                "date": date,
                "w1H": dataArray[selectedRow]["w1_hours"]!,
                "w2H": dataArray[selectedRow]["w2_hours"]!
            ] as [String:Any]
            
            vc.info = newArray
        }
    }
}

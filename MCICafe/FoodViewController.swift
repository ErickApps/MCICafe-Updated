//
//  SecondViewController.swift
//  MCICafe
//
//  Created by Erick Barbosa on 12/23/16.
//  Copyright © 2016 Erick Barbosa. All rights reserved.
//

import UIKit
import Firebase

class FoodViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    var snapData: [String:[Menu]] = [:]
    
    var foodArr: [Menu] = []{
        didSet{
            tableView.reloadData()
        }
        
    }
    var nodeKey: String = "breakfast"
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self
        getMenu()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditMenuSegue" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let menuItem = foodArr[indexPath.row]
                let controller = segue.destination as! EditViewController
                controller.item = menuItem
                controller.indexKey = String(indexPath.row)
                controller.nodeKey = self.nodeKey
                controller.endOfIndex = String(self.foodArr.count)
                
                
                //                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                //                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }


    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodCell", for: indexPath) as! FoodTableViewCell
        
        let foodMenu = self.foodArr[(indexPath as NSIndexPath).row]
        
        cell.titleLabel.text = foodMenu.title
        cell.descriptionLabel.text = foodMenu.description
        cell.costLabel.text = foodMenu.cost
        

        
        return cell
    }

    @IBAction func tabBar(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 1: self.foodArr = self.snapData[nodeLocation.soupAndSalad.rawValue]!
            self.nodeKey = nodeLocation.soupAndSalad.rawValue
        case 2: self.foodArr = self.snapData[nodeLocation.sandwich.rawValue]!
            self.nodeKey = nodeLocation.sandwich.rawValue
    
        default:
            self.foodArr = self.snapData[nodeLocation.breakfast.rawValue]!
            self.nodeKey = nodeLocation.breakfast.rawValue
        }
 
        
    }
    
    func getMenu(){
        
        var ref: FIRDatabaseReference!
        
        ref = FIRDatabase.database().reference()
        
        ref.child("menu").child("food").observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            
            self.snapData.updateValue(unWrapMenu(snapshot: snapshot, nodeKey: "breakfast"), forKey: "breakfast")
            self.snapData.updateValue(unWrapMenu(snapshot: snapshot, nodeKey: "soupAndSalad"), forKey: "soupAndSalad")
            self.snapData.updateValue(unWrapMenu(snapshot: snapshot, nodeKey: "sandwich"), forKey: "sandwich")
            self.foodArr = self.snapData["breakfast"]!
            
            })
        { (error) in
            print(error.localizedDescription)
        }

    }
    
}


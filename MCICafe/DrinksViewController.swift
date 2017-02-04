//
//  DrinksViewController.swift
//  MCICafe
//
//  Created by Erick Barbosa on 1/7/17.
//  Copyright © 2017 Erick Barbosa. All rights reserved.
//

import UIKit
import Firebase

class DrinksViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var drinkData: [String:[Menu]] = [:]
    
    var DrinksArr: [Menu] = []{
        didSet{
            tableView.reloadData()
        }
        
    }
    var nodeKey = nodeLocation.coffee.rawValue

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                let menuItem = DrinksArr[indexPath.row]
                let controller = segue.destination as! EditViewController
                controller.item = menuItem
                controller.indexKey = String(indexPath.row)
                controller.nodeKey = self.nodeKey
                controller.endOfIndex = String(self.DrinksArr.count)
                
            }
        }
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.DrinksArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DrinksCell", for: indexPath)
        
        let drink = self.DrinksArr[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = drink.title
        cell.detailTextLabel?.text = "$\(drink.cost)"
        
        return cell
    }
    
    func getMenu(){
        
        var ref: FIRDatabaseReference!
        
        ref = FIRDatabase.database().reference()
        
        ref.child("menu").child("drinks").observe(FIRDataEventType.value, with: { (snapshot) in
            
 
            self.drinkData.updateValue(unWrapMenu(snapshot: snapshot, nodeKey: nodeLocation.coffee.rawValue), forKey: nodeLocation.coffee.rawValue)
            self.drinkData.updateValue(unWrapMenu(snapshot: snapshot, nodeKey: nodeLocation.softDrink.rawValue), forKey: nodeLocation.softDrink.rawValue)
            self.DrinksArr = self.drinkData[nodeLocation.coffee.rawValue]!
            
            })
        { (error) in
            print(error.localizedDescription)
        }

    
   
     }
    @IBAction func drinksTab(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 1 {
            self.DrinksArr = drinkData[nodeLocation.softDrink.rawValue]!
            self.nodeKey = nodeLocation.softDrink.rawValue
        }else{
            self.DrinksArr = drinkData[nodeLocation.coffee.rawValue]!
            self.nodeKey = nodeLocation.coffee.rawValue
        }
        
    }


}

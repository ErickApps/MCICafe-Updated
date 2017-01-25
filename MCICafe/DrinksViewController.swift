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
    
    var drinkData: [String:[MenuSpecials]] = [:]
    
    var DrinksArr: [MenuSpecials] = []{
        didSet{
            tableView.reloadData()
        }
        
    }
    let nodeKey = "drinks"

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        getMenu()

        // Do any additional setup after loading the view.
        
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
                
                
                //                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                //                controller.navigationItem.leftItemsSupplementBackButton = true
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
        cell.detailTextLabel?.text = drink.cost
        
        return cell
    }
    
    func getMenu(){
        
        var ref: FIRDatabaseReference!
        
        ref = FIRDatabase.database().reference()
        
        ref.child("menu").child("drinks").observeSingleEvent(of: .value, with: { (snapshot) in
            
 
            self.drinkData.updateValue(unWrapDrink(snapshot: snapshot, nodeKey: "coffee"), forKey: "coffee")
            self.drinkData.updateValue(unWrapDrink(snapshot: snapshot, nodeKey: "softDrink"), forKey: "softDrink")
            self.DrinksArr = self.drinkData["coffee"]!
            
            })
        { (error) in
            print(error.localizedDescription)
        }

    
   
     }
    @IBAction func drinksTab(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 1 {
            self.DrinksArr = drinkData["softDrink"]!
        }else{
            self.DrinksArr = drinkData["coffee"]!
        }
        
    }


}

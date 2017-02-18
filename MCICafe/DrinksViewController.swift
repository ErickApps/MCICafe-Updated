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
    var ref: FIRDatabaseReference!
    @IBOutlet weak var addbuttonItem: UIBarButtonItem!
    var drinkData: [String:[Menu]] = [:]
    
    var DrinksArr: [Menu] = []{
        didSet{
            tableView.reloadData()
        }
        
    }
    var nodeKey = nodeLocation.coffee.rawValue

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference().child("menu").child("drinks").child(nodeLocation.coffee.rawValue)
        self.addbuttonItem.isEnabled = false
        self.addbuttonItem.tintColor = UIColor.clear

        tableView.delegate = self
        tableView.dataSource = self
        self.automaticallyAdjustsScrollViewInsets = false
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
    
    override func viewWillAppear(_ animated: Bool) {
        
        if isLogIn() {
            self.addbuttonItem.isEnabled = true
            self.addbuttonItem.tintColor = UIColor.blue
            tableView.allowsSelection = true
        }
        
    }
    
    @IBAction func editItemButton(_ sender: UIBarButtonItem) {
        tableView.setEditing(!tableView.isEditing, animated: true)
        
        if tableView.isEditing {
            self.navigationItem.leftBarButtonItem?.title = "Done"
        } else {
            self.navigationItem.leftBarButtonItem?.title = "Edit"
        }
        
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to toIndexPath: IndexPath) {
        
        
        let postFrom = ["title": DrinksArr[fromIndexPath.row].title,
                        "cost": DrinksArr[fromIndexPath.row].cost]
    
        let postTo = ["title": DrinksArr[toIndexPath.row].title,
                      "cost": DrinksArr[toIndexPath.row].cost]
        
        
        self.ref.updateChildValues([String(toIndexPath.row): postFrom])
        self.ref.updateChildValues([String(fromIndexPath.row): postTo])
        
        
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
        
        let inRef = FIRDatabase.database().reference().child("menu").child("drinks")
        inRef.observe(FIRDataEventType.value, with: { (snapshot) in
            
 
            self.drinkData.updateValue(unWrapMenu(snapshot: snapshot.childSnapshot(forPath: nodeLocation.coffee.rawValue)), forKey: nodeLocation.coffee.rawValue)
            
            self.drinkData.updateValue(unWrapMenu(snapshot: snapshot.childSnapshot(forPath: nodeLocation.softDrink.rawValue)), forKey: nodeLocation.softDrink.rawValue)
            
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
            ref = FIRDatabase.database().reference().child("menu").child("drinks").child(nodeLocation.softDrink.rawValue)
        }else{
            self.DrinksArr = drinkData[nodeLocation.coffee.rawValue]!
            self.nodeKey = nodeLocation.coffee.rawValue
             ref = FIRDatabase.database().reference().child("menu").child("drinks").child(nodeLocation.coffee.rawValue)
        }
        
    }


}

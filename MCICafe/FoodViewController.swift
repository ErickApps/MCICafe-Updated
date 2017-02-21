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
    var ref: FIRDatabaseReference!
    
    @IBOutlet weak var addbuttonItem: UIBarButtonItem!
    var foodArr: [Menu] = []{
        didSet{
            tableView.reloadData()
        }
        
    }
    var nodeKey: String = "breakfast"
    
    @IBOutlet weak var tabControl: UISegmentedControl!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
       
        ref = FIRDatabase.database().reference().child("menu").child("food").child(nodeLocation.breakfast.rawValue)
        self.addbuttonItem.isEnabled = false
        self.addbuttonItem.tintColor = UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
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
                let menuItem = foodArr[indexPath.row]
                let controller = segue.destination as! EditViewController
                controller.item = menuItem
                controller.indexKey = String(indexPath.row)
                controller.nodeKey = self.nodeKey
                controller.endOfIndex = String(self.foodArr.count)
                
                
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if isLogIn() {
            self.addbuttonItem.isEnabled = true
            self.addbuttonItem.tintColor = UIColor.blue
            tableView.allowsSelection = true
            self.navigationController?.isNavigationBarHidden = false
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
        cell.descriptionLabel.text = foodMenu.description ?? "\n"
        cell.costLabel.text = "$\(foodMenu.cost)"
        

        
        return cell
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
    
        
    let postFrom = ["title": self.foodArr[fromIndexPath.row].title,
    "description": self.foodArr[fromIndexPath.row].description,
    "cost": self.foodArr[fromIndexPath.row].cost]
    
    
    let postTo = ["title": self.foodArr[toIndexPath.row].title,
    "description": self.foodArr[toIndexPath.row].description,
    "cost": self.foodArr[toIndexPath.row].cost]
    
    
    self.ref.updateChildValues([String(toIndexPath.row): postFrom])
    self.ref.updateChildValues([String(fromIndexPath.row): postTo])
    
    
    }




    @IBAction func tabBar(_ sender: UISegmentedControl) {
        
      
        switch sender.selectedSegmentIndex {
        case 1: self.foodArr = self.snapData[nodeLocation.soupAndSalad.rawValue]!
        self.nodeKey = nodeLocation.soupAndSalad.rawValue
        ref = FIRDatabase.database().reference().child("menu").child("food").child(nodeLocation.soupAndSalad.rawValue)
            
        case 2: self.foodArr = self.snapData[nodeLocation.sandwich.rawValue]!
        self.nodeKey = nodeLocation.sandwich.rawValue
        ref = FIRDatabase.database().reference().child("menu").child("food").child(nodeLocation.sandwich.rawValue)
            
        default:
            self.foodArr = self.snapData[nodeLocation.breakfast.rawValue]!
            self.nodeKey = nodeLocation.breakfast.rawValue
            ref = FIRDatabase.database().reference().child("menu").child("food").child(nodeLocation.breakfast.rawValue)
        }
        
    }
    
    func getMenu(){
        
        let inRef = FIRDatabase.database().reference().child("menu").child("food")
        inRef.observe(FIRDataEventType.value, with: { (snapshot) in
            
            self.snapData.updateValue(unWrapMenu(snapshot:snapshot.childSnapshot(forPath: "breakfast")),forKey: "breakfast")
            self.snapData.updateValue(unWrapMenu(snapshot: snapshot.childSnapshot(forPath: "soupAndSalad")),forKey: "soupAndSalad")
            self.snapData.updateValue(unWrapMenu(snapshot: snapshot.childSnapshot(forPath: "sandwich")), forKey: "sandwich")
            self.foodArr = self.snapData["breakfast"]!
            
            })
        { (error) in
            print(error.localizedDescription)
        }

    }
    
    
}


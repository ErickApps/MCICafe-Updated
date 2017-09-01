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
  
  
  var snapData: [String:[Menu]] = [:]
  var ref: FIRDatabaseReference!
  var nodeKey: String = "breakfast"
  var foodArr: [Menu] = []{
    didSet{
      tableView.reloadData()
    }
  }
  
  
  @IBOutlet var tableView: UITableView!
  @IBOutlet weak var addbuttonItem: UIBarButtonItem!
  @IBOutlet weak var tabControl: UISegmentedControl!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupTableView()
    getMenu()
    
  }
  
  func setupTableView()  {
    
    ref = FIRDatabase.database().reference().child("menu").child("food").child(node.breakfast.rawValue)
    tableView.delegate = self
    tableView.dataSource = self
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 120
    self.automaticallyAdjustsScrollViewInsets = false
    
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
  
  override func viewWillAppear(_ animated: Bool) {
    
    if isLogIn() {
      tableView.allowsSelection = true
      self.navigationController?.isNavigationBarHidden = false
    }
  }
  @IBAction func editItemButton(_ sender: UIBarButtonItem) {
    tableView.setEditing(!tableView.isEditing, animated: true)
  }
  
   //Mark: TableView Delegate
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
  @IBAction func tabBar(_ sender: UISegmentedControl) {
    
    // check what current seletction on tab control and update
    switch sender.selectedSegmentIndex {
    case 1: self.foodArr = self.snapData[node.soupAndSalad.rawValue]!
    self.nodeKey = node.soupAndSalad.rawValue
    ref = FIRDatabase.database().reference().child("menu").child("food").child(node.soupAndSalad.rawValue)
      
    case 2: self.foodArr = self.snapData[node.sandwich.rawValue]!
    self.nodeKey = node.sandwich.rawValue
    ref = FIRDatabase.database().reference().child("menu").child("food").child(node.sandwich.rawValue)
      
    case 3: self.foodArr = self.snapData[node.desert.rawValue]!
    self.nodeKey = node.desert.rawValue
    ref = FIRDatabase.database().reference().child("menu").child("food").child(node.desert.rawValue)
      
    default:
      self.foodArr = self.snapData[node.breakfast.rawValue]!
      self.nodeKey = node.breakfast.rawValue
      ref = FIRDatabase.database().reference().child("menu").child("food").child(node.breakfast.rawValue)
    }
    
  }
  
  func getMenu(){
    
    let inRef = FIRDatabase.database().reference().child("menu").child("food")
    inRef.observe(FIRDataEventType.value, with: { (snapshot) in
      
      self.snapData.updateValue(unWrapMenu(snapshot:snapshot.childSnapshot(forPath: "breakfast")),forKey: "breakfast")
      self.snapData.updateValue(unWrapMenu(snapshot: snapshot.childSnapshot(forPath: "soupAndSalad")),forKey: "soupAndSalad")
      self.snapData.updateValue(unWrapMenu(snapshot: snapshot.childSnapshot(forPath: "sandwich")), forKey: "sandwich")
      self.snapData.updateValue(unWrapMenu(snapshot: snapshot.childSnapshot(forPath: "desert")), forKey: "desert")
      self.foodArr = self.snapData["breakfast"]!
      
    })
    { (error) in
      print(error.localizedDescription)
    }
    
  }
  
    
  
}


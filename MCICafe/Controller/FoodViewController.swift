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
  
  
  var snapData: [String:[MenuData]] = [:]
  var ref: FIRDatabaseReference!
  var foodArr: [MenuData] = []{
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
    ref = FIRDatabase.database().reference().child("menu").child("food")
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
    
    if ParseData.isLogIn() {
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
    case 1: self.foodArr = self.snapData[food.soupAndSalad.rawValue]!
    case 2: self.foodArr = self.snapData[food.sandwich.rawValue]!
    case 3: self.foodArr = self.snapData[food.desert.rawValue]!
    default:
      self.foodArr = self.snapData[food.breakfast.rawValue]!
    }
    
  }
  
  func getMenu(){
    
    ref.observe(FIRDataEventType.value, with: { (snapshot) in
      
      
      self.snapData.updateValue(ParseData().parseMenu(itemType: .food, snapshot: snapshot.childSnapshot(forPath: food.breakfast.rawValue)),forKey: food.breakfast.rawValue)
      
      self.snapData.updateValue(ParseData().parseMenu(itemType: .food, snapshot: snapshot.childSnapshot(forPath:  food.soupAndSalad.rawValue)),forKey: food.soupAndSalad.rawValue)
      self.snapData.updateValue(ParseData().parseMenu(itemType: .food, snapshot: snapshot.childSnapshot(forPath: food.sandwich.rawValue)),forKey: food.sandwich.rawValue)
      self.snapData.updateValue(ParseData().parseMenu(itemType: .food, snapshot: snapshot.childSnapshot(forPath: food.desert.rawValue)),forKey: food.desert.rawValue)
      self.foodArr = self.snapData[food.breakfast.rawValue]!
      
    })
    { (error) in
      print(error.localizedDescription)
    }
    
  }
  
    
  
}


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
  @IBOutlet weak var addbuttonItem: UIBarButtonItem!
  
  var drinkData: [String:[MenuData]] = [:]
  var ref: FIRDatabaseReference!
  var DrinksArr: [MenuData] = []{
    didSet{
      tableView.reloadData()
    }
  }
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTable()
    getMenu()
    
  }
   
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func setupTable()  {
    ref = FIRDatabase.database().reference().child("menu").child("drinks")
    tableView.delegate = self
    tableView.dataSource = self
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 140
    self.automaticallyAdjustsScrollViewInsets = false
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "EditMenuSegue" {
      if let indexPath = self.tableView.indexPathForSelectedRow {
        let menuItem = DrinksArr[indexPath.row]
        let controller = segue.destination as! EditViewController
        controller.item = menuItem
        controller.indexKey = String(indexPath.row)
        controller.isDrink = true
        controller.endOfIndex = String(self.DrinksArr.count)
        
      }
    }
  }
  
  
  func getMenu(){
    
    
    ref.observe(FIRDataEventType.value, with: { (snapshot) in
      
      self.drinkData.updateValue(ParseData().parseMenu(itemType: .drink, snapshot: snapshot.childSnapshot(forPath: drink.coffee.rawValue)), forKey: drink.coffee.rawValue)
      
      self.drinkData.updateValue(ParseData().parseMenu(itemType: .drink, snapshot: snapshot.childSnapshot(forPath: drink.softDrink.rawValue)), forKey: drink.softDrink.rawValue)
      
      self.DrinksArr = self.drinkData[drink.coffee.rawValue]!
      
    })
    { (error) in
      print(error.localizedDescription)
    }
    
    
    
  }
  @IBAction func drinksTab(_ sender: UISegmentedControl) {
    
    if sender.selectedSegmentIndex == 1 {
      self.DrinksArr = drinkData[drink.softDrink.rawValue]!
      return
    }
    self.DrinksArr = drinkData[drink.coffee.rawValue]!
    
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
  
  func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
    return .none
  }
  //Mark: TableView Delegate
  
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
  
    
  
}

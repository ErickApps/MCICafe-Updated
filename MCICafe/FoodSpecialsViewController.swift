//
//  FirstViewController.swift
//  MCICafe
//
//  Created by Erick Barbosa on 12/23/16.
//  Copyright © 2016 Erick Barbosa. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase





class FoodSpecialsViewController: UIViewController,UITableViewDelegate, UITableViewDataSource{
    
    var ref: FIRDatabaseReference!
    
    @IBOutlet weak var addbuttonItem: UIBarButtonItem!
    @IBOutlet var tableView: UITableView!
    let nodeKey = "specials"
    var specialsArr: [Menu] = [] {
        didSet {
            tableView.reloadData()
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       ref = FIRDatabase.database().reference().child("menu").child(nodeKey)
        self.addbuttonItem.isEnabled = false
        self.addbuttonItem.tintColor = UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        self.automaticallyAdjustsScrollViewInsets = false
      //  self.navigationItem.leftBarButtonItem = self.editButtonItem
        getMenu()
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
     func numberOfSections(in tableView: UITableView) -> Int {
        
       return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.specialsArr.count)
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellSpecial", for: indexPath) as! SpecialsCell
        
        let dailySpecial = self.specialsArr[(indexPath as NSIndexPath).row]
        
        cell.titleCellLabel.text = dailySpecial.title
        cell.descriptionCellLabel.text = dailySpecial.description
        cell.costCellLabel.text = "$\(dailySpecial.cost)"
        
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

        
                    
                        let postFrom = ["title": self.specialsArr[fromIndexPath.row].title,
                                    "description": self.specialsArr[fromIndexPath.row].description,
                                    "cost": self.specialsArr[fromIndexPath.row].cost]
                    
                    
                    let postTo = ["title": self.specialsArr[toIndexPath.row].title,
                                "description": self.specialsArr[toIndexPath.row].description,
                                "cost": self.specialsArr[toIndexPath.row].cost]
                    
                    
                        self.ref.updateChildValues([String(toIndexPath.row): postFrom])
                    self.ref.updateChildValues([String(fromIndexPath.row): postTo])
                    
                    
        
        
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditMenuSegue" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let menuItem = specialsArr[indexPath.row]
                let controller = segue.destination as! EditViewController
                controller.item = menuItem
                controller.indexKey = String(indexPath.row)
                controller.nodeKey = self.nodeKey
                controller.endOfIndex = String(self.specialsArr.count)
                
            }
        }else if  segue.identifier == "addSegue"{
            let controller = segue.destination as! EditViewController
            controller.nodeKey = self.nodeKey
            controller.segueId = segue.identifier!
        }
    }
    

    
    func getMenu(){
        
        
        
        self.ref.observe(FIRDataEventType.value, with: { (snapshot) in
            
            self.specialsArr = unWrapMenu(snapshot: snapshot)
            
        })


  }

}

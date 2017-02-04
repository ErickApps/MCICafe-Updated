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
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    let nodeKey = "specials"
    var specialsArr: [Menu] = [] {
        didSet {
            tableView.reloadData()
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getMenu()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        tableView.allowsSelection = isLogIn()
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
        }
    }
    

    
    func getMenu(){
        
        var ref: FIRDatabaseReference!
        
        ref = FIRDatabase.database().reference().child("menu")
        
        ref.observe(FIRDataEventType.value, with: { (snapshot) in
            
            self.specialsArr = unWrapMenu(snapshot: snapshot, nodeKey: self.nodeKey)
            
        })


  }

}

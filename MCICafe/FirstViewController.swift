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


var ref: FIRDatabaseReference!
var specialsMenu: NSDictionary?


class FirstViewController: UIViewController,UITableViewDelegate, UITableViewDataSource{
  @IBOutlet var tableView: UITableView!  
   
    var specialsArr: [MenuSpecials] = [] {
        didSet {
            tableView.reloadData()
            
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        

        tableView.delegate = self
        tableView.dataSource = self
        
        // Set delegate and datasource to self (you can do that in interface builder as well
        
        
        
        var ref: FIRDatabaseReference!
        
        ref = FIRDatabase.database().reference()
       
        ref.child("menu").observeSingleEvent(of: .value, with: { (snapshot) in
           // print(snapshot.value)
            
            let y = snapshot.value as! NSDictionary
            let x = y["specials"] as! NSArray
            print(x)
            
            for index in x  {
                let dic = index as! NSDictionary
                
               let title = dic.value(forKey: "title") as! String
               let description = dic.value(forKey: "description") as! String
               let cost = dic.value(forKey: "cost") as! String
                
                self.specialsArr.append(MenuSpecials.init(description: description, title: title, cost: cost))
                print(self.specialsArr)
            }
            
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
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
        cell.costCellLabel.text = dailySpecial.cost
        
        return cell
    }
    
    


}


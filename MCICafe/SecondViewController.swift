//
//  SecondViewController.swift
//  MCICafe
//
//  Created by Erick Barbosa on 12/23/16.
//  Copyright © 2016 Erick Barbosa. All rights reserved.
//

import UIKit
import Firebase

class SecondViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    var ref: FIRDatabaseReference!
    var foodArr: [MenuSpecials] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self
        
    
        ref = FIRDatabase.database().reference()
        
        ref.child("menu").child("food").observeSingleEvent(of: .value, with: { (snapshot) in
            
            self.foodArr = getSpecialMenu(snapshot: snapshot)
            
        })
        { (error) in
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
        return foodArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodCell", for: indexPath) as! FoodTableViewCell
        
        let foodMenu = self.foodArr[(indexPath as NSIndexPath).row]
        
        cell.titleLabel.text = foodMenu.title
        cell.descriptionLabel.text = foodMenu.description
        cell.costLabel.text = foodMenu.cost
        

        
        return cell
    }

}


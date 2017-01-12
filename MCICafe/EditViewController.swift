//
//  EditViewController.swift
//  MCICafe
//
//  Created by Erick Barbosa on 1/12/17.
//  Copyright © 2017 Erick Barbosa. All rights reserved.
//

import UIKit
import Firebase

class EditViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descripitionTextField: UITextField!
    @IBOutlet weak var costTextField: UITextField!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    
    var item: MenuSpecials?
    var indexKey: String?
    var nodeKey: String?
   
    var ref: FIRDatabaseReference!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func saveButton(_ sender: UIButton) {
        ref = FIRDatabase.database().reference()
        
        let post = ["title": titleTextField.text!,
                    "description": descripitionTextField.text!,
                    "cost": costTextField.text!]

        ref.child("menu").child("specials").updateChildValues(["0": post])
        

        
    }
    
    
    func configureView() {
        // Update the user interface.
        
        
        titleLabel.text = item?.title
        descriptionLabel.text = item?.description
        costLabel.text = item?.cost
        
        
    }



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

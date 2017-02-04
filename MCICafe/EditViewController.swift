//
//  EditViewController.swift
//  MCICafe
//
//  Created by Erick Barbosa on 1/12/17.
//  Copyright © 2017 Erick Barbosa. All rights reserved.
//

import UIKit
import Firebase




class EditViewController: UIViewController, UITextFieldDelegate {
    
    var item: Menu?
    var indexKey: String?
    var nodeKey: String?
    var endOfIndex: String?
    



    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descripitionTextField: UITextField!
    @IBOutlet weak var costTextField: UITextField!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addButton.isHidden = true
        deleteButton.isHidden = true
    
        self.configureView()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(NotificationViewController.keyboardDismiss))
        view.addGestureRecognizer(tap)
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func optionsSegment(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            editButton.isHidden = false
            addButton.isHidden = true
            deleteButton.isHidden = true
            hideLabel(bool: false)
            hideTextField(bool: false)
           
        }else if sender.selectedSegmentIndex == 1 {
            addButton.isHidden = false
            editButton.isHidden = true
            deleteButton.isHidden = true
            hideLabel(bool: true)
            hideTextField(bool: false)
        }
        else if sender.selectedSegmentIndex == 2 {
            editButton.isHidden = true
            addButton.isHidden = true
            deleteButton.isHidden = false
            hideTextField(bool: true)
            hideLabel(bool: false)
        }


        
    }
    func keyboardDismiss() {
        titleTextField.resignFirstResponder()
        descripitionTextField.resignFirstResponder()
        costTextField.resignFirstResponder()
    }
    
    
    //Dismiss keyboard using Return Key (Done) Button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        keyboardDismiss()
        
        return true
    }

    
    @IBAction func backButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editButton(_ sender: UIButton) {
        
        
        operation(operationType: "edit")
        self.dismiss(animated: true, completion: nil)

        
    }
    
    @IBAction func addButton(_ sender: UIButton) {
        operation(operationType: "add")
    }
    func hideLabel(bool: Bool) {
        costLabel.isHidden = bool
        descriptionLabel.isHidden = bool
        titleLabel.isHidden = bool

    }
    func hideTextField(bool: Bool) {
        costTextField.isHidden = bool
        descripitionTextField.isHidden = bool
        titleTextField.isHidden = bool

    }

    @IBAction func deleteButton(_ sender: UIButton) {
        
        let ref = getChildLocation(nodeKey: nodeKey!)
        
        
        let startIndex = Int(indexKey!)!
        
        
        
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                
                let nsArr =  snapshot.value as! NSArray
                let endIndex = Int(snapshot.childrenCount-1)
                
                for i in startIndex..<endIndex{
                    
                    let dicData = nsArr[i+1] as! NSDictionary
                    ref.child(String(i)).setValue(dicData.dictionaryWithValues(forKeys: ["title","cost","description"]))
                }
                ref.child(String(snapshot.childrenCount-1)).removeValue()
                
            })
            
        self.dismiss(animated: true, completion: nil)

        
    }
    func configureView() {
        // Update the user interface.
        
        
        titleLabel.text = item?.title
        descriptionLabel.text = item?.description ?? ""
        costLabel.text = item?.cost
        
        
    }
    
    func operation(operationType: String) {
        
//        var action: String?
        let ref = getChildLocation(nodeKey: nodeKey!)
        var index = operationType
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            switch index{
                case "add": index = String(snapshot.childrenCount)
                case "edit": index = self.indexKey!
            default : break
            }
            
            if self.nodeKey ==  nodeLocation.coffee.rawValue || self.nodeKey ==  nodeLocation.softDrink.rawValue{
                if let title = self.titleTextField.text,
                    let cost = self.costTextField.text
                {
                    let post = ["title": title,"cost": cost]
                    ref.updateChildValues([index: post])
                }
                
            }else {
                if let title = self.titleTextField.text, let description = self.descripitionTextField.text, let cost = self.costTextField.text {
                    let post = ["title": title,
                                "description": description,
                                "cost": cost]
                    ref.updateChildValues([index: post])
                    
                }
                
                
            }

            
            
        })



    }
    
    

   
}

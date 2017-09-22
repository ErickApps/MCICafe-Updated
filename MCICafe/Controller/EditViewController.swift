//
//  EditViewController.swift
//  MCICafe
//
//  Created by Erick Barbosa on 1/12/17.
//  Copyright © 2017 Erick Barbosa. All rights reserved.
//

import UIKit
import Firebase




class EditViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate{
  
 // var item: Menu?
  var item: MenuData?
  var indexKey: String?
  var nodeKey: String?
  var endOfIndex: String?
  var segueId: String?
  var isDrink = false
  var ref: FIRDatabaseReference = FIRDatabase.database().reference().child("menu")
  
  
  @IBOutlet weak var segmentModify: UISegmentedControl!
  @IBOutlet weak var titleTextField: UITextField!
  @IBOutlet weak var costTextField: UITextField!
  @IBOutlet weak var descriptionTextView: UITextView!
  @IBOutlet weak var submitButton: UIButton!
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    checkCategorie()
    configureView()
    
    
  }
  func checkCategorie()  {
    
    if segueId != nil {
      segmentModify.isHidden = true
      clearText()
    }
    if isDrink {
      descriptionTextView.isHidden = true
    }

  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func optionsSegment(_ sender: UISegmentedControl) {
    if sender.selectedSegmentIndex == 0 {
      configureView()
      hideTextField(bool: false)
      
    } else if sender.selectedSegmentIndex == 1 {
      hideTextField(bool: false)
      configureView()
    }
    
  }
  func keyboardDismiss() {
    titleTextField.resignFirstResponder()
    costTextField.resignFirstResponder()
    descriptionTextView.resignFirstResponder()
  }
  
  //Dismiss keyboard using Return Key (Done) Button
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    keyboardDismiss()
    
    return true
  }
  func clearText() {
    costTextField.text = nil
    titleTextField.text = nil
    descriptionTextView.text = nil
  }
  
  @IBAction func backButton(_ sender: UIBarButtonItem) {
    self.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func submitButton(_ sender: UIButton) {
    
    if (titleTextField.text?.isEmpty)!  &&  (costTextField.text?.isEmpty)!{
      okAlert(title: "Empty Text",message: "Cannot perform operation on an empty text")
      return
    }
    if  self.segmentModify.isHidden{
      displayAlert(title: "Add",
                   message: "\(self.titleTextField.text!)\n\(self.descriptionTextView.text!)\n\(costTextField.text!)", typeOfOperation: "add", operation: operation(operationType:))
      
    } else if  self.segmentModify.selectedSegmentIndex == 0 {
      displayAlert(title: "Edit",
                   message: "\(self.titleTextField.text!)\n\(self.descriptionTextView.text!)\n\(costTextField.text!)", typeOfOperation: "edit", operation: operation(operationType:))
      
      
    }else if self.segmentModify.selectedSegmentIndex == 1{
      displayAlert(title: "Are you sure you want to delete this item?",message: "\(self.titleTextField.text!)\n\(self.descriptionTextView.text!)\n\(costTextField.text!)", typeOfOperation: "delete",operation: nil)
    }
    
 }
  
  func displayAlert(title: String, message: String,typeOfOperation: String, operation: ((String) -> ())?) {
    
    let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
      (result : UIAlertAction) -> Void in
    }
    
    
    let confirmAction = UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default) {
      (result : UIAlertAction) -> Void in
      
      if typeOfOperation == "delete" {
        self.delete()
        self.dismiss(animated: true, completion: nil)
      }else if typeOfOperation == "edit" {
        operation!(typeOfOperation)
        self.dismiss(animated: true, completion: nil)
      }
      else if typeOfOperation == "add" {
        operation!(typeOfOperation)
        
      }
      
    }
    
    alertController.addAction(cancelAction)
    alertController.addAction(confirmAction)
    self.present(alertController, animated: true, completion: nil)
    
  }
  func okAlert(title: String, message: String) {
    
    let refreshAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    
    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
      
    }))
    
    present(refreshAlert, animated: true, completion: nil)

  }

  
}

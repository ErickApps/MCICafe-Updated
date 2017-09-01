//
//  EditViewExtension.swift
//  MCICafe
//
//  Created by Erick Barbosa on 8/31/17.
//  Copyright © 2017 Erick Barbosa. All rights reserved.
//

import Foundation

extension EditViewController {
  
  func hideTextField(bool: Bool) {
    costTextField.isHidden = bool
    descriptionTextView.isHidden = bool
    titleTextField.isHidden = bool
    
  }
  
  func delete() {
    //it moves the selected item to the last possition and the deletes it
    let ref = getChildLocation(nodeKey: nodeKey!)
    let startIndex = Int(indexKey!)!
    
    ref.observeSingleEvent(of: .value, with: { (snapshot) in
      
      let nsArr =  snapshot.value as! NSArray
      let endIndex = Int(snapshot.childrenCount-1)
      
      for i in startIndex..<endIndex{
        let dicData = nsArr[i+1] as! NSDictionary
        ref.child(String(i)).setValue(dicData.dictionaryWithValues(forKeys: ["title","cost","description"]))
      }
      
      if snapshot.childrenCount-1 == 0 {
        ref.child("0").setValue( ["title": "","description": "","cost": ""])
        return
      }
      
      ref.child(String(snapshot.childrenCount-1)).removeValue()
      
    })
    
  }
  func configureView() {
    // Update the user interface.
    titleTextField.text = item?.title ?? "Title"
    descriptionTextView.text = item?.description ?? "Description"
    costTextField.text = item?.cost ?? "cost"
  }
  
  func operation(operationType: String) {
    
    let ref = getChildLocation(nodeKey: nodeKey!)
    var index = operationType
    ref.observeSingleEvent(of: .value, with: { (snapshot) in
      
      
      switch index{
      case "add": index = String(snapshot.childrenCount)
      case "edit": index = self.indexKey!
      default : break
      }
      
      if self.nodeKey ==  node.coffee.rawValue || self.nodeKey ==  node.softDrink.rawValue{
        if let title = self.titleTextField.text,
          let cost = self.costTextField.text
        {
          let post = ["title": title,"cost": cost]
          ref.updateChildValues([index: post])
          self.clearText()
        }
        
      }else {
        if let title = self.titleTextField.text, let description = self.descriptionTextView.text, let cost = self.costTextField.text {
          let post = ["title": title,
                      "description": description,
                      "cost": cost]
          ref.updateChildValues([index: post])
          self.clearText()
        }
      }
      
    })
    
  }
  
  
  

  
  
}

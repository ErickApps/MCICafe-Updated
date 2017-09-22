//
//  MenuData.swift
//  MCI Café
//
//  Created by Erick Barbosa on 9/16/17.
//  Copyright © 2017 Erick Barbosa. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase




struct MenuData {
  
  var title: String
  var cost: String
  var description: String?
}

class  ParseData {
  
  var menuItems: [MenuData] = []
  
  func parseMenu(itemType: drinkOrFood,snapshot: FIRDataSnapshot) -> [MenuData] {
    
    let itemsArr = snapshot.value as! NSArray
    
    for item in itemsArr  {
      let dic = item as? NSDictionary
      
      switch itemType {
      case .food:  parseFood(dic: dic!)
      case .drink: parseDrink(dic: dic!)
      }
    }
    return menuItems
  }
  
  
  private  func parseFood(dic: NSDictionary)  {
    
    if let title = dic.value(forKey: key.title.rawValue) as? String,
      let cost = dic.value(forKey: key.cost.rawValue) as? String,
      let description = dic.value(forKey: key.description.rawValue) as? String {
      
      menuItems.append(MenuData.init(title: title, cost: cost, description: description))
    }
  }
  
  private func parseDrink(dic: NSDictionary)  {
    
    if let title = dic.value(forKey: key.title.rawValue) as? String,
      let cost = dic.value(forKey: key.cost.rawValue) as? String {
      menuItems.append(MenuData.init(title: title, cost: cost, description: nil))
    }
    
  }
  
 static func isLogIn() -> Bool {
    if FIRAuth.auth()?.currentUser != nil {
      return true
    }
    return false
  }
  
}

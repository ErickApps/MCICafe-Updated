////
////  ModelMenu.swift
////  MCICafe
////
////  Created by Erick Barbosa on 12/24/16.
////  Copyright © 2016 Erick Barbosa. All rights reserved.
////
//
//import Foundation
//import Firebase
//import FirebaseDatabase
//
//
//enum strValues: String{
//  case title
//  case description
//  case cost
//}
//enum node: String {
//  case specials
//  case breakfast
//  case sandwich
//  case soupAndSalad
//  case coffee
//  case softDrink
//  case desert
//}
//enum type: String {
//  case drinks
//  case food
//}
//
//
//
//struct Menu {
//  var description: String?
//  var title: String
//  var cost: String
//  
//}
//
//
//
//// It parses the menu and then create an menu object
//
//func unWrapMenu(snapshot: FIRDataSnapshot) -> [Menu] {
//  
//  var menuItems: [Menu] = []
//  let itemsArr = snapshot.value as! NSArray
//  
//  for item in itemsArr  {
//    let dic = item as? NSDictionary
//    
//    // unwrap food
//    if let title = dic?.value(forKey: strValues.title.rawValue) as? String,let cost = dic?.value(forKey: strValues.cost.rawValue) as? String, let description = dic?.value(forKey: strValues.description.rawValue) as? String{
//      
//      menuItems.append(Menu.init(description: description, title: title, cost: cost))
//    }
//    
//    // unwrap drinks
//    if (dic?.value(forKey: strValues.description.rawValue) == nil) {
//      if let title = dic?.value(forKey: strValues.title.rawValue) as? String,let cost = dic?.value(forKey: strValues.cost.rawValue) as? String{
//        
//        menuItems.append(Menu.init(description: nil, title: title, cost: cost))
//      }
//    }
//    
//    
//    
//    
//  }
//  return menuItems
//  
//}
//// it looks for the node location and returns the location
//func getChildLocation(nodeKey: String) -> FIRDatabaseReference {
//  
//  var ref: FIRDatabaseReference!
//  ref = FIRDatabase.database().reference()
//  var childLocation = ref.child("menu")
//  
//  switch nodeKey {
//  case node.coffee.rawValue:
//    childLocation = ref.child("menu").child("drinks").child(node.coffee.rawValue)
//  case node.softDrink.rawValue:
//    childLocation = ref.child("menu").child("drinks").child(node.softDrink.rawValue)
//  case node.breakfast.rawValue:
//    childLocation = ref.child("menu").child("food").child(node.breakfast.rawValue)
//  case node.sandwich.rawValue:
//    childLocation = ref.child("menu").child("food").child(node.sandwich.rawValue)
//  case node.soupAndSalad.rawValue:
//    childLocation = ref.child("menu").child("food").child(node.soupAndSalad.rawValue)
//  case node.specials.rawValue:
//    childLocation = ref.child("menu").child(node.specials.rawValue)
//  default:
//    break
//  }
//  
//  return childLocation
//  
//}
//
//// verify that the user is logged in
//func isLogIn() -> Bool {
//  if FIRAuth.auth()?.currentUser != nil {
//    return true
//  }
//  return false
//}
//
//class MenuItems {
//  
//  var title: String
//  var cost: String
//  static var ref = FIRDatabase.database().reference().child("menu")
//
//  init(title: String, cost: String) {
//    self.title = title
//    self.cost = cost
//  }
//  
//  // it looks for the node location and returns the location
////  static func getChildLocation(type: category,nodeKey: node) -> FIRDatabaseReference {
////    
////    var ref: FIRDatabaseReference!
////    let nodeRef = "menu"
////    ref = FIRDatabase.database().reference()
////    var childLocation = ref.child(nodeRef)
////    
////    switch nodeKey {
////    case node.coffee.rawValue:
////      childLocation = ref.child(nodeRef).child(type.drinks.rawValue).child(key.coffee.rawValue)
////    case node.softDrink.rawValue:
////      childLocation = ref.child(nodeRef).child("drinks").child(key.softDrink.rawValue)
////    case node.breakfast.rawValue:
////      childLocation = ref.child(nodeRef).child("food").child(key.breakfast.rawValue)
////    case node.sandwich.rawValue:
////      childLocation = ref.child(nodeRef).child("food").child(key.sandwich.rawValue)
////    case node.soupAndSalad.rawValue:
////      childLocation = ref.child(nodeRef).child("food").child(key.soupAndSalad.rawValue)
////    case node.specials.rawValue:
////      childLocation = ref.child(nodeRef).child(key.specials.rawValue)
////    default:
////      break
////    }
////    
////    return childLocation
////    
////  }
//
//  
//  
//}
//
//
//

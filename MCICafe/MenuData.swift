////
////  MenuData.swift
////  MCICafe
////
////  Created by Erick Barbosa on 1/24/17.
////  Copyright © 2017 Erick Barbosa. All rights reserved.
////
//
//import Foundation
//import Firebase
//
//
//struct Menu {
//    var title: String
//    var description: String?
//    var cost: String
//    
//}
//class MenuType {
//    static var MenuData: NSDictionary?
//    static var menuArr: [Menu] = []
//}
//enum MenuSection: String {
//    case specials
//    case breakfast
//    case sandwich
//    case soupAndSalad
//    case coffee
//    case softDrink
//}
//
//
//
//
//
////struct Item {
////    //let coffee: Menu
////    //let softDrink: Menu
////    //let breakfast: Menu
////    //let sandwich: Menu
////    //let soupAndSalad: Menu
////    var specials: [Menu]
////}
//
////protocol JSONDecodable {
////    init?(nodeKey: String)
////}
//
////extension Menu: JSONDecodable {
////    init?(nodeKey: String) {
////
////        
////        
////        var ref: FIRDatabaseReference!
////        
////        ref = FIRDatabase.database().reference()
////        
////        ref.child("menu").observeSingleEvent(of: .value, with: { (snapshot) in
////            
////            var snap = snapshot.value(forKey: "special") as! NSArray
////            
////            
////            for items in snap {
////                let item = items as! NSDictionary
////                if let title = item["title"] as? String, let cost = item["cost"] as? String, let description = item["description"] as? String {
////                    
////                   Menu.init(title: title, description: description, cost: cost)
////                    
////                    title = title
////                    self.cost = cost
////                    self.description = description
////                    
////                }
////
////            }
////            
////        })
////        { (error) in
////            print(error.localizedDescription)
////        }
////        
////    
////
////        
////        
////        
//////        guard let specials = menuDic["specials"] as? [[String: AnyObject]], let special = specials.first else {
//////            return nil
//////        }
//////        
//////        guard let title = special["title"] as? String else { return nil }
//////        guard let cost = special["cost"] as? String else {return nil}
//////        guard let description = special["description"] as? String else {return nil}
//////        
//////        self.specials.title = title
//////        self.specials.description = description
//////        self.specials.cost = cost
//////        
//////        
//////    }
////}
//func createData(itemSection: String) ->[Menu] {
//    
//    var menuArra: NSArray = []
//    var menuItems: [Menu] = []
//    
//    //getMenuP()
//    
//    
//    switch itemSection {
//    case MenuSection.specials.rawValue:
//        menuArra = (MenuType.MenuData?[MenuSection.specials.rawValue] as? NSArray)!
//    case MenuSection.breakfast.rawValue:
//        menuArra = (MenuType.MenuData?[MenuSection.breakfast.rawValue] as? NSArray)!
//    case MenuSection.sandwich.rawValue:
//        menuArra = (MenuType.MenuData?[MenuSection.sandwich.rawValue] as? NSArray)!
//    case MenuSection.softDrink.rawValue:
//        menuArra = (MenuType.MenuData?[MenuSection.softDrink.rawValue] as? NSArray)!
//    case MenuSection.coffee.rawValue:
//        menuArra = (MenuType.MenuData?[MenuSection.coffee.rawValue] as? NSArray)!
//    default: break
//    }
//    
//    for items in menuArra {
//        let item = items as! NSDictionary
//        if let title = item["title"] as? String, let cost = item["cost"] as? String, let description = item["description"] as? String {
//            
//            menuItems.append(Menu.init(title: title, description: description, cost: cost))
//            
//            
//        }
//        
//    }
//    return menuItems
//    
//}
//
//
//
//func unWrapMenu(nodeKey: String) {
//    
//    
//    var ref: FIRDatabaseReference!
//    
//    ref = FIRDatabase.database().reference()
//    
//    ref.child("menu").observeSingleEvent(of: .value, with: { (snapshot) in
//    
//    let menuDic = snapshot.value as! NSDictionary
//     let snap = menuDic[nodeKey] as! NSArray
//    
//    
//    for items in snap {
//    let item = items as! NSDictionary
//    if let title = item["title"] as? String, let cost = item["cost"] as? String,
//        let description = item["description"] as? String {
//        
//    MenuType.menuArr.append(Menu.init(title: title, description: description, cost: cost))
//   
//        }
//    
//    }
//    
//    })
//    { (error) in
//    print(error.localizedDescription)
//}
//
//    return menuArr
//}
//
//
//

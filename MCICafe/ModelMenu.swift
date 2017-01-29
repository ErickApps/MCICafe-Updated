//
//  ModelMenu.swift
//  MCICafe
//
//  Created by Erick Barbosa on 12/24/16.
//  Copyright © 2016 Erick Barbosa. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase




enum strValues: String{
    case title
    case description
    case cost
}
enum nodeLocation: String {
    case specials
    case breakfast
    case sandwich
    case soupAndSalad
    case coffee
    case softDrink
}



struct Menu {
    var description: String?
    var title: String
    var cost: String
        
    }



func unWrapMenu(snapshot: FIRDataSnapshot, nodeKey: String) -> [Menu] {
    
        var itemsArr: NSArray = []
        var menuItems: [Menu] = []
        let menuDic = snapshot.value as! NSDictionary
    
        itemsArr = menuDic.object(forKey: nodeKey) as! NSArray
    
    
        for item in itemsArr  {
            let dic = item as! NSDictionary
    
            if let title = dic.value(forKey: strValues.title.rawValue) as? String,let cost = dic.value(forKey: strValues.cost.rawValue) as? String, let description = dic.value(forKey: strValues.description.rawValue) as? String{
                 menuItems.append(Menu.init(description: description, title: title, cost: cost))
            }
            
            
            if (dic.value(forKey: strValues.description.rawValue) == nil) {
                if let title = dic.value(forKey: strValues.title.rawValue) as? String,let cost = dic.value(forKey: strValues.cost.rawValue) as? String{
                    menuItems.append(Menu.init(description: nil, title: title, cost: cost))
                }
            }
            
    
            
    
    }
    return menuItems

}

func getChildLocation(nodeKey: String) -> FIRDatabaseReference {
    
    var ref: FIRDatabaseReference!
    ref = FIRDatabase.database().reference()
    var childLocation = ref.child("menu")
    
    switch nodeKey {
    case nodeLocation.coffee.rawValue:
        childLocation = ref.child("menu").child("drinks").child(nodeLocation.coffee.rawValue)
    case nodeLocation.softDrink.rawValue:
        childLocation = ref.child("menu").child("drinks").child(nodeLocation.softDrink.rawValue)
    case nodeLocation.breakfast.rawValue:
        childLocation = ref.child("menu").child("food").child(nodeLocation.breakfast.rawValue)
    case nodeLocation.sandwich.rawValue:
        childLocation = ref.child("menu").child("food").child(nodeLocation.sandwich.rawValue)
    case nodeLocation.soupAndSalad.rawValue:
        childLocation = ref.child("menu").child("food").child(nodeLocation.soupAndSalad.rawValue)
    case nodeLocation.specials.rawValue:
        childLocation = ref.child("menu").child(nodeLocation.specials.rawValue)
    default:
        break
    }

    return childLocation
    
}



//func unWrapDrink(snapshot: FIRDataSnapshot, nodeKey: String) -> [MenuSpecials] {
//    
//    var itemsArr: NSArray = []
//    var menuItems: [MenuSpecials] = []
//    let menuDic = snapshot.value as! NSDictionary
//    
//    itemsArr = menuDic.object(forKey: nodeKey) as! NSArray
//    
//    for item in itemsArr  {
//        let dic = item as! NSDictionary
//        
//        let title = dic.value(forKey: strValues.title.rawValue) as! String
//        let cost = dic.value(forKey: strValues.cost.rawValue) as! String
//        
//        
//        menuItems.append(MenuSpecials.init(title: title, cost: cost))
//        
//        
//    }
//    return menuItems
//
//
//}








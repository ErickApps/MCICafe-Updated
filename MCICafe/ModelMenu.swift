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
enum node: String {
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




func unWrapMenu(snapshot: FIRDataSnapshot) -> [Menu] {
    
    
        var menuItems: [Menu] = []
        let itemsArr = snapshot.value as! NSArray
    
    
    
        for item in itemsArr  {
            let dic = item as? NSDictionary
    
            if let title = dic?.value(forKey: strValues.title.rawValue) as? String,let cost = dic?.value(forKey: strValues.cost.rawValue) as? String, let description = dic?.value(forKey: strValues.description.rawValue) as? String{
                 menuItems.append(Menu.init(description: description, title: title, cost: cost))
            }
            
            
            if (dic?.value(forKey: strValues.description.rawValue) == nil) {
                if let title = dic?.value(forKey: strValues.title.rawValue) as? String,let cost = dic?.value(forKey: strValues.cost.rawValue) as? String{
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
    case node.coffee.rawValue:
        childLocation = ref.child("menu").child("drinks").child(node.coffee.rawValue)
    case node.softDrink.rawValue:
        childLocation = ref.child("menu").child("drinks").child(node.softDrink.rawValue)
    case node.breakfast.rawValue:
        childLocation = ref.child("menu").child("food").child(node.breakfast.rawValue)
    case node.sandwich.rawValue:
        childLocation = ref.child("menu").child("food").child(node.sandwich.rawValue)
    case node.soupAndSalad.rawValue:
        childLocation = ref.child("menu").child("food").child(node.soupAndSalad.rawValue)
    case node.specials.rawValue:
        childLocation = ref.child("menu").child(node.specials.rawValue)
    default:
        break
    }

    return childLocation
    
}


func isLogIn() -> Bool {
    if FIRAuth.auth()?.currentUser != nil {
        return true
    }
    return false
}




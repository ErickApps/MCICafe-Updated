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
class Me {
    var description: String?
    var title: String?
    var cost: String?
}



func unWrapMenu(snapshot: FIRDataSnapshot, nodeKey: String) -> [Menu] {
    
        var itemsArr: NSArray = []
        var menuItems: [Menu] = []
        let menuDic = snapshot.value as! NSDictionary
    
        itemsArr = menuDic.object(forKey: nodeKey) as! NSArray
    
    
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

//func displayAlert()  {
//   
//    
//    let alertController = UIAlertController(title: "Destructive", message: "Simple alertView demo with Destructive and comfirm.", preferredStyle: UIAlertControllerStyle.alert)
//    let DestructiveAction = UIAlertAction(title: "cancel", style: UIAlertActionStyle.cancel) {
//        (result : UIAlertAction) -> Void in
//        print("Destructive")
//    }
//    
//    
//    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
//        (result : UIAlertAction) -> Void in
//        
//    }
//    
//    alertController.addAction(DestructiveAction)
//    alertController.addAction(okAction)
//    //self.presentViewController(alertController, animated: true, completion: nil)
//}

func isLogIn() -> Bool {
    if FIRAuth.auth()?.currentUser != nil {
        return true
    }
    return false
}




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


struct MenuSpecials {
    var description: String
    var title: String
    var cost: String
    
    
    
    
    init(description: String = "", title: String, cost: String) {
        self.description = description
        self.title = title
        self.cost = cost
        
        
        

        
    }
        
    
    
}
//func getMenu(nodeKey: String) -> [MenuSpecials] {
//    
////    var ref: FIRDatabaseReference!
////    
////    
////    ref = FIRDatabase.database().reference()
////    
////    ref.child("menu").observeSingleEvent(of: .value, with: { (snapshot) in
////        
////        
////        
////        let snapDic = snapshot.value as! NSDictionary
////       
////        
////        
////        })
////    { (error) in
////        print(error.localizedDescription)
////    }
////    return menuData!
//}
func unWrapMenu(snapshot: FIRDataSnapshot, nodeKey: String) -> [MenuSpecials] {
    
        var itemsArr: NSArray = []
        var menuItems: [MenuSpecials] = []
        let menuDic = snapshot.value as! NSDictionary
    
        itemsArr = menuDic.object(forKey: nodeKey) as! NSArray
    
        for item in itemsArr  {
            let dic = item as! NSDictionary
    
            let title = dic.value(forKey: strValues.title.rawValue) as! String
            let description = dic.value(forKey: strValues.description.rawValue) as! String
            
            let cost = dic.value(forKey: strValues.cost.rawValue) as! String
    
            
            menuItems.append(MenuSpecials.init(description: description, title: title, cost: cost))
            
    
    }
    return menuItems

}
func unWrapDrink(snapshot: FIRDataSnapshot, nodeKey: String) -> [MenuSpecials] {
    
    var itemsArr: NSArray = []
    var menuItems: [MenuSpecials] = []
    let menuDic = snapshot.value as! NSDictionary
    
    itemsArr = menuDic.object(forKey: nodeKey) as! NSArray
    
    for item in itemsArr  {
        let dic = item as! NSDictionary
        
        let title = dic.value(forKey: strValues.title.rawValue) as! String
        let cost = dic.value(forKey: strValues.cost.rawValue) as! String
        
        
        menuItems.append(MenuSpecials.init(title: title, cost: cost))
        
        
    }
    return menuItems


}
func isManager() -> Bool {
    var isloggedIn = false
    
    FIRAuth.auth()?.addStateDidChangeListener() { (auth, user) in
        isloggedIn = true
    }
    return isloggedIn
}








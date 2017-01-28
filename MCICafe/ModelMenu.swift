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








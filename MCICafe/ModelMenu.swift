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





var x: NSArray = []
var specialsArr: [MenuSpecials] = []





struct MenuSpecials {
    var description: String
    var title: String
    var cost: String
    
    
    
    init(description: String, title: String, cost: String) {
        self.description = description
        self.title = title
        self.cost = cost
        

        
    }
    
//    init(snapshot: FIRDataSnapshot) {
//        title = snapshot.value(forKey: "title") as! String
//        description = snapshot.value(forKey: "description") as! String
//        cost = snapshot.value(forKey: "cost") as! String
//        self.specialsRef = nil
//    }
    
    
    
    
    
    
    
}
func getSpecialMenu(snapshot: FIRDataSnapshot) -> [MenuSpecials] {
    
    
    x = snapshot.value as! NSArray
    print(x)
    
    for index in x  {
        let dic = index as! NSDictionary
        
        let title = dic.value(forKey: "title") as! String
        let description = dic.value(forKey: "description") as! String
        let cost = dic.value(forKey: "cost") as! String
        
        //            self.specialsArr.append(MenuSpecials.init(description: description, title: title, cost: cost))
        //            print(self.specialsArr)
        specialsArr.append(MenuSpecials.init(description: description, title: title, cost: cost))
        print(specialsArr)
        
    }
    
    
    
    return specialsArr
    
    
}










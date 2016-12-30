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







struct MenuSpecials {
    let description: String
    let title: String
    let cost: String
    
    
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









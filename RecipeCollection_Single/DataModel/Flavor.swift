//
//  Flavor.swift
//  RecipeCollection_Single
//
//  Created by Andy on 16/6/25.
//  Copyright © 2016年 Andy Xu. All rights reserved.
//

import Foundation
import CoreData


class Flavor: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(name: String, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("Flavor", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.name = name
    }
}

extension Flavor {
    struct Keys {
        static let Name = "name"
        static let Recipe = "recipes"
    }
}
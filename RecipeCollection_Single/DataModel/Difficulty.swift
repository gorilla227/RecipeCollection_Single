//
//  Difficulty.swift
//  RecipeCollection_Single
//
//  Created by Andy on 16/6/25.
//  Copyright © 2016年 Andy Xu. All rights reserved.
//

import Foundation
import CoreData


class Difficulty: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary: [String: AnyObject], context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("Difficulty", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        name = dictionary[Keys.Name] as? String
        level = dictionary[Keys.Level] as? NSNumber
    }
}

extension Difficulty {
    struct Keys {
        static let Name = "name"
        static let Level = "level"
    }
}
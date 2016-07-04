//
//  AuxiliaryMaterial.swift
//  RecipeCollection_Single
//
//  Created by Andy Xu on 7/1/16.
//  Copyright © 2016 Andy Xu. All rights reserved.
//

import Foundation
import CoreData


class AuxiliaryMaterial: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary: [String: AnyObject], context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("AuxiliaryMaterial", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        name = dictionary[Keys.Name] as? String
        unit = dictionary[Keys.Unit] as? String
        quantity = dictionary[Keys.Quantity] as? NSNumber
        recipe = dictionary[Keys.Recipe] as? Recipe
    }
}

extension AuxiliaryMaterial {
    struct Keys {
        static let Quantity = "quantity"
        static let Unit = "unit"
        static let Recipe = "recipe"
        static let Name = "name"
    }
}
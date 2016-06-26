//
//  Material.swift
//  RecipeCollection_Single
//
//  Created by Andy on 16/6/25.
//  Copyright © 2016年 Andy Xu. All rights reserved.
//

import Foundation
import CoreData


class Material: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary: [String: AnyObject], context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("Material", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        name = dictionary[Keys.Name] as? String
        materialType = dictionary[Keys.MaterialType] as? NSNumber
        quantity = dictionary[Keys.Quantity] as? NSNumber
        unit = dictionary[Keys.Unit] as? String
    }
}

extension Material {
    struct Keys {
        static let Name = "name"
        static let MaterialType = "materialType"
        static let Quantity = "quantity"
        static let Unit = "unit"
    }
}

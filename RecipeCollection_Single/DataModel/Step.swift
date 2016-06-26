//
//  Step.swift
//  RecipeCollection_Single
//
//  Created by Andy on 16/6/25.
//  Copyright © 2016年 Andy Xu. All rights reserved.
//

import Foundation
import CoreData


class Step: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary: [String: AnyObject], context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("Step", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        stepID = dictionary[Keys.StepID] as? NSNumber
        title = dictionary[Keys.Title] as? String
        detail = dictionary[Keys.Detail] as? String
        if let imageData = dictionary[Keys.Image] as? NSData {
            image = imageData
        }
        if let relatedRecipe = dictionary[Keys.Recipe] as? Recipe {
            recipe = relatedRecipe
        }
    }
}

extension Step {
    struct Keys {
        static let Detail = "detail"
        static let Image = "image"
        static let StepID = "stepID"
        static let Title = "title"
        static let Recipe = "recipe"
    }
}
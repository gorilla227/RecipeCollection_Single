//
//  Step+CoreDataProperties.swift
//  RecipeCollection_Single
//
//  Created by Andy on 16/7/3.
//  Copyright © 2016年 Andy Xu. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Step {

    @NSManaged var detail: String?
    @NSManaged var image: NSData?
    @NSManaged var stepID: NSNumber?
    @NSManaged var recipe: Recipe?

}

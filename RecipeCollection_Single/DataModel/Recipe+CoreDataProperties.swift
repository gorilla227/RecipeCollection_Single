//
//  Recipe+CoreDataProperties.swift
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

extension Recipe {

    @NSManaged var cookingTime: String?
    @NSManaged var cover: NSData?
    @NSManaged var creationDate: NSDate?
    @NSManaged var detailDescription: String?
    @NSManaged var forPersons: NSNumber?
    @NSManaged var modifyDate: NSDate?
    @NSManaged var name: String?
    @NSManaged var subtitle: String?
    @NSManaged var auxiliaryMaterials: NSMutableSet?
    @NSManaged var category: Category?
    @NSManaged var difficulty: Difficulty?
    @NSManaged var flavor: Flavor?
    @NSManaged var mainMaterials: NSMutableSet?
    @NSManaged var steps: NSMutableOrderedSet?

}

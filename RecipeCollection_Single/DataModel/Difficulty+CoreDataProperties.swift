//
//  Difficulty+CoreDataProperties.swift
//  RecipeCollection_Single
//
//  Created by Andy on 16/6/25.
//  Copyright © 2016年 Andy Xu. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Difficulty {

    @NSManaged var level: NSNumber?
    @NSManaged var name: String?

}

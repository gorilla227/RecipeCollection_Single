//
//  Recipe.swift
//  RecipeCollection_Single
//
//  Created by Andy on 16/6/25.
//  Copyright © 2016年 Andy Xu. All rights reserved.
//

import Foundation
import CoreData


class Recipe: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary: [String: AnyObject], context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("Recipe", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        name = dictionary[Keys.Name] as? String
        cookingTime = dictionary[Keys.CookingTime] as? String
        cover = dictionary[Keys.Cover] as? NSData
        creationDate = dictionary[Keys.CreationDate] as? NSDate
        if let modify = dictionary[Keys.ModifyDate] as? NSDate {
            modifyDate = modify
        }
        if let detail = dictionary[Keys.DetailDescription] as? String {
            detailDescription = detail
        }
        finalImage = dictionary[Keys.FinalImage] as? NSData
        forPersons = dictionary[Keys.ForPersons] as? NSNumber
        if let st = dictionary[Keys.Subtitle] as? String {
            subtitle = st
        }
        if let tip = dictionary[Keys.Tips] as? String {
            tips = tip
        }
        
        if let mainMaterialsArray = dictionary[Keys.MainMaterials] as? [MainMaterial] {
            mainMaterials = NSMutableSet(array: mainMaterialsArray)
        }
        if let auxiliaryMaterialsArray = dictionary[Keys.AuxiliaryMaterials] as? [AuxiliaryMaterial] {
            auxiliaryMaterials = NSMutableSet(array: auxiliaryMaterialsArray)
        }
        category = dictionary[Keys.Category] as? Category
        difficulty = dictionary[Keys.Difficulty] as? Difficulty
        flavor = dictionary[Keys.Flavor] as? Flavor
        
        if let stepsArray = dictionary[Keys.Steps] as? [Step] {
            steps = NSMutableOrderedSet(array: stepsArray)
        }
    }
    
    func isRecipeHaveEnoughSummary() -> Bool {
        guard name != nil else {
            return false
        }
        guard cover != nil else {
            return false
        }
        guard cookingTime != nil else {
            return false
        }
        guard category != nil else {
            return false
        }
        guard difficulty != nil else {
            return false
        }
        guard flavor != nil else {
            return false
        }
        return true
    }
}

extension Recipe {
    struct Keys {
        static let Name = "name"
        static let CookingTime = "cookingTime"
        static let Cover = "cover"
        static let CreationDate = "creationDate"
        static let DetailDescription = "detailDescription"
        static let FinalImage = "finalImage"
        static let ForPersons = "forPersons"
        static let ModifyDate = "modifyDate"
        static let Subtitle = "subtitle"
        static let Tips = "tips"
        static let AuxiliaryMaterials = "auxiliaryMaterials"
        static let MainMaterials = "mainMaterials"
        static let Category = "category"
        static let Difficulty = "difficulty"
        static let Flavor = "flavor"
        static let Steps = "steps"
    }
}
//
//  DebugData.swift
//  RecipeCollection_Single
//
//  Created by Andy on 16/6/26.
//  Copyright © 2016年 Andy Xu. All rights reserved.
//

import Foundation
import CoreData
import UIKit

extension AppDelegate: NSFetchedResultsControllerDelegate {
    
    func clearData() {
        if let entitiesByName: [String: NSEntityDescription] = managedObjectModel.entitiesByName {
            for (name, entityDescription) in entitiesByName {
                let fetchRequest = NSFetchRequest(entityName: name)
                do {
                    let fetchResult = try backgroundSaveManagedObjectContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
                    print("ClearData: \(name): \(fetchResult.count)")
                    for result in fetchResult {
                        backgroundSaveManagedObjectContext.deleteObject(result)
                    }
                } catch {
                    print("ClearData: Fetch result \(name) failed")
                    return
                }
            }
            AppDelegate.saveContext(backgroundSaveManagedObjectContext)
        }
    }
    
    /*
//    func fetchData() {
//        if let entitiesByName: [String: NSEntityDescription] = managedObjectModel.entitiesByName {
//            for (name, entityDescription) in entitiesByName {
//                let fetchRequest = NSFetchRequest(entityName: name)
//                fetchRequest.sortDescriptors = AppDelegate.sortDescriptors(name)
//                let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: backgroundSaveManagedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
//                fetchedResultsController.delegate = self
//                
//                do {
//                    try fetchedResultsController.performFetch()
//                } catch {
//                    print("Fetch \(name) failed")
//                    return
//                }
//                print(name, fetchedResultsController.fetchedObjects)
//            }
//        }
//    }
    
    func insertConfigurations() {
        let privateMOC = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        privateMOC.parentContext = backgroundSaveManagedObjectContext
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(mergeToMainManagedObjectContext(_:)), name: NSManagedObjectContextDidSaveNotification, object: nil)
        print("PrivateMOC: \(privateMOC)")
        
        // Flavors
        let flavors = ["Sweet", "Spicy", "Salt"]
        var fs = [Flavor]()
        for flavorName in flavors {
            let flavor = Flavor(name: flavorName, context: privateMOC)
            fs.append(flavor)
        }
        
        // Categories
        let categories = ["Chinese", "Korean", "American", "Japanese"]
        var cs = [Category]()
        for categoryName in categories {
            let category = Category(name: categoryName, context: privateMOC)
            cs.append(category)
        }
        
        // Difficulties
        let difficulties = [[Difficulty.Keys.Level: NSNumber(integer: 1), Difficulty.Keys.Name: "Easy"],
                            [Difficulty.Keys.Level: NSNumber(integer: 2), Difficulty.Keys.Name: "Medium"],
                            [Difficulty.Keys.Level: NSNumber(integer: 3), Difficulty.Keys.Name: "Hard"],
                            [Difficulty.Keys.Level: NSNumber(integer: 4), Difficulty.Keys.Name: "Very Hard"],
                            [Difficulty.Keys.Level: NSNumber(integer: 5), Difficulty.Keys.Name: "Master"]]
        var ds = [Difficulty]()
        for difficultyDict in difficulties {
            let difficulty = Difficulty(dictionary: difficultyDict, context: privateMOC)
            ds.append(difficulty)
        }
        
//        // MainMaterials
//        let mainMaterials = [[MainMaterial.Keys.Name: "Beef", MainMaterial.Keys.Quantity: NSNumber(double: 100.0), MainMaterial.Keys.Unit: "g"],
//                             [MainMaterial.Keys.Name: "Tomato", MainMaterial.Keys.Quantity: NSNumber(double: 2.0), MainMaterial.Keys.Unit: "Unit"]]
//        var mms = [MainMaterial]()
//        for mainMaterial in mainMaterials {
//            let mm = MainMaterial(dictionary: mainMaterial, context: privateMOC)
//            mms.append(mm)
//        }
//        
//        // AuxiliaryMaterials
//        let auxiliaryMaterials = [[AuxiliaryMaterial.Keys.Name: "Salt", AuxiliaryMaterial.Keys.Quantity: NSNumber(double: 30.0), AuxiliaryMaterial.Keys.Unit: "mg"],
//                             [AuxiliaryMaterial.Keys.Name: "Sugar", AuxiliaryMaterial.Keys.Quantity: NSNumber(double: 1.0), AuxiliaryMaterial.Keys.Unit: "tbsp"]]
//        var ams = [AuxiliaryMaterial]()
//        for auxiliaryMaterial in auxiliaryMaterials {
//            let am = AuxiliaryMaterial(dictionary: auxiliaryMaterial, context: privateMOC)
//            ams.append(am)
//        }
        
//        // Steps
//        let steps = [[Step.Keys.StepID: NSNumber(integer: 1), Step.Keys.Detail: "Step1 Detail"],
//                     [Step.Keys.StepID: NSNumber(integer: 2), Step.Keys.Detail: "Step2 Detail"]]
//        var ss = [Step]()
//        for step in steps {
//            let s = Step(dictionary: step, context: privateMOC)
//            ss.append(s)
//        }
//        
//        // Recipe
//        let recipeDict = [
//            Recipe.Keys.Name: "My first Recipe",
//            Recipe.Keys.CookingTime: "10 mins",
//            Recipe.Keys.CreationDate: NSDate(),
//            Recipe.Keys.DetailDescription: "Detail DescriptionDetail DescriptionDetail DescriptionDetail DescriptionDetail DescriptionDetail DescriptionDetail DescriptionDetail Description",
//            Recipe.Keys.ForPersons: NSNumber(integer: 2),
//            Recipe.Keys.Subtitle: "SUB TITLE",
//            Recipe.Keys.AuxiliaryMaterials: ams,
//            Recipe.Keys.MainMaterials: mms,
//            Recipe.Keys.Category: cs.first!,
//            Recipe.Keys.Difficulty: ds[1],
//            Recipe.Keys.Flavor: fs.first!,
//            Recipe.Keys.Steps: ss
//        ]
//        let recipe = Recipe(dictionary: recipeDict, context: privateMOC)
//        
//        // Add recipe to other entities
//        for mainMaterial in mms {
//            mainMaterial.recipe = recipe
//        }
//        for auxiliaryMaterial in ams {
//            auxiliaryMaterial.recipe = recipe
//        }
//        for step in ss {
//            step.recipe = recipe
//        }
        
        AppDelegate.saveContext(privateMOC)
    }
    
    func mergeToMainManagedObjectContext(notification: NSNotification) {
        print("Merger notification to MainManagedObjectContext")
        AppDelegate.mergeIntoManagedObjectContext(mainManagedObjectContext, withNotification: notification)
        AppDelegate.saveContext(backgroundSaveManagedObjectContext)
    }
    */
}
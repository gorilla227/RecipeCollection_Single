//
//  CategoryFlavorSelectionController.swift
//  RecipeCollection_Single
//
//  Created by Andy Xu on 7/16/16.
//  Copyright © 2016 Andy Xu. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "Cell"
let kCategoryFlavorDidSelected = "CategoryFlavorDidSelected"

class CategoryFlavorSelectionController: UICollectionViewController {
    @IBOutlet var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    var type: String = ""
    var newRecipe: Recipe?
    var fetchedResultsController: NSFetchedResultsController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        configureViewFlowLayout()
        collectionView?.allowsSelection = true
        collectionView?.allowsMultipleSelection = false
    }

    func configureViewFlowLayout() {
        let space: CGFloat = 5
        let numInRow: CGFloat = 3
        let width = (view.frame.size.width - (numInRow - 1) * space) / numInRow
        let height = width / 2
        collectionViewFlowLayout.itemSize = CGSizeMake(width, height)
        collectionViewFlowLayout.minimumInteritemSpacing = space
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return (fetchedResultsController?.sections?.count)!
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        let section = (fetchedResultsController?.sections![section])! as NSFetchedResultsSectionInfo
        return section.numberOfObjects
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CategoryFlavorCell
        let cellData: NSManagedObject = (fetchedResultsController?.objectAtIndexPath(indexPath))! as! NSManagedObject
        
        // Configure the cell
        switch type {
        case "Category":
            if let category = cellData as? Category {
                var isSelected = false
                if let categoryInRecipe = newRecipe?.category {
                    isSelected = categoryInRecipe.isEqual(category)
                }
                cell.configureCell(category.name, isSelected: isSelected)
            }
        case "Flavor":
            if let flavor = cellData as? Flavor {
                var isSelected = false
                if let flavorInRecipe = newRecipe?.flavor {
                    isSelected = flavorInRecipe.isEqual(flavor)
                }
                cell.configureCell(flavor.name, isSelected: isSelected)
            }
        default:
            break
        }
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        switch type {
        case "Category":
            newRecipe?.category = fetchedResultsController?.objectAtIndexPath(indexPath) as? Category
        case "Flavor":
            newRecipe?.flavor = fetchedResultsController?.objectAtIndexPath(indexPath) as? Flavor
        default:
            break
        }
        
        let notification = NSNotification(name: kCategoryFlavorDidSelected, object: fetchedResultsController?.objectAtIndexPath(indexPath))
        NSNotificationCenter.defaultCenter().postNotification(notification)
        navigationController?.popViewControllerAnimated(true)
    }

}

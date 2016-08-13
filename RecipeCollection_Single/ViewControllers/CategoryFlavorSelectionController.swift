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
    var addNewTextField: UITextField?
    
    lazy var addNewAlertController: UIAlertController = {
        let enterView = UIAlertController(title: "Add New \(self.type)", message: nil, preferredStyle: .Alert)
        enterView.addTextFieldWithConfigurationHandler { (textField: UITextField!) in
            textField.borderStyle = .None
            self.addNewTextField = textField
        }
        
        let okAction = UIAlertAction(title: "Confirm", style: .Default) { (action) in
            self.addNewAction()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        enterView.addAction(okAction)
        enterView.addAction(cancelAction)
        
        return enterView
    }()
    
    lazy var mainManagedObjectContext: NSManagedObjectContext = {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.mainManagedObjectContext
    }()
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: self.type)
        switch self.type {
        case "Category":
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: Category.Keys.Name, ascending: true)]
        case "Flavor":
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: Flavor.Keys.Name, ascending: true)]
        default:
            break
        }
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.mainManagedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        return frc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = editButtonItem()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(mergeToInsertManagedObjectContext(_:)), name: NSManagedObjectContextDidSaveNotification, object: nil)
        
        // Do any additional setup after loading the view.
        configureViewFlowLayout()
        collectionView?.allowsSelection = true
        collectionView?.allowsMultipleSelection = false
        
        setTitle()
        
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Fetch \(type) failed.")
            return
        }
    }

    func configureViewFlowLayout() {
        let space: CGFloat = 5
        let numInRow: CGFloat = 3
        let width = (view.frame.size.width - (numInRow - 1) * space) / numInRow
        let height = width / 2
        collectionViewFlowLayout.itemSize = CGSizeMake(width, height)
        collectionViewFlowLayout.minimumInteritemSpacing = space
    }
    
    private func setTitle() {
        switch type {
        case "Category":
            navigationItem.title = "Category"
        case "Flavor":
            navigationItem.title = "Flavor"
        default:
            navigationItem.title = nil
        }
    }
    
    private func addNewAction() {
        guard let newName = addNewTextField?.text where isValidCategoryFlavor(newName) else {
            let alertController = UIAlertController(title: "Can't create new \(type)!", message: "It's empty or duplicated.", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "Got it", style: .Default, handler: nil)
            alertController.addAction(okAction)
            presentViewController(alertController, animated: true, completion: nil)
            return
        }
        print(newName)
        
        switch type {
        case "Category":
            Category(name: newName, context: mainManagedObjectContext)
        case "Flavor":
            Flavor(name: newName, context: mainManagedObjectContext)
        default:
            break
        }
        AppDelegate.saveContext(mainManagedObjectContext)
    }
    
    private func isValidCategoryFlavor(name: String) -> Bool {
        if name.isEmpty {
            return false
        } else {
            let fetchRequest = NSFetchRequest(entityName: type)
            switch type {
            case "Category":
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: Category.Keys.Name, ascending: true)]
                fetchRequest.predicate = NSPredicate(format: "\(Category.Keys.Name) == %@", name)
            case "Flavor":
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: Flavor.Keys.Name, ascending: true)]
                fetchRequest.predicate = NSPredicate(format: "\(Flavor.Keys.Name) == %@", name)
            default:
                break
            }
            
            var error: NSError?
            let count = mainManagedObjectContext.countForFetchRequest(fetchRequest, error: &error)
            return count == 0
        }
    }
    
    func mergeToInsertManagedObjectContext(notification: NSNotification) {
        print("Merger notification to insertManagedObjectContext")
        if let insertManagedObjectContext = newRecipe?.managedObjectContext {
            AppDelegate.mergeIntoManagedObjectContext(insertManagedObjectContext, withNotification: notification)
        }
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
        return (fetchedResultsController.sections?.count)!
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        let section = fetchedResultsController.sections![section] as NSFetchedResultsSectionInfo
        return section.numberOfObjects
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CategoryFlavorCell
        let cellData: NSManagedObject = fetchedResultsController.objectAtIndexPath(indexPath) as! NSManagedObject
        
        // Configure the cell
        switch type {
        case "Category":
            if let category = cellData as? Category  {
                var isSelected = false
                if let categoryInRecipe = newRecipe?.category {
                    isSelected = categoryInRecipe.objectID.isEqual(category.objectID)
                }
                cell.configureCell(category.name, indexPath: indexPath, isSelected: isSelected, isEditing: editing, delegate: self)
            }
        case "Flavor":
            if let flavor = cellData as? Flavor {
                var isSelected = false
                if let flavorInRecipe = newRecipe?.flavor {
                    isSelected = flavorInRecipe.objectID.isEqual(flavor.objectID)
                }
                cell.configureCell(flavor.name, indexPath: indexPath, isSelected: isSelected, isEditing: editing, delegate: self)
            }
        default:
            break
        }
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let addFooterView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "AddFooter", forIndexPath: indexPath)
        addFooterView.hidden = !editing
        return addFooterView
    }
    
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return !editing
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        switch type {
        case "Category":
            if let category = fetchedResultsController.objectAtIndexPath(indexPath) as? Category {
                let objectID = category.objectID
                if let categoryInInsertMOC = newRecipe?.managedObjectContext?.objectWithID(objectID) as? Category {
                    categoryInInsertMOC.recipes?.addObject(newRecipe!)
                    newRecipe?.category = categoryInInsertMOC
                }
                
            }
        case "Flavor":
            if let flavor = fetchedResultsController.objectAtIndexPath(indexPath) as? Flavor {
                let objectID = flavor.objectID
                if let flavorInInsertMOC = newRecipe?.managedObjectContext?.objectWithID(objectID) as? Flavor {
                    flavorInInsertMOC.recipes?.addObject(newRecipe!)
                    newRecipe?.flavor = flavorInInsertMOC
                }
            }
        default:
            break
        }
        
        let notification = NSNotification(name: kCategoryFlavorDidSelected, object: type)
        NSNotificationCenter.defaultCenter().postNotification(notification)
        navigationController?.popViewControllerAnimated(true)
    }

    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        collectionView?.reloadData()
    }
    
    // MARK: IBActions
    @IBAction func addButtonOnClicked(sender: AnyObject) {
        if let textField = addNewTextField {
            textField.text = nil
        }
        let alertController = addNewAlertController
        alertController.view.setNeedsLayout()
        presentViewController(alertController, animated: true, completion: nil)
    }
}

extension CategoryFlavorSelectionController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        collectionView?.reloadData()
    }
}

extension CategoryFlavorSelectionController: DeleteCategoryFlavorDelegate {
    func DeleteCategoryFlavor(indexPath: NSIndexPath) {
        switch type {
        case "Category":
            if let category = fetchedResultsController.objectAtIndexPath(indexPath) as? Category {
                if category.recipes?.count == 0 {
                    if let categoryInInsertMOC = newRecipe?.category {
                        if categoryInInsertMOC.objectID.isEqual(category.objectID) {
                            newRecipe?.category = nil
                            mainManagedObjectContext.deleteObject(category)
                            
                            let notification = NSNotification(name: kCategoryFlavorDidSelected, object: type)
                            NSNotificationCenter.defaultCenter().postNotification(notification)
                        }
                    } else {
                        mainManagedObjectContext.deleteObject(category)
                    }
                }
            }
        case "Flavor":
            if let flavor = fetchedResultsController.objectAtIndexPath(indexPath) as? Flavor {
                if flavor.recipes?.count == 0 {
                    if let flavorInInsertMOC = newRecipe?.flavor {
                        if flavorInInsertMOC.objectID.isEqual(flavor.objectID) {
                            newRecipe?.flavor = nil
                            mainManagedObjectContext.deleteObject(flavor)
                            
                            let notification = NSNotification(name: kCategoryFlavorDidSelected, object: type)
                            NSNotificationCenter.defaultCenter().postNotification(notification)
                        }
                    } else {
                        mainManagedObjectContext.deleteObject(flavor)
                    }
                }
            }
        default:
            break
        }
        AppDelegate.saveContext(mainManagedObjectContext)
    }
}

//
//  NewRecipeSummaryTableViewController.swift
//  RecipeCollection_Single
//
//  Created by Andy Xu on 7/10/16.
//  Copyright © 2016 Andy Xu. All rights reserved.
//

import UIKit
import CoreData

class NewRecipeSummaryTableViewController: UITableViewController {
    
    // MARK: NSFetchedResultsControllers
    lazy var newRecipe: Recipe = {
        let entity = NSEntityDescription.entityForName("Recipe", inManagedObjectContext: self.insertManagedObjectContext)!
        let recipe = Recipe(entity: entity, insertIntoManagedObjectContext: self.insertManagedObjectContext)
        return recipe
    }()
    
    lazy var insertManagedObjectContext: NSManagedObjectContext = {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let moc = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        moc.parentContext = appDelegate.backgroundSaveManagedObjectContext
        
        return moc
    }()
    
    lazy var difficultyFRC: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: "Difficulty")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: Difficulty.Keys.Level, ascending: true)]
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.insertManagedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        return frc
    }()
    
    lazy var categoryFRC: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: "Category")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: Category.Keys.Name, ascending: true)]
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.insertManagedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        return frc
    }()
    
    lazy var flavorFRC: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: "Flavor")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: Flavor.Keys.Name, ascending: true)]
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.insertManagedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        return frc
    }()
    
    lazy var imagePicker: UIImagePickerController = {
        // Initial ImagePicker
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        return imagePicker
    }()
    
    lazy var imagePickerSelection: UIAlertController = {
        let selection = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            let cameraAction = UIAlertAction(title: "Camera", style: .Default, handler: { (action) in
                self.launchImagePicker(.Camera)
            })
            selection.addAction(cameraAction)
        }
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            let albumAction = UIAlertAction(title: "Album", style: .Default, handler: { (action) in
                self.launchImagePicker(.PhotoLibrary)
            })
            selection.addAction(albumAction)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        selection.addAction(cancelAction)
        
        return selection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 70
        
        initialRecipe()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(refreshCategoryFlavor(_:)), name: kCategoryFlavorDidSelected, object: nil)
    }
    
    func initialRecipe() {
        newRecipe.forPersons = NSNumber(integer: 1)
        initialDifficulty(1)
        
        do {
            try categoryFRC.performFetch()
        } catch {
            print("Failed to fetch Categories")
        }
        
        do {
            try flavorFRC.performFetch()
        } catch {
            print("Failed to fetch Flavors")
        }
    }
    
    func initialDifficulty(difficutlyLevel: Int) {
        do {
            try difficultyFRC.performFetch()
        } catch {
            print("Failed to fetch Difficulty data")
        }
        
        let difficulties = difficultyFRC.fetchedObjects as! [Difficulty]
        for difficulty in difficulties {
            if difficulty.level?.integerValue == difficutlyLevel {
                newRecipe.difficulty = difficulty
                break
            }
        }
    }
    
    func refreshCategoryFlavor(notification: NSNotification)  {
        if let _ = notification.object as? Category {
            tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 3)], withRowAnimation: .Automatic)
        } else if let _ = notification.object as? Flavor {
            tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 2, inSection: 3)], withRowAnimation: .Automatic)
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 1
        case 3:
            return 4
        default:
            return 0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        func defaultUITableViewCell() -> UITableViewCell {
            return UITableViewCell(style: .Default, reuseIdentifier: "Default")
        }
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0: // SummaryCell
                let cell = tableView.dequeueReusableCellWithIdentifier("SummaryCell", forIndexPath: indexPath) as! NewRecipeSummary_SummaryCell
                cell.configureCell(newRecipe)
                return cell
            default:
                return defaultUITableViewCell()
            }
        case 1: // DescriptionCell
            let cell = tableView.dequeueReusableCellWithIdentifier("DescriptionCell", forIndexPath: indexPath)
            return cell
        case 2: // DifficultyCell
            let cell = tableView.dequeueReusableCellWithIdentifier("DifficultyCell", forIndexPath: indexPath) as! NewRecipeSummary_DifficultyCell
            let difficulties = difficultyFRC.fetchedObjects as! [Difficulty]
            cell.configureCell(newRecipe, difficultyArray: difficulties)
            return cell
        case 3:
            switch indexPath.row {
            case 0: // ForPersonCell
                let cell = tableView.dequeueReusableCellWithIdentifier("ForPersonCell", forIndexPath: indexPath) as! NewRecipeSummary_ForPersonCell
                cell.configureCell(newRecipe)
                return cell
            case 1: // CategoryCell
                let cell = tableView.dequeueReusableCellWithIdentifier("CategoryFlavorCell", forIndexPath: indexPath)
                cell.textLabel?.text = "Category"
                if let category = newRecipe.category {
                    cell.detailTextLabel?.text = category.name
                }
                cell.tag = 0
                return cell
            case 2: // FlavorCell
                let cell = tableView.dequeueReusableCellWithIdentifier("CategoryFlavorCell", forIndexPath: indexPath)
                cell.textLabel?.text = "Flavor"
                if let flavor = newRecipe.flavor {
                    cell.detailTextLabel?.text = flavor.name
                }
                cell.tag = 1
                return cell
            case 3: // CookingTimeCell
                let cell = tableView.dequeueReusableCellWithIdentifier("CookingTimeCell", forIndexPath: indexPath) as! NewRecipeSummary_CookingTimeCell
                cell.configureCell(newRecipe)
                return cell
            default:
                return defaultUITableViewCell()
            }
            
        default:
            return defaultUITableViewCell()
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return "Description"
        case 2:
            return "Difficulty"
        case 3:
            return "Others"
        default:
            return nil
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let width = tableView.bounds.size.width
                let height = width * imageRatio
                return height
            default:
                return UITableViewAutomaticDimension
            }
        default:
            return UITableViewAutomaticDimension
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        switch segue.identifier! {
        case "CategoryFlavorSegue":
            if let cell = sender as? UITableViewCell {
                switch cell.tag {
                case 0: // CategorySelection
                    if let selectionController = segue.destinationViewController as? CategoryFlavorSelectionController {
                        selectionController.newRecipe = newRecipe
                        selectionController.type = "Category"
                        selectionController.fetchedResultsController = categoryFRC
                    }
                case 1: // FlavorSelection
                    if let selectionController = segue.destinationViewController as? CategoryFlavorSelectionController {
                        selectionController.newRecipe = newRecipe
                        selectionController.type = "Flavor"
                        selectionController.fetchedResultsController = flavorFRC
                    }
                default:
                    return
                }
            }
        default:
            return
        }
        
    }
    
    
    
    // MARK: IBActions
    @IBAction func cancelButtonOnClicked(sender: AnyObject) {
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func nextButtonOnClicked(sender: AnyObject) {
        print(newRecipe)
    }
    
    @IBAction func chooseCoverButtonOnClicked(sender: AnyObject) {
        presentViewController(imagePickerSelection, animated: true, completion: nil)
    }
}

// MARK: UIImagePicker Functions
extension NewRecipeSummaryTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, CropImageDelegate {
    func launchImagePicker(type: UIImagePickerControllerSourceType) {
        imagePicker.sourceType = type
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        if let summaryCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) {
            let cropImageViewController = CropImageViewController(nibName: "CropImageViewController", bundle: nil)
            cropImageViewController.delegate = self
            cropImageViewController.image = image
            cropImageViewController.cropSize = summaryCell.contentView.bounds.size
            print(cropImageViewController.cropSize)
            picker.pushViewController(cropImageViewController, animated: true)
        }
    }
    
    func CropImageCompleted(image: UIImage) {
        imagePicker.dismissViewControllerAnimated(true) { 
            if let summaryCell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as? NewRecipeSummary_SummaryCell {
                summaryCell.coverImageView.image = image
            }
        }
    }
}

extension NewRecipeSummaryTableViewController: UITextViewDelegate {
    func textViewDidChange(textView: UITextView) {
        let currentOffset = tableView.contentOffset
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
        tableView.setContentOffset(currentOffset, animated: false)
        
        newRecipe.detailDescription = textView.text
    }
}

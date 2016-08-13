//
//  NewRecipeStepsTableViewController.swift
//  RecipeCollection_Single
//
//  Created by Andy Xu on 7/28/16.
//  Copyright © 2016 Andy Xu. All rights reserved.
//

import UIKit
import CoreData

class NewRecipeStepsTableViewController: UITableViewController {

    var newRecipe: Recipe?
    var insertManagedObjectContext: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
        
        navigationItem.rightBarButtonItems?.append(editButtonItem())
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(newRecipeSaved(_:)), name: NSManagedObjectContextDidSaveNotification, object: nil)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return newRecipe?.steps?.count ?? 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StepCell", forIndexPath: indexPath) as! NewRecipeSteps_StepCell

        // Configure the cell...
        if let step = newRecipe?.steps?.objectAtIndex(indexPath.row) as? Step {
            cell.configureCell(step)
        }
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            if let step = newRecipe?.steps?.objectAtIndex(indexPath.row) as? Step {
                newRecipe?.steps?.removeObject(step)
                insertManagedObjectContext?.deleteObject(step)
                resetStepIDFrom(indexPath.row)
                
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
        }
    }

    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        if let steps = newRecipe?.steps {
            let fromIndexSet = NSIndexSet(index: fromIndexPath.row)
            steps.moveObjectsAtIndexes(fromIndexSet, toIndex: toIndexPath.row)
            resetStepIDFrom(min(fromIndexPath.row, toIndexPath.row))
            tableView.moveRowAtIndexPath(fromIndexPath, toIndexPath: toIndexPath)
            
            tableView.reloadData()
        }
    }

    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }

    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        reloadVisibleRows()
    }
    
    private func reloadVisibleRows() {
        if let indexPaths = tableView.indexPathsForVisibleRows {
            tableView.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: .Fade)
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        switch segue.identifier ?? "" {
        case "AddStepSegue":
            let destVC = segue.destinationViewController as! NewRecipeStepsDetailViewController
            destVC.delegate = self
            destVC.maximumSteps = (newRecipe?.steps?.count)! + 1
        case "ViewEditStepSegue":
            if let indexPath = tableView.indexPathForSelectedRow {
                let destVC = segue.destinationViewController as! NewRecipeStepsDetailViewController
                destVC.delegate = self
                destVC.maximumSteps = (newRecipe?.steps?.count)!
                destVC.step = newRecipe?.steps?.objectAtIndex(indexPath.row) as? Step
            }
        default:
            break
        }
    }

    @IBAction func saveButtonOnClicked(sender: AnyObject) {
        newRecipe?.creationDate = NSDate()
        
        print(newRecipe)
        AppDelegate.saveContext(insertManagedObjectContext!)
    }
    
    func newRecipeSaved(notification: NSNotification) {
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension NewRecipeStepsTableViewController: AddEditStepDelegate {
    func AddStepCompleted(stepDict: [String : AnyObject]) {
        if let steps = newRecipe?.steps {
            let newStepID = (stepDict[Step.Keys.StepID] as! NSNumber).integerValue
            
            let newStep = Step(dictionary: stepDict, context: insertManagedObjectContext!)
            newStep.recipe = newRecipe
            
            let indexSet = NSIndexSet(index: steps.count - 1)
            steps.moveObjectsAtIndexes(indexSet, toIndex: newStepID - 1)
            
            resetStepIDFrom(newStepID - 1)
            tableView.reloadData()
        }
    }
    
    func EditStepCompleted(step: Step) {
        if let steps = newRecipe?.steps {
            let oldIndex = steps.indexOfObject(step)
            let newIndex = (step.stepID?.integerValue)! - 1
            if oldIndex != newIndex {
                steps.removeObject(step)
                steps.insertObject(step, atIndex: newIndex)
                
                resetStepIDFrom(0)
            }
            tableView.reloadData()
        }
    }
    
    private func resetStepIDFrom(startIndex: Int) {
        if let steps = newRecipe?.steps where startIndex < steps.count {
            for index in startIndex...(steps.count - 1) {
                if let step = steps.objectAtIndex(index) as? Step {
                    step.stepID = NSNumber(integer: index + 1)
                }
            }
        }
    }
}

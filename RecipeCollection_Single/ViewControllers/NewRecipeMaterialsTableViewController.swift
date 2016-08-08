//
//  NewRecipeMaterialsTableViewController.swift
//  RecipeCollection_Single
//
//  Created by Andy Xu on 7/26/16.
//  Copyright © 2016 Andy Xu. All rights reserved.
//

import UIKit
import CoreData

class NewRecipeMaterialsTableViewController: UITableViewController {
    let CellIdentifier = "MaterialCell"
    var newRecipe: Recipe?
    var insertManagedObjectContext: NSManagedObjectContext?

    @IBOutlet var addMainMaterialButton: UIButton!
    @IBOutlet var addAuxiliaryMaterialButton: UIButton!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateNextButtonEnableStatus()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0: // MainMaterials
            if let materials = newRecipe?.mainMaterials {
                return materials.count
            } else {
                return 0
            }
        case 1: // AuxiliaryMaterials
            if let materials = newRecipe?.auxiliaryMaterials {
                return materials.count
            } else {
                return 0
            }
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Main Materials"
        case 1:
            return "Auxiliary Materials"
        default:
            return nil
        }
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return addMainMaterialButton
        case 1:
            return addAuxiliaryMaterialButton
        default:
            return nil
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier, forIndexPath: indexPath)

        // Configure the cell...
        switch indexPath.section {
        case 0: // Main Material
            if let material = newRecipe?.mainMaterials?.allObjects[indexPath.row] as? MainMaterial {
                cell.textLabel?.text = material.name
                cell.detailTextLabel?.text = "\(material.quantity!) \(material.unit!)"
            }
        case 1: // Auxiliary Material
            if let material = newRecipe?.auxiliaryMaterials?.allObjects[indexPath.row] as? AuxiliaryMaterial {
                cell.textLabel?.text = material.name
                cell.detailTextLabel?.text = "\(material.quantity!) \(material.unit!)"
            }
        default:
            break
        }
        return cell
    }
    
    private func updateNextButtonEnableStatus() {
//        nextButton.enabled = (newRecipe?.mainMaterials?.count > 0) && (newRecipe?.auxiliaryMaterials?.count > 0)
        nextButton.enabled = true
    }

    @IBAction func addMaterialButtonOnClicked(sender: AnyObject) {
        performSegueWithIdentifier("EnterMaterialSegue", sender: sender)
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
            switch indexPath.section {
            case 0: // Delete Main Material
                if let material = newRecipe?.mainMaterials?.allObjects[indexPath.row] as? MainMaterial {
                    newRecipe?.mainMaterials?.removeObject(material)
                    insertManagedObjectContext?.deleteObject(material)
                }
            case 1: // Delete Auxiliary Material
                if let material = newRecipe?.auxiliaryMaterials?.allObjects[indexPath.row] as? AuxiliaryMaterial {
                    newRecipe?.auxiliaryMaterials?.removeObject(material)
                    insertManagedObjectContext?.deleteObject(material)
                }
            default:
                break
            }
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            updateNextButtonEnableStatus()
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        switch segue.identifier! {
        case "EnterMaterialSegue":
            if let detailVC = segue.destinationViewController as? NewRecipeMaterialsDetailViewController {
                detailVC.delegate = self
                if let button = sender as? UIButton {
                    // Add
                    switch button {
                    case addMainMaterialButton:
                        detailVC.type = "Main"
                    case addAuxiliaryMaterialButton:
                        detailVC.type = "Auxiliary"
                    default:
                        break
                    }
                } else {
                    // View or Edit
                    if let selectedIndex = tableView.indexPathForSelectedRow {
                        switch selectedIndex.section {
                        case 0: // MainMaterial
                            if let mainMaterial = newRecipe?.mainMaterials?.allObjects[selectedIndex.row] as? MainMaterial {
                                detailVC.type = "Main"
                                detailVC.material = [MainMaterial.Keys.Name: mainMaterial.name!,
                                                     MainMaterial.Keys.Quantity: mainMaterial.quantity!,
                                                     MainMaterial.Keys.Unit: mainMaterial.unit!,
                                                     MainMaterial.Keys.Recipe: newRecipe!]
                            }
                        case 1: // AuxiliaryMaterial
                            if let auxiliaryMaterial = newRecipe?.auxiliaryMaterials?.allObjects[selectedIndex.row] as? AuxiliaryMaterial {
                                detailVC.type = "Auxiliary"
                                detailVC.material = [AuxiliaryMaterial.Keys.Name: auxiliaryMaterial.name!,
                                                     AuxiliaryMaterial.Keys.Quantity: auxiliaryMaterial.quantity!,
                                                     AuxiliaryMaterial.Keys.Unit: auxiliaryMaterial.unit!,
                                                     AuxiliaryMaterial.Keys.Recipe: newRecipe!]
                            }
                        default:
                            break
                        }
                    }
                }
            }
        case "NewRecipeSteps":
            if let destVC = segue.destinationViewController as? NewRecipeStepsTableViewController {
                destVC.newRecipe = newRecipe
                destVC.insertManagedObjectContext = insertManagedObjectContext
            }
            break
        default:
            break
        }
    }
}

extension NewRecipeMaterialsTableViewController: AddEditMaterialDelegate {
    func AddEditMaterialCompleted(material: [String : AnyObject], isNew: Bool, type: String) {
        switch type {
        case "Main":
            if isNew { // New Main Material
                let newMaterial = MainMaterial(dictionary: material, context: insertManagedObjectContext!)
                newRecipe?.mainMaterials?.addObject(newMaterial)
            } else { // Edit Main Material
                if let selectedIndex = tableView.indexPathForSelectedRow {
                    if let mainMaterial = newRecipe?.mainMaterials?.allObjects[selectedIndex.row] as? MainMaterial {
                        mainMaterial.name = material[MainMaterial.Keys.Name] as? String
                        mainMaterial.quantity = material[MainMaterial.Keys.Quantity] as? NSNumber
                        mainMaterial.unit = material[MainMaterial.Keys.Unit] as? String
                    }
                }
            }
        case "Auxiliary":
            if isNew { // New Auxiliary Material
                let newMaterial = AuxiliaryMaterial(dictionary: material, context: insertManagedObjectContext!)
                newRecipe?.auxiliaryMaterials?.addObject(newMaterial)
            } else { // Edit Auxiliary Material
                if let selectedIndex = tableView.indexPathForSelectedRow {
                    if let auxiliaryMaterial = newRecipe?.auxiliaryMaterials?.allObjects[selectedIndex.row] as? AuxiliaryMaterial {
                        auxiliaryMaterial.name = material[AuxiliaryMaterial.Keys.Name] as? String
                        auxiliaryMaterial.quantity = material[AuxiliaryMaterial.Keys.Quantity] as? NSNumber
                        auxiliaryMaterial.unit = material[AuxiliaryMaterial.Keys.Unit] as? String
                    }
                }
            }
        default:
            break
        }
        tableView.reloadData()
        updateNextButtonEnableStatus()
    }
}
//
//  RecipeDetailTableViewController.swift
//  RecipeCollection_Single
//
//  Created by Andy Xu on 7/6/16.
//  Copyright © 2016 Andy Xu. All rights reserved.
//

import UIKit

class RecipeDetailTableViewController: UITableViewController {
    @IBOutlet weak var coverImageView: UIImageView!
    
    var recipe: Recipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 88
        
        // MARK Set Title
        if recipe != nil {
            navigationItem.title = recipe?.name
            if let coverImageData = recipe?.cover {
                coverImageView.image = UIImage(data: coverImageData)
            } else {
                coverImageView.image = nil
            }
        }
        
        var headerViewFrame = tableView.tableHeaderView?.frame
        headerViewFrame?.size.height = imageRatio * tableView.bounds.size.width
        tableView.tableHeaderView?.frame = headerViewFrame!
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: // Summary
            return 1
        case 1: // Main Material
            return recipe?.mainMaterials?.count ?? 0
        case 2: // Auxiliary Material
            return recipe?.auxiliaryMaterials?.count ?? 0
        case 3: // Steps
            return recipe?.steps?.count ?? 0
        default:
            return 0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0: // Summary
            let cell = tableView.dequeueReusableCellWithIdentifier("SummaryCell", forIndexPath: indexPath) as! RecipeDetail_SummaryCell
            cell.configureCell(recipe!)
            return cell
        case 1: // Main Material
            let cell = tableView.dequeueReusableCellWithIdentifier("MaterialCell", forIndexPath: indexPath)
            let mainMaterial = recipe?.mainMaterials?.allObjects[indexPath.row] as! MainMaterial
            cell.textLabel?.text = mainMaterial.name
            cell.detailTextLabel?.text = (mainMaterial.quantity?.stringValue)! + mainMaterial.unit!
            return cell
        case 2: // Auxiliary Material
            let cell = tableView.dequeueReusableCellWithIdentifier("MaterialCell", forIndexPath: indexPath)
            let auxiliaryMaterial = recipe?.auxiliaryMaterials?.allObjects[indexPath.row] as! AuxiliaryMaterial
            cell.textLabel?.text = auxiliaryMaterial.name
            cell.detailTextLabel?.text = (auxiliaryMaterial.quantity?.stringValue)! + auxiliaryMaterial.unit!
            return cell
        case 3: // Steps
            let cell = tableView.dequeueReusableCellWithIdentifier("StepCell", forIndexPath: indexPath) as! RecipeDetail_StepCell
            let step = recipe?.steps![indexPath.row] as! Step
            cell.configureStep(step)
            return cell
        default:
            return UITableViewCell(style: .Default, reuseIdentifier: "DefaultCell")
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1: // Main Material
            return "Main Materials"
        case 2: // Auxiliary Material
            return "Auxiliary Materials"
        case 3: // Step
            return "Steps"
        default:
            return nil
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

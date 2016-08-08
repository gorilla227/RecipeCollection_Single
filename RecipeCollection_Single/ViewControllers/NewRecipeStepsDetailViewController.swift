//
//  NewRecipeStepsDetailViewController.swift
//  RecipeCollection_Single
//
//  Created by Andy on 16/7/30.
//  Copyright © 2016年 Andy Xu. All rights reserved.
//

import UIKit

protocol AddEditStepDelegate {
    func AddStepCompleted(stepDict: [String: AnyObject])
    func EditStepCompleted(step: Step)
}

class NewRecipeStepsDetailViewController: UITableViewController {
    private var stepImageCell: NewRecipeStepsDetail_StepImageCell?
    
    var maximumSteps: Int = 1
    var step: Step?
    var stepDict = [String: AnyObject]()
    var delegate: AddEditStepDelegate?
    
    lazy var imagePicker: UIImagePickerController = {
        // Initial ImagePicker
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        return imagePicker
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
        
        if let step = step {
            stepDict = step.convertToDictionary()
        } else {
            stepDict = [Step.Keys.StepID: NSNumber(integer: maximumSteps),
                        Step.Keys.Detail: ""]
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0: // Step ID
            let cell = tableView.dequeueReusableCellWithIdentifier("StepIDCell", forIndexPath: indexPath) as! NewRecipeStepsDetail_StepIDCell
            cell.configureCell(stepDict, maximum: maximumSteps)
            return cell
        case 1: // Step Image
            let cell = tableView.dequeueReusableCellWithIdentifier("StepImageCell", forIndexPath: indexPath) as! NewRecipeStepsDetail_StepImageCell
            cell.configureCell(stepDict)
            stepImageCell = cell
            return cell
        case 2: // Step Description
            let cell = tableView.dequeueReusableCellWithIdentifier("StepDescriptionCell", forIndexPath: indexPath) as! NewRecipeStepsDetail_StepDescriptionCell
            cell.configureCell(stepDict)
            return cell
        default:
            return UITableViewCell()
        }
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: // Step ID
            return "Step ID"
        case 1: // Step Image
            return "Step Image"
        case 2: // Step Description
            return "Description"
        default:
            return nil
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: // Step ID
            return 44.0
        case 1: // Step Image
            return view.bounds.width * imageRatio
        default:
            return UITableViewAutomaticDimension
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) where cell == stepImageCell {
            presentViewController(imagePickerSelection(), animated: true, completion: nil)
        }
    }
    
    func imagePickerSelection() -> UIAlertController {
        let selection = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        if stepDict[Step.Keys.Image] != nil {
            let clearAction = UIAlertAction(title: "Remove Picture", style: .Destructive, handler: { (action) in
                self.stepDict[Step.Keys.Image] = nil
                self.stepImageCell?.stepImageView?.image = nil
            })
            selection.addAction(clearAction)
        }
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
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func stepIDStepperValueChanged(sender: UIStepper) {
        stepDict[Step.Keys.StepID] = NSNumber(double: sender.value)
    }
    
    @IBAction func chooseButtonOnClicked(sender: UIButton) {
        presentViewController(imagePickerSelection(), animated: true, completion: nil)
    }
    
    @IBAction func doneButtonOnClicked(sender: AnyObject) {
        if let detail = stepDict[Step.Keys.Detail] as? String where !detail.isEmpty {
            if let delegate = delegate {
                if let step = step { // Edit Step
                    step.stepID = stepDict[Step.Keys.StepID] as? NSNumber
                    step.detail = stepDict[Step.Keys.Detail] as? String
                    step.image = stepDict[Step.Keys.Image] as? NSData
                    
                    delegate.EditStepCompleted(step)
                } else { // Add New Step
                    delegate.AddStepCompleted(stepDict)
                }
            }
            
            navigationController?.popViewControllerAnimated(true)
        } else {
            let warningAlert = UIAlertController.warningAlert("Fail", message: "You don't fill step description, please describe the step.", buttonTitle: "OK")
            presentViewController(warningAlert, animated: true, completion: nil)
        }
    }
}

extension NewRecipeStepsDetailViewController: UITextViewDelegate {
    func textViewDidChange(textView: UITextView) {
        let currentOffset = tableView.contentOffset
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
        tableView.setContentOffset(currentOffset, animated: false)
        
        stepDict[Step.Keys.Detail] = textView.text
    }
}

extension NewRecipeStepsDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, CropImageDelegate {
    func launchImagePicker(type: UIImagePickerControllerSourceType) {
        imagePicker.sourceType = type
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        let cropImageViewController = CropImageViewController(nibName: "CropImageViewController", bundle: nil)
        cropImageViewController.delegate = self
        cropImageViewController.image = image
        cropImageViewController.cropSize = (stepImageCell?.stepImageView.bounds.size)!
        picker.pushViewController(cropImageViewController, animated: true)
    }
    
    func CropImageCompleted(image: UIImage) {
        imagePicker.dismissViewControllerAnimated(true) {
            self.stepDict[Step.Keys.Image] = UIImagePNGRepresentation(image)
            self.stepImageCell?.stepImageView.image = image
        }
    }
}

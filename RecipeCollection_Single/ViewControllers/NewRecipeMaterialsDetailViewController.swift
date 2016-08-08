//
//  NewRecipeMaterialsDetailViewController.swift
//  RecipeCollection_Single
//
//  Created by Andy Xu on 7/27/16.
//  Copyright © 2016 Andy Xu. All rights reserved.
//

import UIKit

protocol AddEditMaterialDelegate {
    func AddEditMaterialCompleted(material: [String: AnyObject], isNew: Bool, type: String)
}

class NewRecipeMaterialsDetailViewController: UITableViewController {
    @IBOutlet weak var materialNameTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var unitTextField: UITextField!
    
    var type: String = ""
    var material: [String: AnyObject] = [:]
    var delegate: AddEditMaterialDelegate?
    var isNew = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if !material.isEmpty {
            switch type {
            case "Main":
                materialNameTextField.text = material[MainMaterial.Keys.Name] as? String
                quantityTextField.text = (material[MainMaterial.Keys.Quantity] as? NSNumber)?.stringValue
                unitTextField.text = material[MainMaterial.Keys.Unit] as? String
            case "Auxiliary":
                materialNameTextField.text = material[AuxiliaryMaterial.Keys.Name] as? String
                quantityTextField.text = (material[AuxiliaryMaterial.Keys.Quantity] as? NSNumber)?.stringValue
                unitTextField.text = material[AuxiliaryMaterial.Keys.Unit] as? String
            default:
                break
            }
            isNew = false
        }
    }

    private func shouldSave() -> (String, NSNumber, String)? {
        guard let materialName = materialNameTextField.text where !materialName.isEmpty else {
            return nil
        }
        
        guard let quantity = Double(quantityTextField.text ?? "") where quantity > 0 else {
            return nil
        }
        
        guard let unitName = unitTextField.text where !unitName.isEmpty else {
            return nil
        }
        
        return (materialName, NSNumber(double: quantity), unitName)
    }
    
    
    @IBAction func doneButtonOnClicked(sender: AnyObject) {
        guard let (materialName, quantity, unitName) = shouldSave() else {
            let warningAlert = UIAlertController.warningAlert("Fail", message: "You don't fill all necessary fields, please check again.", buttonTitle: "OK")
            presentViewController(warningAlert, animated: true, completion: nil)
            return
        }
        
        switch type {
        case "Main":
            material[MainMaterial.Keys.Name] = materialName
            material[MainMaterial.Keys.Quantity] = quantity
            material[MainMaterial.Keys.Unit] = unitName
        case "Auxiliary":
            material[AuxiliaryMaterial.Keys.Name] = materialName
            material[AuxiliaryMaterial.Keys.Quantity] = quantity
            material[AuxiliaryMaterial.Keys.Unit] = unitName
        default:
            break
        }
        
        if let delegate = delegate {
            delegate.AddEditMaterialCompleted(material, isNew: isNew, type: type)
        }
        
        navigationController?.popViewControllerAnimated(true)
    }

}

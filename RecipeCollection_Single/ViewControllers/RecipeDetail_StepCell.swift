//
//  RecipeDetail_StepCell.swift
//  RecipeCollection_Single
//
//  Created by Andy Xu on 7/6/16.
//  Copyright © 2016 Andy Xu. All rights reserved.
//

import UIKit

class RecipeDetail_StepCell: UITableViewCell {
    @IBOutlet weak var stepIDLabel: UILabel!
    @IBOutlet weak var stepImageView: UIImageView!
    @IBOutlet weak var stepDetailLabel: UILabel!

    func configureStep(step: Step) {
        stepIDLabel.text = "Step " + step.stepID!.stringValue
        if let imageData = step.image {
            stepImageView.image = UIImage(data: imageData)
        } else {
            stepImageView.image = nil
        }
        stepDetailLabel.text = step.detail
    }

}

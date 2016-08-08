//
//  NewRecipeStepsDetail_StepImageCell.swift
//  RecipeCollection_Single
//
//  Created by Andy on 16/7/30.
//  Copyright © 2016年 Andy Xu. All rights reserved.
//

import UIKit

class NewRecipeStepsDetail_StepImageCell: UITableViewCell {
    @IBOutlet weak var stepImageView: UIImageView!

    func configureCell(step: [String: AnyObject]) {
        if let imageData = step[Step.Keys.Image] as? NSData {
            let image = UIImage(data: imageData)
            stepImageView.image = image
        }
    }
}

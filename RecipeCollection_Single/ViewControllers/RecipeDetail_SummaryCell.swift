//
//  RecipeDetail_SummaryCell.swift
//  RecipeCollection_Single
//
//  Created by Andy Xu on 7/6/16.
//  Copyright © 2016 Andy Xu. All rights reserved.
//

import UIKit

class RecipeDetail_SummaryCell: UITableViewCell {
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var difficultyStack: UIStackView!
    @IBOutlet weak var forPersonLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var flavorLabel: UILabel!
    @IBOutlet weak var cookingTimeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        for i in 0...4 {
            let starImageView = difficultyStack.arrangedSubviews[i]
            let minStarSize = frame.size.width / 30
            let maxStarSize = frame.size.width / 25
            starImageView.heightAnchor.constraintLessThanOrEqualToConstant(maxStarSize).active = true
            starImageView.widthAnchor.constraintLessThanOrEqualToConstant(maxStarSize).active = true
            starImageView.heightAnchor.constraintGreaterThanOrEqualToConstant(minStarSize).active = true
            starImageView.widthAnchor.constraintGreaterThanOrEqualToConstant(minStarSize).active = true
        }
    }
    
    func configureCell(recipe: Recipe) {
        detailDescriptionLabel.text = recipe.detailDescription
        forPersonLabel.text = String(recipe.forPersons!.integerValue)
        categoryLabel.text = recipe.category?.name
        flavorLabel.text = recipe.flavor?.name
        cookingTimeLabel.text = recipe.cookingTime
        let difficultyLevel = recipe.difficulty?.level?.integerValue ?? 1
        for i in 0...4 {
            let starImageView = difficultyStack.arrangedSubviews[i]
            starImageView.hidden = i >= difficultyLevel
        }
    }
}

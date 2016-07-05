//
//  RecipeListTableViewCell.swift
//  RecipeCollection_Single
//
//  Created by Andy on 16/7/4.
//  Copyright © 2016年 Andy Xu. All rights reserved.
//

import UIKit
import CoreData

class RecipeListTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!

    func configureCell(recipe: Recipe) {
        titleLabel.text = recipe.name
        subtitleLabel.text = recipe.subtitle
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

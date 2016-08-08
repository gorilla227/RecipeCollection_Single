//
//  WarningAlertController.swift
//  RecipeCollection_Single
//
//  Created by Andy on 16/8/4.
//  Copyright © 2016年 Andy Xu. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    class func warningAlert(title: String?, message: String?, buttonTitle: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let ok = UIAlertAction(title: buttonTitle, style: .Cancel, handler: nil)
        alert.addAction(ok)
        return alert
    }
}
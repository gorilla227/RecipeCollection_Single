//
//  CropImageViewController.swift
//  RecipeCollection_Single
//
//  Created by Andy on 16/7/24.
//  Copyright © 2016年 Andy Xu. All rights reserved.
//

import UIKit
import AVFoundation

protocol CropImageDelegate {
    func CropImageCompleted(image: UIImage)
}

class CropImageViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var panGestureRecognizer: UIPanGestureRecognizer!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    var image: UIImage?
    var cropSize = CGSizeZero
    var actualImageFrame = CGRectZero
    var beginFrame = CGRectZero
    let maskLayer = CALayer()
    var delegate: CropImageDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = doneButton
        
        // Do any additional setup after loading the view.
        imageView.image = image
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if actualImageFrame == CGRectZero && image != nil {
            actualImageFrame = AVMakeRectWithAspectRatioInsideRect(image!.size, imageView.bounds)
            actualImageFrame.origin.x = max(actualImageFrame.origin.x, 0)
            
            initialViewController()
        }
    }
    
    private func initialViewController() {
        maskLayer.frame = CGRectMake(0, 0, cropSize.width, cropSize.height)
        maskLayer.backgroundColor = UIColor.blackColor().CGColor
        
        let backgroundLayer = CALayer()
        backgroundLayer.frame = actualImageFrame
        backgroundLayer.backgroundColor = UIColor(white: 0.0, alpha: 0.1).CGColor
        backgroundLayer.addSublayer(maskLayer)
        imageView.layer.mask = backgroundLayer
        
        panGestureRecognizer.addTarget(self, action: #selector(panGRHandler(_:)))
    }
    
    private func scaleCropRect(cropRect: CGRect, scale: CGFloat) -> CGRect {
        let t = CGAffineTransformMakeScale(scale, scale)
        let rect = CGRectApplyAffineTransform(cropRect, t)
        return rect
    }
    
    func panGRHandler(gestureRecognizer: UIPanGestureRecognizer) {
        switch gestureRecognizer.state {
        case .Began:
            beginFrame = maskLayer.frame
        case .Changed:
            let translation = gestureRecognizer.translationInView(imageView)
            let newT = CGAffineTransformMakeTranslation(translation.x, translation.y)
            let newRect = CGRectApplyAffineTransform(beginFrame, newT)
            
            let maxX = actualImageFrame.size.width - cropSize.width
            let maxY = actualImageFrame.size.height - cropSize.height
            
            let newX = max(min(newRect.origin.x, maxX), 0)
            let newY = max(min(newRect.origin.y, maxY), 0)
            maskLayer.frame = CGRectMake(newX, newY, cropSize.width, cropSize.height)
        default:
            break
        }
    }
    
    @IBAction func doneButtonOnClicked(sender: AnyObject) {
        let scale = (image?.size.width)! / actualImageFrame.width
        print("Scale: \(scale)")
        print("CropRect: \(maskLayer.frame)")
        
        print("actualImageFrame: \(actualImageFrame)")
        print("imageSize: \(image!.size)")
        let scaledCropRect = scaleCropRect(maskLayer.frame, scale: scale)
        print("ScaledCropRect: \(scaledCropRect)")
        
        let cropImageRef = CGImageCreateWithImageInRect(image?.CGImage, scaledCropRect)
        let newCropImage = UIImage(CGImage: cropImageRef!)
        if let d = delegate {
            d.CropImageCompleted(newCropImage)
        }
        
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension CropImageViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let backgroundLayer = maskLayer.superlayer {
            let location = gestureRecognizer.locationInView(imageView)
            let cropRect = backgroundLayer.convertRect(maskLayer.frame, toLayer: imageView.layer)
            return cropRect.contains(location)
        } else {
            return false
        }
    }
}

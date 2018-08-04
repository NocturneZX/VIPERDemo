//
//  UIImageViewWithMask.swift
//  ProjectStash
//
//  Created by Julio Reyes on 8/3/18.
//  Copyright © 2018 Julio Reyes. All rights reserved.
//

import UIKit

@IBDesignable
class UIImageViewWithMask: UIImageView {
    var imageToMaskView = UIImageView()
    var maskedImageView = UIImageView()
    
    @IBInspectable
    var shadowOpacity: Float = 0{
        didSet{
            layer.shadowOpacity = shadowOpacity
        }
    }
    
    @IBInspectable
    var imageToMask : UIImage? {
        didSet{
            imageToMaskView.image = imageToMask
            updateView()
        }
    }
    
    func updateView(){
        if (imageToMaskView.image != nil){
            imageToMaskView.frame = bounds
            imageToMaskView.contentMode = .scaleAspectFit
            
            maskedImageView.image = image // Mask
            maskedImageView.frame = imageToMaskView.frame
            maskedImageView.contentMode = .center
            
            imageToMaskView.layer.mask = maskedImageView.layer
            
            addSubview(imageToMaskView)
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

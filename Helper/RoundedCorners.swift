//
//  RoundedCorners.swift
//  M3 Admin
//
//  Created by Happy Sanz Tech on 03/01/20.
//  Copyright © 2020 Happy Sanz Tech. All rights reserved.
//

import UIKit

//class RoundedCorners: NSObject {
//
//
//
//}

@IBDesignable
extension UIImageView
{
    private struct AssociatedKey
    {
        static var rounded = "UIImageView.rounded"
    }

    @IBInspectable var rounded: Bool
    {
        get
        {
            if let rounded = objc_getAssociatedObject(self, &AssociatedKey.rounded) as? Bool
            {
                return rounded
            }
            else
            {
                return false
            }
        }
        set
        {
            objc_setAssociatedObject(self, &AssociatedKey.rounded, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            layer.cornerRadius = CGFloat(newValue ? 1.0 : 0.0)*min(bounds.width, bounds.height)/2
        }
    }
}

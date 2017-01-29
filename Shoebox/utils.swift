//
//  File.swift
//  Ridi
//
//  Created by Aminul Hasan on 8/19/15.
//  Copyright (c) 2015 unfaded. All rights reserved.
//

import Foundation
import UIKit


class utils {
    static func log(_ data: String = "Mr. Default") {
        let data = data
        print(data)
    }
    
    static func setClickableAction(_ image: UIImageView!, theTarget: UIViewController!, selector: Selector!) {
        let singleTap = UITapGestureRecognizer(target: theTarget, action: selector)
        singleTap.numberOfTapsRequired = 1
        image.isUserInteractionEnabled = true
        image.isMultipleTouchEnabled = true
        image.addGestureRecognizer(singleTap)
    }
}

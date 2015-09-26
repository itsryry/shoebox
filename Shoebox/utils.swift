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
    static func log(var data: String = "Mr. Default") {
        println(data)
    }
    
    static func setClickableAction(image: UIImageView!, theTarget: UIViewController!, selector: Selector!) {
        let singleTap = UITapGestureRecognizer(target: theTarget, action: selector)
        singleTap.numberOfTapsRequired = 1
        image.userInteractionEnabled = true
        image.multipleTouchEnabled = true
        image.addGestureRecognizer(singleTap)
    }
}
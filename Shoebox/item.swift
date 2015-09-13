//
//  item.swift
//  ridi
//
//  Created by Aminul Hasan on 8/18/15.
//  Copyright (c) 2015 unfaded. All rights reserved.
//

import UIKit

class item : NSObject, NSCoding, Printable {
    
    var name: String!
    var checked: Bool!
    var hasImage: Bool!
    var imagePath: String!
    var index: Int!
    override var description: String {
        return "\n name: \(name) \n checked: \(checked) \n hasImage: \(hasImage) \n imagePath: \(imagePath) \n index: \(index) \n"
    }
    
    private override init() { }
    
    required init(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObjectForKey("name") as! String
        checked = aDecoder.decodeBoolForKey("checked") as Bool
        hasImage = aDecoder.decodeBoolForKey("hasImage") as Bool
        imagePath = aDecoder.decodeObjectForKey("imagePath") as? String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey:"name");
        aCoder.encodeBool(checked, forKey:"checked");
        aCoder.encodeBool(hasImage, forKey:"hasImage");
        aCoder.encodeObject(imagePath, forKey:"imagePath");
    }
    
    convenience init(name: String!,
        checked: Bool!, hasImage: Bool!) {
            self.init()
            self.name = name
            self.checked = checked
            self.hasImage = hasImage
            self.imagePath = ""
    }
    
    convenience init(name: String!,
        checked: Bool!, hasImage: Bool!, imagePath: String!) {
            self.init()
            self.name = name
            self.checked = checked
            self.hasImage = hasImage
            self.imagePath = ""
    }
    
}

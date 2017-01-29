//
//  item.swift
//  ridi
//
//  Created by Aminul Hasan on 8/18/15.
//  Copyright (c) 2015 unfaded. All rights reserved.
//

import UIKit

class item : NSObject, NSCoding {
    
    var name: String!
    var checked: Bool!
    var hasImage: Bool!
    var imagePath: String!
    var index: Int!
    override var description: String {
        return "\n name: \(name) \n checked: \(checked) \n hasImage: \(hasImage) \n imagePath: \(imagePath) \n index: \(index) \n"
    }
    
    fileprivate override init() { }
    
    required init(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as! String
        checked = aDecoder.decodeObject(forKey: "checked") as? Bool ?? aDecoder.decodeBool(forKey: "checked")
        hasImage = aDecoder.decodeObject(forKey: "hasImage") as? Bool ?? aDecoder.decodeBool(forKey: "hasImage")
        imagePath = aDecoder.decodeObject(forKey: "imagePath") as? String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey:"name");
        aCoder.encode(checked, forKey:"checked");
        aCoder.encode(hasImage, forKey:"hasImage");
        aCoder.encode(imagePath, forKey:"imagePath");
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

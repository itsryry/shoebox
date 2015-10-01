//
//  storage.swift
//  Ridi
//
//  Created by Aminul Hasan on 8/31/15.
//  Copyright (c) 2015 unfaded. All rights reserved.
//

import Foundation

class Storage : NSObject {
    static let mainChecklist: String = "youwishy0ucouldd3cryptdizkeybits"
    static let defaultChecklist: String = "defaultchecklist"
    static var items : [item] = [
        item(name: "", checked: false, hasImage: false)
    ]
    
    private override init() { }
    
    static func initializeDefaultChecklist() {
        let defaultsAsAList = NSKeyedArchiver.archivedDataWithRootObject(items as NSArray)
        var defaultsDictionaryStoringTheList = [defaultChecklist: defaultsAsAList]
        NSUserDefaults.standardUserDefaults().registerDefaults(defaultsDictionaryStoringTheList)
    }
    
    static func saveItems(var key: String, items: [item]) {
        println("Saving items with key:\(key) and value: \(items.description)")
        let archiveItems = NSKeyedArchiver.archivedDataWithRootObject(items as NSArray)
        let storage = NSUserDefaults.standardUserDefaults()
        storage.setObject(archiveItems, forKey: key)
        storage.synchronize()
    }
    
    static func getItems(var key: String) -> [item]? {
        println("Getting items with key:\(key)")
        if let archivedItems = NSUserDefaults.standardUserDefaults().objectForKey(key) as? NSData {
            return NSKeyedUnarchiver.unarchiveObjectWithData(archivedItems) as? [item]
        } else {
            var defaultlist: NSData = NSUserDefaults.standardUserDefaults().objectForKey(key) as! NSData
            return NSKeyedUnarchiver.unarchiveObjectWithData(defaultlist) as? [item]
        }
    }
    
    static func getItems(var key: String, _default: [item]) -> [item]? {
        println("Getting items with key:\(key)")
        if let archivedItems = NSUserDefaults.standardUserDefaults().objectForKey(key) as? NSData {
            return NSKeyedUnarchiver.unarchiveObjectWithData(archivedItems) as? [item]
        } else {
            return _default
        }
    }
    
    static func updateItem(var key: String, var theItem: item) {
        println("Updating items with key:\(key) with model: \(theItem.description)")
        var items: [item] = getItems(key)!
        items[theItem.index] = theItem
        saveItems(key, items: items)
    }
}
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
    
    fileprivate override init() { }
    
    static func initializeDefaultChecklist() {
        let defaultsAsAList = NSKeyedArchiver.archivedData(withRootObject: items as NSArray)
        let defaultsDictionaryStoringTheList = [defaultChecklist: defaultsAsAList]
        UserDefaults.standard.register(defaults: defaultsDictionaryStoringTheList)
    }
    
    static func saveItems(_ key: String, items: [item]) {
        let key = key
        print("Saving items with key:\(key) and value: \(items.description)")
        let archiveItems = NSKeyedArchiver.archivedData(withRootObject: items as NSArray)
        let storage = UserDefaults.standard
        storage.set(archiveItems, forKey: key)
        storage.synchronize()
    }
    
    static func getItems(_ key: String) -> [item]? {
        let key = key
        print("Getting items with key:\(key)")
        if let archivedItems = UserDefaults.standard.object(forKey: key) as? Data {
            return NSKeyedUnarchiver.unarchiveObject(with: archivedItems) as? [item]
        } else {
            let defaultlist: Data = UserDefaults.standard.object(forKey: key) as! Data
            return NSKeyedUnarchiver.unarchiveObject(with: defaultlist) as? [item]
        }
    }
    
    static func getItems(_ key: String, _default: [item]) -> [item]? {
        let key = key
        print("Getting items with key:\(key)")
        if let archivedItems = UserDefaults.standard.object(forKey: key) as? Data {
            return NSKeyedUnarchiver.unarchiveObject(with: archivedItems) as? [item]
        } else {
            return _default
        }
    }
    
    static func updateItem(_ key: String, theItem: item) {
        let key = key, theItem = theItem
        print("Updating items with key:\(key) with model: \(theItem.description)")
        var items: [item] = getItems(key)!
        items[theItem.index] = theItem
        saveItems(key, items: items)
    }
}

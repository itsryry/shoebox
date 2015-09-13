//
//  checklist.swift
//  ridi
//
//  Created by Aminul Hasan on 8/6/15.
//  Copyright (c) 2015 unfaded. All rights reserved.
//



import UIKit

class addCell: UITableViewCell {
    @IBOutlet
    var add: UIButton!
}

class checkboxCell : UITableViewCell {
    @IBOutlet
    weak var wish: UITextField!
    
    @IBOutlet
    weak var switcher: UISwitch!
    
    @IBOutlet
    weak var wishImage: UIImageView?
}

class PurpleUITextField : UITextField {
    override func awakeFromNib() {
        layer.borderWidth = 1.0
        layer.borderColor = UIColor(red:0, green:153, blue:255, alpha:1).CGColor
    }
}

protocol CellCommander {
    func cell(tableView: UITableView, cellAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
}

class checklist : UITableViewController, CellCommander {

    var items : [item] = [
        item(name: "Vegas ferris wheel", checked: false, hasImage: false),
        item(name: "Greece", checked:false, hasImage:false),
        item(name: "Miami", checked:false, hasImage:false),
        item(name: "New York", checked:false, hasImage:false)
    ]
    var selectedItem : item?
    var listkey: String! = Storage.defaultChecklist
    
    let checkboxcellid: String = "checkcell"
    let addcellid: String = "addcellid"
    
    var cellCommander: CellCommander!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        items = Storage.getItems(Storage.defaultChecklist)!
        listkey = Storage.defaultChecklist
        
        tableView.backgroundColor = UIColor(red:0.0, green:0.0, blue: 0.0, alpha:1.0)
        
        var cboxNib = UINib(nibName: "checkboxcell", bundle: nil)
        var addNib = UINib(nibName: "addcell", bundle: nil)
        
        tableView?.registerNib(cboxNib, forCellReuseIdentifier: checkboxcellid)
        tableView?.registerNib(addNib, forCellReuseIdentifier: addcellid)
        navigationItem.title = "checklist".titles
        
        var addButton = UIBarButtonItem(image: nil, style: UIBarButtonItemStyle.Plain, target:self, action:Selector("addCheckboxCell:"))
        addButton.title = "Add"
        navigationItem.rightBarButtonItem = addButton
        
        cellCommander = self as CellCommander
        
        UITextField.appearance().layer.borderWidth = 2.0
        UITextField.appearance().layer.borderColor =  UIColor( red: 0.5, green: 0.0, blue:0, alpha: 1.0 ).CGColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView?.setEditing(editing, animated: animated)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func cell(tableView: UITableView, cellAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: checkboxCell = tableView.dequeueReusableCellWithIdentifier(checkboxcellid) as! checkboxCell
        
        cell.switcher.on = items[indexPath.row].checked
        
        if items[indexPath.row].name == "newItem".defaults {
            cell.wish.placeholder = "newItem".defaults
        } else {
            cell.wish.text = items[indexPath.row].name
        }
        items[indexPath.row].index = indexPath.row
        
        cell.switcher.tag = indexPath.row
        cell.switcher.addTarget(self, action:Selector("switchValueChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        
        cell.wish.tag = indexPath.row
        cell.wish.addTarget(self, action:Selector("textValueChanged:"), forControlEvents: UIControlEvents.EditingChanged)
        cell.wish.addTarget(self, action:Selector("onBeginEditing:"), forControlEvents: UIControlEvents.EditingDidBegin)
        UITextField.appearance().layer.borderWidth = 2.0
        UITextField.appearance().layer.borderColor = UIColor.purpleColor().CGColor
        return cell
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return cellCommander.cell(tableView, cellAtIndexPath: indexPath)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("You selectd cell #\(indexPath.row)!")
        selectedItem = items[indexPath.row]
        performSegueWithIdentifier("detail", sender: self)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle: UITableViewCellEditingStyle,
        forRowAtIndexPath indexPath: NSIndexPath) {
        if commitEditingStyle == UITableViewCellEditingStyle.Delete {
            println("Deleting cell at #\(indexPath.row)")
            items.removeAtIndex(indexPath.row)
            tableView.reloadData()
            
            Storage.saveItems(listkey!, items: items)
        } else if commitEditingStyle == UITableViewCellEditingStyle.Insert {
            
        }
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        if tableView.cellForRowAtIndexPath(indexPath) is addCell {
            return UITableViewCellEditingStyle.None
        } else {
            return UITableViewCellEditingStyle.Delete
        }
    }
    
    func loadItems(var key: String, var _default: [item]) {
        listkey = key
        items = Storage.getItems(listkey!, _default: _default) as [item]!;
        tableView?.reloadData()
    }
    
    func saveItems(var key: String) {
        Storage.saveItems(key, items: items);
    }
    
    @IBAction
    func addCheckboxCell(sender: AnyObject) {
        items += [item(name:"", checked:false, hasImage:false)]
        tableView?.reloadData()
        tableView.scrollToRowAtIndexPath(NSIndexPath(forRow:items.count - 1, inSection:0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
    }
    
    func switchValueChanged(sender: UISwitch!) {
        items[sender.tag].checked = sender.on
        Storage.saveItems(listkey!, items: items)
    }
    
    func textValueChanged(sender: UITextField) {
        items[sender.tag].name = sender.text
        Storage.saveItems(listkey!, items: items)
    }
    
    func onBeginEditing(sender: UITextField!) {
        if sender.text == "Bucket item!" {
            sender.text = ""
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detail" {
            if let checklistDetail = segue.destinationViewController as? checklistDetail {
                checklistDetail.itemModel = selectedItem
            }
        }
    }
}



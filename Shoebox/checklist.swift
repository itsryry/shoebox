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
    weak var switcher: UIImageView!
    
    @IBOutlet
    weak var wishImage: UIImageView?
}

class PurpleUITextField : UITextField {
    override func awakeFromNib() {
        layer.borderWidth = 2.0
        borderStyle = UITextBorderStyle.roundedRect
        layer.cornerRadius = 5
        clipsToBounds = true
        layer.borderColor = UIColor(red:0, green:153, blue:255, alpha:1).cgColor
    }
}

protocol CellCommander {
    func cell(_ tableView: UITableView, cellAtIndexPath indexPath: IndexPath) -> UITableViewCell
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
        
        let cboxNib = UINib(nibName: "checkboxcell", bundle: nil)
        let addNib = UINib(nibName: "addcell", bundle: nil)
        
        tableView?.register(cboxNib, forCellReuseIdentifier: checkboxcellid)
        tableView?.register(addNib, forCellReuseIdentifier: addcellid)
        navigationItem.title = "checklist".titles
        
        let addButton = UIBarButtonItem(image: nil, style: UIBarButtonItemStyle.plain, target:self, action:#selector(checklist.addCheckboxCell(_:)))
        addButton.title = "Add"
        navigationItem.rightBarButtonItem = addButton
        
        cellCommander = self as CellCommander
        
        UITextField.appearance().layer.borderWidth = 2.0
        UITextField.appearance().layer.borderColor =  UIColor( red: 0.5, green: 0.0, blue:0, alpha: 1.0 ).cgColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView?.setEditing(editing, animated: animated)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func cell(_ tableView: UITableView, cellAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell: checkboxCell = tableView.dequeueReusableCell(withIdentifier: checkboxcellid) as! checkboxCell

        toggleImage(items[(indexPath as NSIndexPath).row], imageView: cell.switcher)
        utils.setClickableAction(cell.switcher, theTarget:self, selector:#selector(checklist.switchValueChanged(_:)))
        
        if items[(indexPath as NSIndexPath).row].name == "newItem".defaults {
            cell.wish.placeholder = "newItem".defaults
        } else {
            cell.wish.text = items[(indexPath as NSIndexPath).row].name
        }
        items[(indexPath as NSIndexPath).row].index = (indexPath as NSIndexPath).row
        
        cell.switcher.tag = (indexPath as NSIndexPath).row
        cell.wish.tag = (indexPath as NSIndexPath).row
        cell.wish.addTarget(self, action:#selector(checklist.textValueChanged(_:)), for: UIControlEvents.editingChanged)
        cell.wish.addTarget(self, action:#selector(checklist.onBeginEditing(_:)), for: UIControlEvents.editingDidBegin)
        UITextField.appearance().layer.borderWidth = 2.0
        UITextField.appearance().layer.borderColor = UIColor.purple.cgColor
        return cell
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellCommander.cell(tableView, cellAtIndexPath: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selectd cell #\((indexPath as NSIndexPath).row)!")
        selectedItem = items[(indexPath as NSIndexPath).row]
        performSegue(withIdentifier: "detail", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, commit commitEditingStyle: UITableViewCellEditingStyle,
        forRowAt indexPath: IndexPath) {
        if commitEditingStyle == UITableViewCellEditingStyle.delete {
            print("Deleting cell at #\((indexPath as NSIndexPath).row)")
            items.remove(at: (indexPath as NSIndexPath).row)
            tableView.reloadData()
            
            Storage.saveItems(listkey!, items: items)
        } else if commitEditingStyle == UITableViewCellEditingStyle.insert {
            Storage.saveItems(listkey!, items: items)
        }
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if tableView.cellForRow(at: indexPath) is addCell {
            return UITableViewCellEditingStyle.none
        } else {
            return UITableViewCellEditingStyle.delete
        }
    }
    
    func loadItems(_ key: String, _default: [item]) {
        var key = key, _default = _default
        listkey = key
        items = Storage.getItems(listkey!, _default: _default) as [item]!;
        tableView?.reloadData()
    }
    
    func saveItems(_ key: String) {
        let key = key
        Storage.saveItems(key, items: items);
    }
    
    @IBAction
    func addCheckboxCell(_ sender: AnyObject) {
        tableView?.beginUpdates()
        items += [item(name:"", checked:false, hasImage:false)]
        let newIndexPath: IndexPath = IndexPath(row: items.count - 1, section:0)
        tableView?.insertRows(at: [newIndexPath], with:UITableViewRowAnimation.top)
        tableView?.endUpdates()
        tableView.scrollToRow(at: IndexPath(row:items.count - 1, section:0), at: UITableViewScrollPosition.bottom, animated: true)
        Storage.saveItems(listkey!, items: items)
    }
    
    func switchValueChanged(_ sender: AnyObject) {
        if let tapGestureRecognizer = sender as? UITapGestureRecognizer {
            if let image = tapGestureRecognizer.view as? UIImageView {
                items[image.tag].checked = !(items[image.tag].checked)
                toggleImage(items[image.tag], imageView: image)
                Storage.saveItems(listkey!, items: items)
            }
        }
    }
    
    func textValueChanged(_ sender: UITextField) {
        items[sender.tag].name = sender.text
        Storage.saveItems(listkey!, items: items)
    }
    
    func onBeginEditing(_ sender: UITextField!) {
        if sender.text == "Bucket item!" {
            sender.text = ""
        }
    }
    
    func toggleImage(_ theItem: item!, imageView: UIImageView!) {
        if theItem.checked! {
            imageView.alpha = 0
            UIView.animate(withDuration: 0.1, animations:{ imageView.alpha = 1.0 })

            let bounceAnimation : CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
            bounceAnimation.values = [1.5, 0.9, 1.2, 1.0]
            bounceAnimation.keyTimes = [0.0, 0.5, 0.75, 1.0]
            bounceAnimation.duration = 0.5

            imageView.layer.add(bounceAnimation, forKey: "bounce")
            imageView.image = UIImage(named: "heart_selected.png")
        } else {
            UIView.animate(withDuration: 0.1, animations:{ imageView.alpha = 1.0 })
            
            let bounceAnimation : CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
            bounceAnimation.values = [1.5, 0.9, 1.2, 1.0]
            bounceAnimation.keyTimes = [0.0, 0.5, 0.75, 1.0]
            bounceAnimation.duration = 0.3
            
            imageView.layer.add(bounceAnimation, forKey: "bounce")
            imageView.image = UIImage(named: "heart_unselected.png")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail" {
            if let checklistDetail = segue.destination as? checklistDetail {
                checklistDetail.itemModel = selectedItem
            }
        }
    }
}



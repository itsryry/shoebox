//
//  checklistDetail.swift
//  ridi
//
//  Created by Aminul Hasan on 8/18/15.
//  Copyright (c) 2015 unfaded. All rights reserved.
//

import Foundation
import UIKit


class checklistDetail : UIViewController, UIImagePickerControllerDelegate,
    UINavigationControllerDelegate, UITableViewDelegate, CellCommander {
    
    let IMAGE_PATH_PREFIX : String! = "checklist-"
    
    var itemModel: item!
    var list: checklist!
    
    @IBOutlet weak
    var addImage: UIButton!
    @IBOutlet weak
    var image: UIImageView!
    @IBOutlet weak
    var itemDescription: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = itemModel.name
        list = childViewControllers[0] as! checklist
        list.listkey = toString(itemModel.index)
        list.loadItems(toString(itemModel.index), _default: Storage.items)
        list.tableView.delegate = self
        list.cellCommander = self
        
        var addButton = UIBarButtonItem(image: nil, style: UIBarButtonItemStyle.Plain, target:list, action:Selector("addCheckboxCell:"))
        addButton.title = "Add"
        navigationItem.rightBarButtonItem = addButton
        
        if itemModel.imagePath != nil {
            loadBucketItemImage()
        }
        
        view.backgroundColor = UIColor.blackColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction
    func onItemImageClick(sender: AnyObject) {
        if sender.tag == 0 {
            launchImagePickerController()
        }
    }
    
    func launchImagePickerController() {
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.allowsEditing = false

        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        image.image = (info[UIImagePickerControllerOriginalImage] as! UIImage)
        let singleTap = UITapGestureRecognizer(target: self, action: Selector("imageTapped"))
        singleTap.numberOfTapsRequired = 2
        image.userInteractionEnabled = true
        image.addGestureRecognizer(singleTap)
        
        addImage.hidden = true
        self.dismissViewControllerAnimated(true, completion: nil)
        
        saveBucketItemImage()
    }
    
    func imageTapped() {
        launchImagePickerController()
    }
    
    func saveBucketItemImage() {
        let nsDocumentDirectory = NSSearchPathDirectory.DocumentDirectory
        let nsUserDomainMask = NSSearchPathDomainMask.UserDomainMask
        if let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true) {
            if paths.count > 0 {
                if let dirPath = paths[0] as? String {
                    let writePath = dirPath.stringByAppendingPathComponent("\(IMAGE_PATH_PREFIX)\(itemModel.index).png")
                    UIImagePNGRepresentation(self.image.image).writeToFile(writePath, atomically: true)
                    itemModel.imagePath = writePath
                    Storage.updateItem(Storage.defaultChecklist, theItem: itemModel)
                }
            }
        }
    }
    
    func loadBucketItemImage() {
        image.image = UIImage(named: itemModel.imagePath)
        if image.image != nil {
            addImage.hidden = true
        }
    }
    
    func cell(tableView: UITableView, cellAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellCommander: CellCommander = list as CellCommander
        var cell: UITableViewCell = cellCommander.cell(tableView, cellAtIndexPath: indexPath)
        cell.accessoryType = UITableViewCellAccessoryType.None
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("You selectd cell #\(indexPath.row)!")
    }

}
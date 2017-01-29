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
        list.listkey = String(itemModel.index)
        list.loadItems(String(itemModel.index), _default: Storage.items)
        list.tableView.delegate = self
        list.cellCommander = self
        
        let addButton = UIBarButtonItem(image: nil, style: UIBarButtonItemStyle.plain, target:list, action:Selector(("addCheckboxCell:")))
        addButton.title = "Add"
        navigationItem.rightBarButtonItem = addButton
        
        if itemModel.imagePath != nil {
            loadBucketItemImage()
        }
        
        view.backgroundColor = UIColor.black
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction
    func onItemImageClick(_ sender: AnyObject) {
        if sender.tag == 0 {
            launchImagePickerController()
        }
    }
    
    func launchImagePickerController() {
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = false

        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [AnyHashable: Any]) {
        image.image = (info[UIImagePickerControllerOriginalImage] as! UIImage)
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(checklistDetail.imageTapped))
        singleTap.numberOfTapsRequired = 2
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(singleTap)
        
        addImage.isHidden = true
        self.dismiss(animated: true, completion: nil)
        
        saveBucketItemImage()
    }
    
    func imageTapped() {
        launchImagePickerController()
    }
    
    func saveBucketItemImage() {
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let imageurl: URL = URL(fileURLWithPath: dirPath)
        let writePath = imageurl.appendingPathComponent("\(IMAGE_PATH_PREFIX)\(itemModel.index).png")
        try! UIImagePNGRepresentation(self.image.image!)?.write(to: writePath, options: .atomic)
        itemModel.imagePath = writePath.absoluteString
        Storage.updateItem(Storage.defaultChecklist, theItem: itemModel)
    }
    
    func loadBucketItemImage() {
        image.image = UIImage(named: itemModel.imagePath)
        if image.image != nil {
            addImage.isHidden = true
        }
    }
    
    func cell(_ tableView: UITableView, cellAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        var cellCommander: CellCommander = list as CellCommander
        var cell: UITableViewCell = cellCommander.cell(tableView, cellAtIndexPath: indexPath)
        cell.accessoryType = UITableViewCellAccessoryType.none
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selectd cell #\((indexPath as NSIndexPath).row)!")
    }

}

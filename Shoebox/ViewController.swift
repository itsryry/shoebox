//
//  ViewController.swift
//  ridi
//
//  Created by Aminul Hasan on 8/4/15.
//  Copyright (c) 2015 unfaded. All rights reserved.
//

import UIKit

class ViewController : UIViewController {
    
    @IBOutlet
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
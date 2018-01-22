//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Bryan's Air on 1/4/18.
//  Copyright © 2018 Bryborg Inc. All rights reserved.
//

import UIKit

class MemeTableViewController : UITableViewController {
    
    // MARK: Properties
    
    // For the table, This is an array of meme instances
    
    var memes: [Meme]!
    /// get memes
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
    }
}

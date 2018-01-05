//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Bryan's Air on 1/4/18.
//  Copyright © 2018 Bryborg Inc. All rights reserved.
//

import UIKit

class MemeTableViewController : UITableViewController {
    
    // outlet lesson 8: slide 4
    //? Maybe ... something like @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memes: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
    }
}

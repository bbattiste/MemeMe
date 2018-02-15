//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Bryan's Air on 1/4/18.
//  Copyright © 2018 Bryborg Inc. All rights reserved.
//

import UIKit

class MemeTableViewController : UITableViewController {
    
    // MARK: Life Cycle
    
    // For the table, This is an array of meme instances
    var memes: [Meme]!
    
//    override func viewWillAppear(_ animated: Bool) {
//        // update memes array with new data
//        self.tableView.reloadData()
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        memes = appDelegate.memes
//    }

    override func viewDidAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        self.tableView.reloadData()
    }
    
    // get memes
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
    
        // Add plus sign for the add symbol
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem(rawValue: 4)!, target: self, action: #selector(MemeTableViewController.addMeme))
    }
        //MARK: Add Meme
        
        @objc func addMeme() {
            // Create a instance of Destination View Controller
            let memeEditViewController = storyboard?.instantiateViewController(withIdentifier: "MemeEdit") as! ViewController
            
            // Pass the created instance to current navigation stack
            present(memeEditViewController, animated: true, completion: nil)
    }
    
    // MARK: Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("tableView numberOfRowsInSection: \(self.memes.count)")
        return self.memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell")!
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        // Set the label and image
        cell.textLabel?.text = "\(meme.topText!)...\(meme.bottomText!)"
        cell.imageView?.image = meme.memedImage
        
        print("tableView cell text nil? \(cell.textLabel?.text == nil)")
        print("tableView cell image nil? \(cell.imageView?.image == nil)")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Grab the DetailVC from Storyboard
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        
        //Populate view controller with data from the selected item
        detailController.meme = self.memes[(indexPath as NSIndexPath).row]
        
        // Present the view controller using navigation
        self.navigationController!.pushViewController(detailController, animated: true)
    }
}

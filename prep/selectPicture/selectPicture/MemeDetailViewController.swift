//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Bryan's Air on 1/12/18.
//  Copyright © 2018 Bryborg Inc. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    // MARK: Properties
    
    var meme: Meme!
    
    // MARK: Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.imageView!.image = self.meme.memedImage
        self.tabBarController?.tabBar.isHidden = true
    }
    
    //MARK: Edit Meme: will come back to
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.plain, target: self, action: #selector(MemeDetailViewController.editMeme))
//    }
//    
//    @objc func editMeme() {
//        // Create a instance of Destination View Controller
//        let memeEditViewController = storyboard?.instantiateViewController(withIdentifier: "MemeEdit") as! ViewController
//        
//        // Pass the created instance to current navigation stack
//        present(memeEditViewController, animated: true, completion: nil)
//    }
}

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
    }
}

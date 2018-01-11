//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Bryan's Air on 1/4/18.
//  Copyright © 2018 Bryborg Inc. All rights reserved.
//

import UIKit

class MemeCollectionViewController : UICollectionViewController {
    
    // outlet lesson 8: slide 4
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memes: [Meme]!
    
    override func viewDidLoad() {
         super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VillainCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        let memeInCell = self.memes[(indexPath as NSIndexPath).row]
        
        // Set the 2 labels and image in MemeCollectionViewCell
        cell.topLabel.text = memeInCell.topText
        cell.bottomLabel.text = memeInCell.bottomText
        cell.selectedImage?.image = memeInCell.originalImage
        
        return cell
    }
    
    
}

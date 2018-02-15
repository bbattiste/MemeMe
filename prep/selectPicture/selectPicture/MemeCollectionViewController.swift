//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Bryan's Air on 1/4/18.
//  Copyright © 2018 Bryborg Inc. All rights reserved.
//

import UIKit

class MemeCollectionViewController : UICollectionViewController {
    
    // MARK: Outlets
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    // Mark: Properties
    var memes: [Meme]!
    
    // MARK: Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = false
        
        // update memes array with new data
        self.collectionView?.reloadData()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0

        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem(rawValue: 4)!, target: self, action: #selector(MemeCollectionViewController.addMeme))
    }
    //MARK: Add Meme
    
    @objc func addMeme() {
        // Create a instance of Destination View Controller
        let memeEditViewController = storyboard?.instantiateViewController(withIdentifier: "MemeEdit") as! ViewController
        
        // Pass the created instance to current navigation stack
        present(memeEditViewController, animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        let memeInCell = self.memes[(indexPath as NSIndexPath).row]
        
        // Set the image in MemeCollectionViewCell
        cell.imageView?.image = memeInCell.memedImage
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        
        // Grab the DetailVC from Storyboard
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        
        //Populate view controller with data from the selected item
        detailController.meme = self.memes[(indexPath as NSIndexPath).row]
        
        // Present the view controller using navigation
        self.navigationController!.pushViewController(detailController, animated: true)
    }
}

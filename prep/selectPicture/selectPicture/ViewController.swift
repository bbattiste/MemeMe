//
//  ViewController.swift
//  selectPicture
//
//  Created by Bryan's Air on 8/21/17.
//  Copyright © 2017 Bryborg Inc. All rights reserved.
//

import Foundation
import UIKit

class ViewController: UIViewController {

    // MARK: Outlets and variables
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var textFieldTop: UITextField!
    @IBOutlet weak var textFieldBottom: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var cameraRoll: UIBarButtonItem!
    
    var memedImage: UIImage!
    
    // textfield attributes dictionary to format text
    let memeTextAttributes:[String:Any] = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 30)!,
        NSStrokeWidthAttributeName: -7.5]
        // possibly add NSParagraphStyleAttributeName: NSParagraphStyle()]
    
    // assign attributes to textfields and align center
    func configureText(textField: UITextField) {
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.delegate = self
        textField.sizeToFit()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureText(textField: textFieldTop)
        configureText(textField: textFieldBottom)
    }
    
    // check if camera is available and disable share button until image is picked
    override func viewWillAppear(_ animated: Bool) {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
        
        if imagePickerView.image == nil {
            shareButton.isEnabled = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    
    // pushes image up when editing with keyboard in bottom textfield
    func keyboardWillShow(_ notification: Notification) {
        if textFieldBottom.isEditing {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
        if textFieldTop.isEditing {
            view.frame.origin.y = 0
        }
    }
    
    // pulls image to original frame when keyboard is removed
    func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    // pick an image from photo album
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        chooseSourceType(sourceType: .photoLibrary)
    }
    
    // access camera to take picture for app
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        chooseSourceType(sourceType: .camera)
    }
    
    
    // make way to hide utility bars when needed (for memed image)
    func hideUtilityBars (hide: Bool) {
        navBar.isHidden = hide
        toolBar.isHidden = hide
    }
    
    func generateMemedImage() -> UIImage {
        
        // Hide toolbar and navbar
        hideUtilityBars(hide: true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        hideUtilityBars(hide: false)
        
        return memedImage
    }
    
    
    // access activityViewController to share Meme
    @IBAction func shareMeme(_ sender: Any) {
        memedImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
        
        // completion handler used for activity view completion
        activityViewController.completionWithItemsHandler = { (activityType: UIActivityType?, completed: Bool, returnedItemds: [Any]?, error: Error?) -> Void in
            if completed {
                self.save()
            }
        }
    }
    
    // I assume this code is for something in a later lesson, does nothing functionable right now.  Image saves through
    // activityViewController by save feature in shareMemefunction
    func save() {
        if textFieldTop.text == nil || textFieldBottom.text == nil || imagePickerView.image == nil {
            return
        }
        
        // create the meme
        let meme = Meme(topText: textFieldTop.text!, bottomText: textFieldBottom.text!, originalImage: imagePickerView.image!, memedImage: memedImage)
        print("saving Meme")
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    // code i want to save for later
    //    override var prefersStatusBarHidden: Bool {
    //        return true
    //    }
    
}


extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    // function to access image and enable share button
    func chooseSourceType(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
        shareButton.isEnabled = true
    }
    
    // MARK: ImagePickerControllerDelegate Functions
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}


extension ViewController:  UITextFieldDelegate {
    // gets rid of default text when starting to edit textfield
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    // allows textfield to stop editing and return to app
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}

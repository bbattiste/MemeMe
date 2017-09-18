//
//  ViewController.swift
//  selectPicture
//
//  Created by Bryan's Air on 8/21/17.
//  Copyright © 2017 Bryborg Inc. All rights reserved.
//

import Foundation
import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    // MARK: Outlets
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var textFieldTop: UITextField!
    @IBOutlet weak var textFieldBottom: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var cameraRoll: UIBarButtonItem!
    
    var memedImage: UIImage!
    
    //set textfield attribute dictionary
    let memeTextAttributes:[String:Any] = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 23)!,
        NSStrokeWidthAttributeName: -7.5]
        //NSParagraphStyleAttributeName: NSParagraphStyle()]
    
    // assign attributes to textfields and align center
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldTop.defaultTextAttributes = memeTextAttributes
        textFieldTop.textAlignment = .center
        textFieldTop.delegate = self
        
        textFieldBottom.defaultTextAttributes = memeTextAttributes
        textFieldBottom.textAlignment = .center
        textFieldBottom.delegate = self
    }
    
    // check if camera is available
    override func viewWillAppear(_ animated: Bool) {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if textFieldTop.text == "" {
//            textFieldTop.text = "TOP"
//        }
//        if textFieldBottom.text == "" {
//            textFieldBottom.text = "BOTTOM"
//        }
//    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func keyboardWillShow(_ notification: Notification) {
        if textFieldBottom.isEditing {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
        if textFieldTop.isEditing {
            view.frame.origin.y = 0
        }
    }
    
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
    
    // Action image pick from toolbar button
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)
        } else {
            print("Camera not present")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func generateMemedImage() -> UIImage {
        
        // TODO: Hide toolbar and navbar
        self.navigationController?.isNavigationBarHidden = true
        toolBar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // TODO: Show toolbar and navbar
        
        return memedImage
    }
    
    struct Meme {
        var topText: String!
        var bottomText: String!
        var originalImage: UIImage!
        var memedImage: UIImage!
    }
    
    
    // not sure if this what I'm looking for
    @IBAction func shareMeme(sender: UIButton) {
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
    // what would be in any
    
    
    func save() {
        // Create the meme
        let meme = Meme(topText: textFieldTop.text!, bottomText: textFieldBottom.text!, originalImage: imagePickerView.image!, memedImage: memedImage)
        print("saving Meme")
    }
    // does this need a presentViewController for the activity view
    
    
    
}




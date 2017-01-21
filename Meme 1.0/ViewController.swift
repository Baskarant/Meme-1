//
//  MemeEditViewController.swift
//  Meme 1.0
//
//  Created by Baskaran T on 05/01/17.
//  Copyright © 2017 Baskaran T. All rights reserved.
//

import UIKit

class MemeEditViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate {

    // imageview
    @IBOutlet weak var imagePickerView: UIImageView!
    // camera button
    @IBOutlet weak var btnCamera: UIBarButtonItem!
    // Top_TextField 
    @IBOutlet weak var topTextField: UITextField!
    // Bottom_TextField
    @IBOutlet weak var bottomTextField: UITextField!
    // Navigation bar
    @IBOutlet weak var navBar: UINavigationBar!
    // Toolbar
    @IBOutlet weak var toolBar: UIToolbar!
    
    var memedImage: UIImage!
    
    let memeTextAttributes : [String:Any] = [NSStrokeColorAttributeName:UIColor.black,
                                             NSForegroundColorAttributeName:UIColor.white,
                                             NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack",size:30)!,
                                             NSStrokeWidthAttributeName:-3]
    
    func setTextFields(textField:UITextField,text:String){
        textField.defaultTextAttributes = memeTextAttributes
        textField.text = text
        textField.textAlignment = .center
        textField.delegate = self
    }
    
        override func viewDidLoad() {
        super.viewDidLoad()
        // Text for top and bottom attribute of Meme
        // text field with default name
        setTextFields(textField: topTextField, text: "TOP")
        setTextFields(textField: bottomTextField, text: "BOTTOM")
            
        // code for Meme 2.0 to hidden navigation and tab bar
            self.navigationController?.navigationBar.isHidden = true
            self.tabBarController?.tabBar.isHidden = true
     }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // if camera is not available diable button
        btnCamera.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        // keyboard
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //keyboard
        unsubscribeFromKeyboardNotifications()
    }    
    
    /* Image related code start */
    // Photo Album
    @IBAction func pickAnImageFromPhotoAlbum(_ sender: Any) {
        pickAnImage(sourceType: UIImagePickerControllerSourceType.photoLibrary)
    }
    
    // Camera
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        pickAnImage(sourceType: UIImagePickerControllerSourceType.camera)
    }
    
    // common code for UIImagePickercontrollerSourceType
    func pickAnImage(sourceType:UIImagePickerControllerSourceType){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = sourceType
        present(imagePickerController, animated: true, completion: nil)
    }
    
    // Mark: -- Album picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    // Dismiss imagepicker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    /* Share Action  */
    @IBAction func shareAction(_ sender: UIBarButtonItem) {
        memedImage = generateMemedImage()
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityController.completionWithItemsHandler = { activity, success, items, error in
            self.saveMeme()
            self.dismiss(animated: true, completion: nil)
        }
        present(activityController, animated: true, completion: nil)
    
    }
    
    func saveMeme(){
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, image: imagePickerView.image!, memedImage: memedImage)
        print(meme.bottomText)
        // code added for Meme2.0
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    func generateMemedImage() -> UIImage {
        // Hiding Nav and Tool bar
        navBar.isHidden = true
        toolBar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // show nav & toolbar
        navBar.isHidden = false
        toolBar.isHidden = false
        
        return memedImage
    }
    
    // always text begin with
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("editing began")
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /* Keyboard Function */
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(_ notification:Notification) {
        if  bottomTextField.isFirstResponder{
        view.frame.origin.y = getKeyboardHeight(notification) * -1
            print(view.frame.origin.y)
        }
    }
    
    func keyboardWillHide(_ notification:Notification) {
        if bottomTextField.isFirstResponder{
        view.frame.origin.y = 0
            print(view.frame.origin.y)
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
}

//
//  ViewController.swift
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
        // if camera is not available diable button
        btnCamera.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        // Text for top and bottom attribute of Meme
        setTextFields(textField: topTextField, text: "TOP")
        setTextFields(textField: bottomTextField, text: "BOTTOM")
     }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        if imagePickerView.image == nil {
            
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("editing began")
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    func keyboardWillShow(_ notification:Notification) {
        if  bottomTextField.isFirstResponder{
        view.frame.origin.y = getKeyboardHeight(notification) * -1
        }
    }
    
    func keyboardWillHide(_ notification:Notification) {
        if bottomTextField.isFirstResponder{
        view.frame.origin.y = 0
        }
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

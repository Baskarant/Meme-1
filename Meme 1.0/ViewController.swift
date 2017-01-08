//
//  ViewController.swift
//  Meme 1.0
//
//  Created by Baskaran T on 05/01/17.
//  Copyright © 2017 Baskaran T. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate {

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
                                             NSFontAttributeName: UIFont(name: "Helvetica Neue",size:30)!,
                                             NSStrokeWidthAttributeName:-3]
    override func viewDidLoad() {
        super.viewDidLoad()
        // if camera is not available diable button
        btnCamera.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        // Text for top and bottom attribute of Meme
        
        
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.text = "TOP"
        topTextField.textAlignment = .center
        topTextField.delegate = self
        
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.text = "BOTTOM"
        bottomTextField.textAlignment = .center
        bottomTextField.delegate = self
        
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
    
    func textfield(){
        topTextField.text = "TOP"
        topTextField.backgroundColor  = UIColor.white
        
        bottomTextField.text = "BOTTOM"
        bottomTextField.backgroundColor = UIColor.white
    }

    
    /* #2 Start
    /* Image related code  ends */
    
    /* textfields code */
    func initTextField(_ textFields : [UITextField]) {
        let memeTextAttributes: [String:Any] = [NSStrokeColorAttributeName: UIColor.black,
                                                NSForegroundColorAttributeName: UIColor.white,
                                                NSFontAttributeName:UIFont(name:"HelveticaNeueCondensedBlack",size:30)!,
                                                NSStrokeWidthAttributeName: -1.0]
        
        for textField in textFields {
            textField.textAlignment = .center
            textField.delegate = self
            textField.defaultTextAttributes = memeTextAttributes
        }
    }
    
    func showTextField(){
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        topTextField.isHidden = false
        bottomTextField.isHidden = false
        topbuttons.isHidden = false
    }
    
    func hideTextField(){
        topTextField.isHidden = true
        bottomTextField.isHidden = true
        topbuttons.isHidden = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /* Textfields related code */
    
    
    // MARK: -- Keyboard observer
    func keyboardWillShow(_ notification:Notification) {
        print("== Keyboard Show ==")
        view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    func keyboardWillHide(_ notification:Notification) {
        print("== Keyboard Hide ==")
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

   #2 end */
}

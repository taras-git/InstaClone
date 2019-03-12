//
//  PostViewController.swift
//  InstagramClone
//
//  Created by user on 3/10/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import Parse

class PostViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var imageToPost: UIImageView!
    @IBOutlet weak var comment: UITextField!
    var activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))

    @IBAction func postImage(_ sender: UIButton) {
        if let image = imageToPost.image {
            let post = PFObject(className: "Post")
            post["message"] = comment.text
            post["userid"] = PFUser.current()?.objectId
            if let imageData = image.pngData() {
                self.displayProgressBar()
                let imageFile = PFFile(name: "image.png", data: imageData)
                post["imageFile"] = imageFile
                post.saveInBackground { (success, error) in
                    self.hideProgressBar()
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        self.displayAlert(title: "Image Posted", message: "Your image has been posted")
                        self.comment.text = ""
                        self.imageToPost.image = nil
                    }
                }
            }
        }

    }

    @IBAction func chooseImage(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imageToPost.image = image
        }

        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    func displayAlert(title : String, message : String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }

    
    func displayProgressBar(){
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .gray
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func hideProgressBar(){
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

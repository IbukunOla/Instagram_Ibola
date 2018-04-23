//
//  ComposeViewController.swift
//  Instagram_Ibola1
//
//  Created by Ibukun on 2/28/18.
//  Copyright © 2018 Ibukun. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var postPhotoImageView: UIImageView!
    @IBOutlet weak var captionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func cancelPost(_ sender: Any) {
        self.performSegue(withIdentifier: "HomeFeed", sender: sender)
    }
    
    @IBAction func beginEditing(_ sender: Any) {
        if captionTextView.text == "Write a caption here..." {
            captionTextView.text = ""
        }
    }
    
    @IBAction func getImage(){
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("Camera is available")
            vc.sourceType = .camera
        } else {
            print("Camera is unavailable")
            vc.sourceType = .photoLibrary
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let orgImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        _ = info[UIImagePickerControllerEditedImage] as! UIImage
        
        postPhotoImageView.image = orgImage
        //Don't need to show edited image for now
        
        dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func postImage(_ sender: Any) {
        let post = Post()
        let image = resize(image: postPhotoImageView.image!, newSize: CGSize(width: 100, height: 100))
        let caption = captionTextView.text ?? "No caption"
        let date = getCurrentTime()
        var allowSegue = true
        post.postUserImage(image: image, withCaption: caption, withDate: date) { (success, err) in
            if let err = err {
                print(err.localizedDescription)
            } else {
                if success {
                    print("Picture posted")
                } else {
                    print("Something messed up and didn't send error")
                    allowSegue = false
                }
            }
        }
        if allowSegue {
            self.performSegue(withIdentifier: "toHomeFeed", sender: nil)
        }
    }
    
    func getCurrentTime() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: Date())
    }
    
    func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        resizeImageView.contentMode = UIViewContentMode.scaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

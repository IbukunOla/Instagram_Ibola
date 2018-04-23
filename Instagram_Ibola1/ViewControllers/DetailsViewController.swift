//
//  DetailsViewController.swift
//  Instagram_Ibola1
//
//  Created by Ibukun on 4/18/18.
//  Copyright © 2018 Ibukun. All rights reserved.
//

import UIKit
import Parse

class DetailsViewController: UIViewController {

    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    
    var post: PFObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let post = post {
            let imageFile = post["media"] as! PFFile
            imageFile.getDataInBackground { (imageData, err) in
                if let err = err {
                    print(err.localizedDescription)
                } else {
                    let image = UIImage(data: imageData!)
                    self.postImageView.image = self.resize(image: image!, newSize: self.postImageView.frame.size)
                }
            }
            captionLabel.text = post["caption"] as? String
            dateLabel.text = post["date"] as? String ?? "Unknown Time"
            nameLabel.text = post["author"] as? String
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

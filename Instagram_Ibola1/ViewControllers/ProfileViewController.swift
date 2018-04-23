//
//  ProfileViewController.swift
//  Instagram_Ibola1
//
//  Created by Ibukun on 3/23/18.
//  Copyright © 2018 Ibukun. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nameLabel: UILabel!
    
    let curr_user = PFUser.current()

    var own_posts: [PFObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = curr_user?.username
        
        collectionView.dataSource = self
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = layout.minimumInteritemSpacing
        let cellPerLine: CGFloat = 3
        let interItemSpacingTotal = layout.minimumInteritemSpacing * (cellPerLine - 1)
        let width = collectionView.frame.size.width / cellPerLine - interItemSpacingTotal / cellPerLine
        layout.itemSize = CGSize(width: width, height: width)
        getOwnPosts()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPressLogout(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("didLogout"), object: nil)
    }
    
    func getOwnPosts(){
        let query = Post.query()
        query?.includeKey("author")
        query?.order(byDescending: "createdAt")
        query?.limit = 204
        
        query?.findObjectsInBackground(block: { (gotPosts, error) in
            if let posts = gotPosts {
                self.own_posts = posts
                self.collectionView.reloadData()
            }
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return own_posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OwnPost", for: indexPath) as! PostCollectionViewCell
        let post = own_posts[indexPath.row]
        let imageFile = post["media"] as! PFFile
        imageFile.getDataInBackground { (imageData, err) in
            if let err = err {
                print(err.localizedDescription)
            } else {
                let image = UIImage(data: imageData!)
                cell.postImageView?.image = self.resize(image: image!, newSize: cell.postImageView.frame.size)
            }
        }
        
        return cell
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

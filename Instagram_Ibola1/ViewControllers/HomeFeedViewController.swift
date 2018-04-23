//
//  HomeFeedViewController.swift
//  Instagram_Ibola1
//
//  Created by Ibukun on 2/28/18.
//  Copyright © 2018 Ibukun. All rights reserved.
//

import UIKit
import Parse

class HomeFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var posts: [PFObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(HomeFeedViewController.didPullToRefresh(_:)), for: .valueChanged)
        tableView.delegate = self
        tableView.dataSource = self
    }
    


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getPosts()
    }
    
    @objc func didPullToRefresh(_ refreshControl: UIRefreshControl){
        getPosts()
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getPosts() {
        let query = Post.query()
        query?.limit = 20
        
        query?.findObjectsInBackground(block: { (gotPosts, error) in
            if let posts = gotPosts {
                print("Got posts")
                self.posts = posts
                self.tableView.reloadData()
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostTableViewCell
        let post = posts[indexPath.row]
        let imageFile = post["media"] as! PFFile
        imageFile.getDataInBackground { (imageData, err) in
            if let err = err {
                print(err.localizedDescription)
            } else {
                let image = UIImage(data: imageData!)
                cell.postImage?.image = self.resize(image: image!, newSize: cell.postImage.frame.size)
            }
        }
        cell.captionLabel.text = post["caption"] as? String
        cell.dataLabel.text = post["date"] as? String ?? "Unknown Time"
        cell.nameLabel.text = post["author"] as? String
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetails" {
            let cell = sender as! PostTableViewCell
            if let indexPath = tableView.indexPath(for: cell){
                let post = posts[indexPath.row]
                
                let navVC = segue.destination as! UINavigationController
                let detailVC = navVC.topViewController as! DetailsViewController
                detailVC.post = post
            }
        }
    }
    
    
    
}

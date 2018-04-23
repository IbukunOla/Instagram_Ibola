//
//  Post.swift
//  Instagram_Ibola1
//
//  Created by Ibukun on 3/24/18.
//  Copyright © 2018 Ibukun. All rights reserved.
//

import UIKit
import Parse

class Post: PFObject, PFSubclassing {
    
    @NSManaged var media         : PFFile
    @NSManaged var author        : PFUser
    @NSManaged var caption       : String
    @NSManaged var likesCount    : Int
    @NSManaged var commentsCount : Int
    @NSManaged var date          : String
    
    static func parseClassName() -> String {
        return "Post"
    }
    
    func postUserImage(image: UIImage?, withCaption caption: String, withDate date: String, withCompletion completion: PFBooleanResultBlock?) {
        let post = Post()
        
        post.media = getPFFileFromImage(image: image)!
        post.author = PFUser.current()!
        post.caption = caption
        post.likesCount = 0
        post.commentsCount = 0
        post.date = date
        
        do {
            print(try post.media.getData())
        } catch {
            print("Error, casn't get data")
        }
        post.saveInBackground(block: completion)
    }
    
    func getPFFileFromImage(image: UIImage?) -> PFFile? {
        if let image = image {
            if let imageData = UIImagePNGRepresentation(image) {
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
    }
}

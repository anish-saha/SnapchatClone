//
//  ImageFeed.swift
//  SnapchatCloneV3
//
//  Created by Anish Saha on 4/12/16.
//  Copyright © 2016 asaha. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage
import FirebaseDatabase


var threads: [String: [Post]] = ["Memes": [], "Dog Spots": [], "Random": []]


let threadNames = ["Memes", "Dog Spots", "Random"]


func getPostFromIndexPath(indexPath: IndexPath) -> Post? {
    let sectionName = threadNames[indexPath.section]
    if let postsArray = threads[sectionName] {
        return postsArray[indexPath.row]
    }
    print("No post at index \(indexPath.row)")
    return nil
}

func addPostToThread(post: Post) {
    threads[post.thread]!.append(post)
}

func clearThreads() {
    threads = ["Memes": [], "Dog Spots": [], "Random": []]
}

func addPost(postImage: UIImage, thread: String, username: String) {
    let dbRef = FIRDatabase.database().reference()
    let data = UIImageJPEGRepresentation(postImage, 1.0)! 
    let path = "\(firStorageImagesPath)/\(UUID().uuidString)"
    let df = DateFormatter()
    df.dateFormat = dateFormat
    let date = df.string(from: Date())
    let values = ["imagePath": path, "thread": thread, "username": username, "date": date]
    let userReference = dbRef.child("Posts")
    userReference.childByAutoId().setValue(values)
    store(data: data, toPath: path)
}

func store(data: Data, toPath path: String) {
    let storageRef = FIRStorage.storage().reference(withPath: path)
    storageRef.put(data, metadata: nil, completion: { mata, err in
        if (err != nil) {
            print("error occur")
            return
        }
    
    })
}

func getPosts(user: CurrentUser, completion: @escaping ([Post]?) -> Void) {
    let dbRef = FIRDatabase.database().reference()
    var postArray: [Post] = []
    let userReference = dbRef.child("Posts")
    
    userReference.observeSingleEvent(of: .value, with: {snapshot in
        if (snapshot.exists()){
            let values1 = snapshot.value
            if (values1 == nil) {
                completion(nil)
            }
            let values = values1 as! [String:AnyObject]
            user.getReadPostIDs(completion: {strlist in
                for (k,v) in values{
                    let hasread = strlist.contains(k)
                    let v: [String:String]? = v as? [String:String]
                    if let v = v {
                        let newpost = Post(id: k,username: v["username"]!,postImagePath: v["imagePath"]!, thread: v["thread"]!,dateString: v["date"]!,read: hasread)
                        postArray.append(newpost)
                    }
                }

                completion(postArray)
            })
        } else {
            completion(nil)
        }
    
    })
}

func getDataFromPath(path: String, completion: @escaping (Data?) -> Void) {
    let storageRef = FIRStorage.storage().reference()
    storageRef.child(path).data(withMaxSize: 5 * 1024 * 1024) { (data, error) in
        if let error = error {
            print(error)
        }
        if let data = data {
            completion(data)
        } else {
            completion(nil)
        }
    }
}



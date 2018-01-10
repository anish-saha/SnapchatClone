//
//  ImageFeed.swift
//  SnapchatClone v3
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

/*

    Stores the data for a new post in the Firebase database.
    Each post node contains the following properties:
    
    - (string) imagePath: corresponds to the location of the image in the storage module. This is already defined for you below.
    - (string) thread: corresponds to which feed the image is to be posted to.
    - (string) username: corresponds to the display name of the current user who posted the image.
    - (string) date: the exact time at which the image is captured as a string
        Note: Firebase doesn't allow us to store Date objects, so we have to represent the date as a string instead. You can do this by creating a DateFormatter object, setting its dateFormat (check Constants.swift for the correct date format!) and then calling dateFormatter.string(from: Date()). 
 
    Creates a dictionary with these four properties and store it as a new child under the Posts node.
    Finally, saves the actual data to the storage module by calling the store function below.
*/
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

/*
    Store the data to the given path on the storage module using the put function.
    You can pass in nil for the metadata. 
    In the closure, just check to see if there is an error and print it. You do not need to do anything with the returned metadata.
*/
func store(data: Data, toPath path: String) {
    let storageRef = FIRStorage.storage().reference(withPath: path)
    storageRef.put(data, metadata: nil, completion: { mata, err in
        if (err != nil) {
            print("error occur")
            return
        }
    
    })
}


/*
    This function queries Firebase for all posts and return an array of Post objects, then makes a query for the user's read posts ID's.
 */
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
                    let v = v as! [String:String]
                    let newpost = Post(id: k,username: v["username"]!,postImagePath: v["imagePath"]!, thread: v["thread"]!,dateString: v["date"]!,read: hasread)
                    postArray.append(newpost)
                    
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



//
//  CurrentUser.swift
//  SnapchatClone v3
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class CurrentUser {
    
    var username: String!
    var id: String!
    var readPostIDs: [String]?
    
    let dbRef = FIRDatabase.database().reference()
    
    init() {
        let currentUser = FIRAuth.auth()?.currentUser
        username = currentUser?.displayName
        id = currentUser?.uid
    }
    
    /*
        Retrieves list of post ID's that user has already opened and returns them as an array of strings.
        Note that our database is set up to store a set of ID's under the readPosts node for each user.
        Makes a query to Firebase using the 'observeSingleEvent' function.
    */
    func getReadPostIDs(completion: @escaping ([String]) -> Void) {
        var postArray: [String] = []
        let userReference = dbRef.child("Users").child(id).child("readPosts")
        userReference.observeSingleEvent(of: .value, with: {snapshot in
            if (snapshot.exists()) {
                debugPrint("user snapshot exists")
                var dict: [String: AnyObject]
                if (snapshot.value == nil){
                    return
                }
                debugPrint("user snapshot value exists")
                dict = snapshot.value as! [String : AnyObject]
                for (_, y) in dict{
                    postArray.append(y as! String)
                }
                completion(postArray)

            } else {
                completion([])
                return
            }
        })
        
    }
    
    /*
        Adds a new post ID to the list of post ID's under the user's readPosts node.
    */
    func addNewReadPost(postID: String) {
        let userReference = dbRef.child("Users").child(id).child("readPosts")
        userReference.childByAutoId().setValue(postID)
    }
}

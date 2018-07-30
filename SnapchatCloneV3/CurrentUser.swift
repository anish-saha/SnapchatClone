//
//  CurrentUser.swift
//  SnapchatCloneV3
//
//  Created by Anish Saha on 4/12/16.
//  Copyright © 2016 asaha. All rights reserved.
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
    
    func getReadPostIDs(completion: @escaping ([String]) -> Void) {
        var postArray: [String] = []
        let userReference = dbRef.child("Users").child(id).child("readPosts")
        userReference.observeSingleEvent(of: .value, with: {snapshot in
            if (snapshot.exists()) {
                var dict: [String: AnyObject]
                if (snapshot.value == nil){
                    return
                }
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
    
    func addNewReadPost(postID: String) {
        let userReference = dbRef.child("Users").child(id).child("readPosts")
        userReference.childByAutoId().setValue(postID)
    }
}

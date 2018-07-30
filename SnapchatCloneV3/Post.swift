//
//  Post.swift
//  SnapchatCloneV3
//
//  Created by Anish Saha on 4/12/16.
//  Copyright © 2016 asaha. All rights reserved.
//

import Foundation
import UIKit

class Post {
    
    var read: Bool = false
    let username: String
    let thread: String
    let date: Date
    let postImagePath: String
    let postId: String
    
    init(id: String, username: String, postImagePath: String, thread: String, dateString: String, read: Bool) {
        self.postImagePath = postImagePath
        self.username = username
        self.thread = thread
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        self.date = dateFormatter.date(from: dateString)!
        self.read = read
        self.postId = id
    }
    
    func getTimeElapsedString() -> String {
        let seconds = -date.timeIntervalSinceNow
        let minutes = Int(seconds / 60)
        if minutes == 1 {
            return "\(minutes) minute ago"
        } else if minutes < 60 {
            return "\(minutes) minutes ago "
        } else if minutes < 120 {
            return "1 hour ago"
        } else if minutes < 24 * 60 {
            return "\(minutes / 60) hours ago"
        } else if minutes < 48 * 60 {
            return "1 day ago"
        } else {
            return "\(minutes / 1440) days ago"
        }
        
    }

}

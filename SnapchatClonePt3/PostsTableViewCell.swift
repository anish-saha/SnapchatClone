//
//  PostsTableViewCell.swift
//  SnapchatClone v3
//

import UIKit

class PostsTableViewCell: UITableViewCell {
    
    /// Displays the name of the user who posted the thread
    @IBOutlet weak var usernameLabel: UILabel!

    /// Image to indicate whether or not the image has been read
    @IBOutlet weak var readImageView: UIImageView!
    
    /// Displays how many minutes ago the snap was posted
    @IBOutlet weak var timeElapsedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

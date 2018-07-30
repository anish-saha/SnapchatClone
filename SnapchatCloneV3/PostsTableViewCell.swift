//
//  PostsTableViewCell.swift
//  SnapchatCloneV3
//
//  Created by Anish Saha on 4/12/16.
//  Copyright © 2016 asaha. All rights reserved.
//

import UIKit

class PostsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var readImageView: UIImageView!
    @IBOutlet weak var timeElapsedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

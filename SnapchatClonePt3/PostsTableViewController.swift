//
//  PostsTableViewController.swift
//  SnapchatClone v3
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import MBProgressHUD

class PostsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    enum Constants {
        static let postBackgroundColor = UIColor.black
        static let postPhotoSize = UIScreen.main.bounds
    }
    
    // Dictionary that maps IDs of images to the actual UIImage data
    var loadedImagesById: [String:UIImage] = [:]
    
    
    let currentUser = CurrentUser()
    
    /// Table view holding all posts from each thread
    @IBOutlet weak var postTableView: UITableView!
    
    /// Button that displays the image of the post selected by the user
    var postImageViewButton: UIButton = {
        var button = UIButton(frame: Constants.postPhotoSize)
        button.backgroundColor = Constants.postBackgroundColor
        button.isHidden = true
        return button
    }()
    
    override func viewDidLoad() {
        self.updateData()
        super.viewDidLoad()
        
        postTableView.delegate = self
        postTableView.dataSource = self
        view.addSubview(postImageViewButton)
        
        postImageViewButton.addTarget(self, action: #selector(self.hidePostImage(sender:)), for: UIControlEvents.touchUpInside)
        
    }
    /*
        Call the function to retrieve data for our tableview. 
    */
    override func viewWillAppear(_ animated: Bool) {
        self.updateData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /*
        Retrieves all of the posts in the database.
    */
    func updateData() {
        getPosts(user: currentUser, completion: {posts in
            clearThreads()
            for post in posts!{
                addPostToThread(post: post)
                debugPrint("Snap was posted.")
                getDataFromPath(path: post.postImagePath, completion: {dat in
                    debugPrint("Retrieving data...")
                    if (dat != nil){
                    let img = UIImage(data: dat!)
                    self.loadedImagesById[post.postId] = img
                    }
                })
                debugPrint("Finished data retrieval.")
            }
        })
        postTableView.reloadData()
        
    }
    
    // MARK: Custom methods (relating to UI)
    
    func hidePostImage(sender: UIButton) {
        sender.isHidden = true
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = false
    }
    
    func presentPostImage(forPost post: Post) {
        if let image = loadedImagesById[post.postId] {
            postImageViewButton.isHidden = false
            postImageViewButton.setImage(image, for: .normal)
            navigationController?.navigationBar.isHidden = true
            tabBarController?.tabBar.isHidden = true
        } else {
            let hud = MBProgressHUD.showAdded(to: view, animated: true)
            getDataFromPath(path: post.postImagePath, completion: { (data) in
                if let data = data {
                    let image = UIImage(data: data)
                    self.loadedImagesById[post.postId] = image
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.postImageViewButton.isHidden = false
                    self.postImageViewButton.setImage(image, for: .normal)
                    // hide the navigation and tab bar for presentation
                    self.navigationController?.navigationBar.isHidden = true
                    self.tabBarController?.tabBar.isHidden = true
                }
            })
        }
    
    }
    
    // MARK: Table view delegate and datasource methods

    func numberOfSections(in tableView: UITableView) -> Int {
        return threadNames.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return threadNames[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostsTableViewCell
        if let post = getPostFromIndexPath(indexPath: indexPath) {
            if post.read {
                cell.readImageView.image = UIImage(named: "read")
            }
            else {
                cell.readImageView.image = UIImage(named: "unread")
            }
            cell.usernameLabel.text = post.username
            cell.timeElapsedLabel.text = post.getTimeElapsedString()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let threadName = threadNames[section]
        return threads[threadName]!.count
    }
    
    
    // Adds the selected post as one of the current user's read posts
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let post = getPostFromIndexPath(indexPath: indexPath), !post.read {
            if (self.loadedImagesById[post.postId] == nil){
                post.read = true
                currentUser.addNewReadPost(postID: post.postId)
                tableView.reloadData()
            } else {
            presentPostImage(forPost: post)
            post.read = true
            currentUser.addNewReadPost(postID: post.postId)
            tableView.reloadData()
            }
        }
     
    }
    
}

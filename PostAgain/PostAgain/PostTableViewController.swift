//
//  PostTableViewController.swift
//  PostAgain
//
//  Created by Eva Marie Bresciano on 6/6/16.
//  Copyright © 2016 Eva Bresciano. All rights reserved.
//

import UIKit

class PostTableViewController: UITableViewController,PostControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
        postController.delegate = self
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
    }
    
    let postController = PostController()
    
    // MARK: - Table view data source
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postController.posts.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("postCell", forIndexPath: indexPath)
        let post = postController.posts[indexPath.row]
        cell.textLabel?.text = post.text
        cell.detailTextLabel?.text = "\(indexPath.row) \(post.userName) \(NSDate(timeIntervalSince1970: post.timestamp))"
        
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row+1 == postController.posts.count {
            
            postController.fetchPosts(reset: false, completion: { (newPosts) in
                
                if !newPosts.isEmpty {
                    
                    self.tableView.reloadData()
                }
            })
        }
    }
    
    func postsUpdated(posts: [Post]) {
        tableView.reloadData()
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    func presentNewPostAlert() {
        let alertController = UIAlertController(title: "New post", message: nil, preferredStyle: .Alert)
        
        var userNameTextField: UITextField?
        var messageTextField: UITextField?
        
        alertController.addTextFieldWithConfigurationHandler { (postContent) in
            let messageTextField = postContent
            
            alertController.addTextFieldWithConfigurationHandler({ (usernameContent) in
                let userNameTextField = usernameContent
            })
        }

        let postAlertAction = UIAlertAction(title: "Post", style: .Default) { (action) in
            guard let userName = userNameTextField?.text where !userName.isEmpty,
                let text = messageTextField?.text where !text.isEmpty else {
                    
                    self.presentErrorAlert()
                    
                    return
            }
            
             self.postController.addPost(userName, text: text)
        }
        
        alertController.addAction(postAlertAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)

    }
    
    func presentErrorAlert() {
        let errorAlert = UIAlertController(title: "Error", message: "Missing required fields", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        errorAlert.addAction(cancelAction)
        
        presentViewController(errorAlert, animated: true, completion: nil)

    }
    
    //MARK: - Actions
    
    @IBAction func refreshControlPulled(sender: UIRefreshControl) {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        postController.fetchPosts(reset: true) { (newPosts) in
            
            sender.endRefreshing()
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }
    
    @IBAction func addButtonTapped(sender: AnyObject) {
        presentNewPostAlert()
    }
    
    
}
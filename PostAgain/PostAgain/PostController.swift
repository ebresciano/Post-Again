//
//  PostController.swift
//  PostAgain
//
//  Created by Eva Marie Bresciano on 6/6/16.
//  Copyright © 2016 Eva Bresciano. All rights reserved.
//

import Foundation

class PostController {
    
    weak var delegate: PostControllerDelegate?
    
    static let baseURL = NSURL(string: "https://devmtn-post.firebaseio.com/posts/")
    
    static let endpoint = baseURL?.URLByAppendingPathExtension("json")
    
    var posts: [Post] = [] {
        didSet {
            delegate?.postsUpdated(posts)
        }
    }
    
//    init() {
//        
//        fetchPosts()
//    }
    
    func fetchPosts(reset reset: Bool = true, completion: ((posts: [Post]) -> Void)? = nil) {
        guard let unwrappedURL = PostController.endpoint
            else {fatalError("URL optional is nil")}
        
        NetWorkController.performRequestForURL(unwrappedURL, httpMethod: .Get) { (data, error) in
            if let data = data,
                responseDataString = NSString(data: data, encoding: NSUTF8StringEncoding) {
                guard let responseDictionary = (try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)) as? [String:AnyObject],
                    postDictionaries = responseDictionary["posts"] as? [[String:AnyObject]] else {
                        print("Unable to serialize JSON. \nResponse: \(responseDataString)")
                        completion?(posts: [])
                        return
                }
                
                let posts = postDictionaries.flatMap{Post(jsonDictionary:$0)}
                //completion?(posts: posts)
                
                let postsSorted = posts.sort({$0.0.timestamp > $0.1.timestamp})
                
                dispatch_async(dispatch_get_main_queue(), {
                    if reset {
                        self.posts = postsSorted
                    } else {
                        self.posts.appendContentsOf(postsSorted)
                    }
                    if let completion = completion {
                        completion(posts:postsSorted)
                    }
                    return
                })
            }
        }
    }
}

protocol PostControllerDelegate: class {
    func postsUpdated(posts: [Post])
    
}






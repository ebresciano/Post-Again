//
//  Post.swift
//  PostAgain
//
//  Created by Eva Marie Bresciano on 6/6/16.
//  Copyright © 2016 Eva Bresciano. All rights reserved.
//

import Foundation

class Post {
    
    let userName: String
    let text: String
    let timestamp: NSTimeInterval
    let identifier: NSUUID
    
    init(userName: String, text: String, identifier: NSUUID = NSUUID()) {
        self.userName = userName
        self.text = text
        self.timestamp = NSDate().timeIntervalSince1970
        self.identifier = identifier
        
    }
    
    init?(jsonDictionary: [String:AnyObject]) {
        guard let userName = jsonDictionary["username"] as? String,
            text = jsonDictionary["text"] as? String,
            timestamp = jsonDictionary ["timestamp"] as? NSTimeInterval,
            identifier = jsonDictionary["identifier"] as? NSUUID else {
                return nil }
        
        self.userName = userName
        self.text = text
        self.timestamp = timestamp
        self.identifier = identifier
        
    }

    
}

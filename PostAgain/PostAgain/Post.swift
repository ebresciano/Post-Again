//
//  Post.swift
//  PostAgain
//
//  Created by Eva Marie Bresciano on 6/6/16.
//  Copyright © 2016 Eva Bresciano. All rights reserved.
//

import Foundation

class Post {
    
    var queryTimestamp: NSTimeInterval {
        
        return timestamp - 0.000001
    }
    
    var endpoint: NSURL? {
     return PostController.baseURL?.URLByAppendingPathComponent(identifier.UUIDString).URLByAppendingPathExtension("json")
    }
    
    var jsonValue: [String:AnyObject] {
        return ["username":userName,
        "text":text,
        "timestamp":timestamp]
    }
    
    var jsonData: NSData? {
        return try? NSJSONSerialization.dataWithJSONObject(jsonValue, options: .PrettyPrinted)
    }
    
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
    
    init?(jsonDictionary: [String:AnyObject], identifier: String) {
        guard let userName = jsonDictionary["username"] as? String,
            text = jsonDictionary["text"] as? String,
            timestamp = jsonDictionary ["timestamp"] as? NSTimeInterval
            else {
                return nil }
        
        self.userName = userName
        self.text = text
        self.timestamp = timestamp
        self.identifier = NSUUID(UUIDString: identifier) ?? NSUUID()
        
    }

    
}

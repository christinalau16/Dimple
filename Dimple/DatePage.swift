//
//  DatePages.swift
//  Tabbar App example
//
//  Created by Christina Lau on 7/27/17.
//  Copyright © 2017 Christina Lau. All rights reserved.
//

import Foundation

class DatePage: NSObject, NSCoding{
    
    // MARK: Properties
    var pageName: String
    var starred: Bool?
    
    // MARK: Types
    struct PropertyKey {
        static let pageNameKey = "pageName"
        static let starredKey = "starred"
    }
    
    // MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(pageName, forKey: PropertyKey.pageNameKey)
        aCoder.encode(starred, forKey: PropertyKey.starredKey)
    }
    
    init(pageName: String, starred: Bool) {
        self.pageName = pageName
        self.starred = starred
        super.init()
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let pageName = aDecoder.decodeObject(forKey: PropertyKey.pageNameKey) as! String
        let starred = aDecoder.decodeObject(forKey: PropertyKey.starredKey) as! Bool
        self.init(pageName: pageName, starred: starred)
    }
    
}

//
//  Entry+Convenience.swift
//  JournalCoreData
//
//  Created by Devin Flora on 1/18/21.
//

import CoreData

extension Entry {
    
    @discardableResult convenience init(title: String, bodyText: String, timestamp: Date = Date(), context: NSManagedObjectContext = CoreDataStack.context) {
        self.init (context: context)
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
    }
    
    static func ==(lhs: Entry, rhs: Entry) -> Bool {
        return lhs.title == rhs.title && lhs.bodyText == rhs.bodyText && lhs.timestamp == rhs.timestamp
    }
}//End of Extension

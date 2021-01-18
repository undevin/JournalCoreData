//
//  EntryController.swift
//  JournalCoreData
//
//  Created by Cameron Stuart on 1/18/21.
//

import CoreData

class EntryController {
    
    static let shared = EntryController()
    
    var entries: [Entry] = []
    
    private lazy var fetchRequest: NSFetchRequest<Entry> = {
        let request = NSFetchRequest<Entry>(entityName: "Entry")
        request.predicate = NSPredicate(value: true)
        return request
    }()
    
    private init() {}
    
    func createEntry(title: String, body: String) {
        Entry(title: title, body: body)
        CoreDataStack.saveContext()
    }
    
    func fetchEntries() {
        entries = (try? CoreDataStack.context.fetch(self.fetchRequest)) ?? []
    }
    
    func updateEntry(entry: Entry, title: String, body: String) {
        entry.title = title
        entry.body = body
        entry.timestamp = Date()
        CoreDataStack.saveContext()
    }
}

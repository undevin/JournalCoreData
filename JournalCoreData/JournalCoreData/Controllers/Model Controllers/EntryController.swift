//
//  EntryController.swift
//  JournalCoreData
//
//  Created by Devin Flora on 1/18/21.
//

import CoreData

class EntryController {
    
    // MARK: - Properties
    static let shared = EntryController()
    
    var entries: [Entry] = []
    
    private lazy var fetchRequest: NSFetchRequest<Entry> = {
        let request = NSFetchRequest<Entry>(entityName: "Entry")
        request.predicate = NSPredicate(value: true)
        return request
    }()
    
    // MARK: - CRUD Methods
    func createEntryWith(title: String, bodyText: String, timestamp: Date) {
        Entry(title: title, bodyText: bodyText, timestamp: timestamp)
        CoreDataStack.saveContext()
    }
    
    func fetchEntries() {
        self.entries = (try? CoreDataStack.context.fetch(fetchRequest)) ?? []
    }
    
    func updateEntry(entry: Entry, title: String, bodyText: String, timestamp: Date) {
        entry.title = title
        entry.bodyText = bodyText
        entry.timestamp = timestamp
        CoreDataStack.saveContext()
    }
    
    func deleteEntry(entry: Entry) {
        if let index = entries.firstIndex(of: entry) {
            entries.remove(at: index)
            CoreDataStack.container.viewContext.delete(entry)
        }
        CoreDataStack.saveContext()
    }
}//End of Class

//
//  EntriesListTableViewController.swift
//  JournalCoreData
//
//  Created by Devin Flora on 1/18/21.
//

import UIKit

class EntriesListTableViewController: UITableViewController {
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        EntryController.shared.fetchEntries()
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EntryController.shared.entries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath)
        let indexPath = EntryController.shared.entries[indexPath.row]
        
        cell.textLabel?.text = indexPath.title
        cell.detailTextLabel?.text = "Last Update: " + DateFormatter.entryTime.string(from: indexPath.timestamp ?? Date())
        
        return cell
    }
    
        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                let entryToDelete = EntryController.shared.entries[indexPath.row]
                EntryController.shared.deleteEntry(entry: entryToDelete)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEntryDetails" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let destination = segue.destination as? EntryDetailsViewController else { return }
            let entryToSend = EntryController.shared.entries[indexPath.row]
            destination.entry = entryToSend
        }
    }
}//End of Class


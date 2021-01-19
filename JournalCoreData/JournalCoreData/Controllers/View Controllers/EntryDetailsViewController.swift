//
//  EntryDetailsViewController.swift
//  JournalCoreData
//
//  Created by Devin Flora on 1/18/21.
//

import UIKit

class EntryDetailsViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextField: UITextView!
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        bodyTextField.layer.borderWidth = 1
    }
    
    // MARK: - Properties
    var entry: Entry?
    
    // MARK: - Actions
    @IBAction func clearTextButtonTapped(_ sender: Any) {
        clearTextFields()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let title = titleTextField.text, !title.isEmpty,
              let bodyText = bodyTextField.text, !bodyText.isEmpty else { return }
        if let entry = entry {
            EntryController.shared.updateEntry(entry: entry, title: title, bodyText: bodyText, timestamp: Date())
        } else {
            EntryController.shared.createEntryWith(title: title, bodyText: bodyText, timestamp: Date())
        }
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Methods
    func clearTextFields() {
        titleTextField.text = ""
        bodyTextField.text = ""
    }
    
    func updateViews() {
        guard let entry = entry else { return }
        titleTextField.text = entry.title
        bodyTextField.text = entry.bodyText
    }
}//End of Class

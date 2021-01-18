# JournalCoreData

Students will build a simple Journal app to practice MVC separation, protocols, master-detail interfaces, table views, and persistence. 

Journal is an excellent app to practice basic Cocoa Touch principles and design patterns. Students are encouraged to repeat building Journal regularly until the principles and patterns are internalized and the student can build Journal without a guide.

Students who complete this project independently are able to:

### Part One- Models and Model Controllers
* understand basic model-view-controller design and implementation
* create a custom model object in core data, and create a convenience initializer for that model object
* understand, create, and use a shared instance
* create a model object controller with create, read and update functions
*add a core data stack to their project
*implement basic persistence using core data 

## #Part Two - User Interface

* implement a master-detail interface
* implement the UITableViewDataSource protocol
* understand and implement the UITextFieldDelegate protocol to dismiss the keyboard
* create relationship segues in Storyboards
* understand, use, and implement the 'updateWith' pattern
* implement 'prepareForSegue' to configure destination view controllers

## Part One- Models and Model Controllers

Create a new project, ensuring to check the box that asks if you will be using CoreData. Call you project ```JournalCoreData```. By doing this your project will be created with some of the base things that we will need in a core data project, such as our xcdatamodel. 

Once the project is created, organize your files. 

### Core Data Stack

In a new file create your core data stack. This is crucial when working with core data because this is what sets up your persistent container and gives you access to your managed object context. Your code should look like this, just make sure that the name of your app name is correct where it asks:

```
import CoreData

enum CoreDataStack {

    static let container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "JournalCoreData")
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("Error loading persistent stores \(error)")
            }
        }
        return container
    }()

    static var context: NSManagedObjectContext { container.viewContext }

    static func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context \(error)")
            }
        }
    }
}
```


### Entry

Create an Entry model class that will hold a title, text, and timestamp for each entry.

1. Go to your xcdatamodel file and create a new Entry entity. 
2. Add all needed attributes (properties) to the Entry entity (title, bodytext, timestamp)
3. Once you have created your Entry entity in the xcdatamodel, create a new file called Entry+Convenience. Here you will create a convenience initializer for your entry in an extension of Entry (remember that our Entry model object already exists because we added it as an entity in our xcdatamodel, so if we are going to do anything to our object such as add a convenience initializer it needs to happen in an extension.)
    1. Your convenience initializer should take in a title, bodytext, and timestamp as well as a context. You can give the timestamp as well as context default values.

### EntryController

Create a model object controller called EntryController that will manage adding, reading, updating, and removing entries. We will follow the shared instance design pattern because we want one consistent source of truth for our entry objects that are held on the controller.

1. Add a new `EntryController.swift` file and define a new `EntryController` class inside.
2. Create a sharedController property as a shared instance. 
* note: Review the syntax for creating shared instance properties
3. Add an entries Array property that will be the source of truth for your application
4. Create a ```createEntry(title: String, body: String)``` fucntion, and build it out.
* Don't forget to call your `CoreDataStack.saveContext` function
5. Crate a fetchRequest property (review the syntax below)
```
private lazy var fetchRequest: NSFetchRequest<Entry> = {
    let request = NSFetchRequest<Entry>(entityName: "Entry")
    request.predicate = NSPredicate(value: true)
    return request
}()
```
6. Create a `fetchEntries()` function and `try` fetch the requests using your `fetchRequest`

## Part Two - User Interface

### Master List View

Build a view that lists all journal entries. You will use a UITableViewController and implement the UITableViewDataSource functions.

The UITableViewController subclass template comes with a lot of boilerplate and commented code. For readability, please remove all unused boilerplate from your code. 

You will want to call your `fetchEntries` fucntion as well as reload the table view each time it appears in order to display newly created entries.

1. Add a UITableViewController as your root view controller in Main.storyboard and embed it into a UINavigationController
2. Create an EntryListTableViewController file as a subclass of UITableViewController and set the class of your root view controller scene
3. Implement the UITableViewDataSource functions using the EntryController entries array
    * note: Pay attention to your ```reuseIdentifier``` in the Storyboard scene and your dequeue function call
4. Set up your cells to display the title of the entry
5. Add a UIBarButtonItem to the UINavigationBar with the plus symbol
    * note: Select 'Add' in the System Item menu from the Identity Inspector to set the button as a plus symbol, these are system bar button items, and include localization and other benefits

### Detail View

Build a view that provides editing and view functionality for a single entry. You will use a UITextField to capture the title, a UITextView to capture the body, a UIButton to save, and a UIButton to clear the title and body text areas.

Your Detail View should follow the 'updateViews' pattern for updating the view elements with the details of a model object. To follow this pattern, the developer adds an 'updateViews' function that first checks to see if an specific model object exists (in this case, an entry). The function updates the view with details from the model object.

This view needs to serve as a reading and editing view. You will add a UITextField to display the title (titleTextField) and a UITextView to display the body text (bodyTextView), a 'Clear' button that resets both fields, and a 'Save' button that saves the new or changed entry.

#### View Setup
1. Add a UIViewController scene
2. Add a UITextField to the top of the scene
3. Add a UITextViiew to the miffle of the scene
4. Add a UIButton with a title 'Clear' to the bottom of the scene 
5. Add a UIBarButtonItem to right side of the navigation bar and switch it to a save item

#### The View Controller File

1. Add an `EntryDetailViewController` file as a subclass of UIViewController
2. Subclass your UIViewController scene on Main.storyboard to be a `EntryDetailViewController`
3. Connect outlets for your textField(`titleTextField`) and textView (`bodyTextView`)
3. Add a property to hold an optional entry (`var entry: Entry?`)
4. Add an `updateViews` function (don't forget to call it)
5. Inside your `updateViews` function, guard to make sure you have an `entry`
* You don't want to try and update view if you don't have an entry, which is why we use a guard or if-let here.
3. After the guard statement, still inside your `updateViews` function, update your `titleTextField` and `bodyTextView` to have the assosiated strings found on your unwrapped entry
8. Connect actions for your clear button (`clearButtonTapped`) and save button (`saveButtonTapped`)
9. In your `clearButtonTapped` IBAction, set the text values of your `titleTextField` and `bodyTextView` to be empty stings, this will clear any text you have in those views.
10. In your `saveButtonTapped` IBAction, determine if you have an entry or not, and if you do, call your `updateEntry` function that exists on your model contrller. If you do not have an entry, call your `createEntry` function that exists on your model controller.


### Segue

You will add two separate segues from the List View to the Detail View. The segue from the plus button will tell the EntryDetailViewController that it should create a new entry. The segue from a selected cell will tell the EntryDetailViewController that it should display a previously created entry.

1. Add a 'show' segue from the Add button to the EntryDetailViewController scene
2. Add a 'show' segue from the table view cell to the EntryDetailViewController scene and give the segue an identifier
    * note: Consider that this segue will be used to edit an entry when naming the identifier
3. Add a ```prepareForSegue``` function to the EntryListTableViewController
4. Implement the ```prepareForSegue``` function. Check the identifier of the segue parameter, if the identifier is 'toViewEntry' (or whatever you may have named it) we will need to pass the selected entry to the DetailViewController in order for it to display the entries details and allow for updating.
    * note: You will need to capture the selected entry by using the indexPath of the selected cell

After building out your segue, you should have an application that shows you a list of entries. If you click on an entry cell you should be able to see that entries details and, when clicking save, update that entry. If you click on the plus button, instead of a cell, it should take you to a blank detail view where you can add entry details and, when clicking save, create a new entry. 

## Black Diamond
1. Give your app the ability to delete entries.
* A few things to consider: you will need a delete entry function on your model controller, you will need to conform your entry model to be equatable, you will need to implement the commit EditingStyle sata source method on your EntriesListTableViewController.

## Copyright
Copyright © 2020 Strayer University. Unauthorized use and/or duplication of this material without express and written permission from Strayer University is strictly prohibited. To see Devmountain's privacy policy, please vistit https://devmountain.com/privacy

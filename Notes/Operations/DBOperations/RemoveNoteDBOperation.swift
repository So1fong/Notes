//
//  RemoveNoteDBOperation.swift
//  Notes
//
//  Created by Kateryna Kozlova on 27/07/2019.
//  Copyright © 2019 Kateryna Kozlova. All rights reserved.
//

import Foundation
import CoreData

class RemoveNoteDBOperation: BaseDBOperation
{
    private let note: Note
    
    init(note: Note, notebook: FileNotebook)
    {
        self.note = note
        super.init(notebook: notebook)
        NotificationCenter.default.addObserver(self, selector: #selector(managedObjectContextDidSave(notification:)), name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil)
    }
    
    @objc func managedObjectContextDidSave(notification: Notification)
    {
        self.context.perform
        {
            self.context.mergeChanges(fromContextDidSave: notification)
        }
    }
    
    override func main()
    {
        //notebook.loadFromFile()
        notebook.remove(with: note.uuid)
        //notebook.saveToFile()
        DispatchQueue.global(qos: .userInitiated).async
        {
            [weak self] in
            guard let sself = self else { return }
            sself.backgroundContext.performAndWait
            {
                let request = NSFetchRequest<NoteCoreData>(entityName: "NoteCoreData")
                request.predicate = NSPredicate(format: "uuid = %@", sself.note.uuid)
                do
                {
                    let test = try sself.backgroundContext.fetch(request)
                    let noteToDelete = test[0]
                    sself.backgroundContext.delete(noteToDelete)
                    do
                    {
                        try sself.backgroundContext.save()
                    }
                    catch let error
                    {
                        print("Save error: \(error.localizedDescription)")
                    }
                }
                catch let error
                {
                    print("Fetch error: \(error.localizedDescription)")
                }
            }
        }
        finish()
    }
}

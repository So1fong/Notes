//
//  LoadNotesDBOperation.swift
//  Notes
//
//  Created by Kateryna Kozlova on 27/07/2019.
//  Copyright © 2019 Kateryna Kozlova. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class LoadNotesDBOperation: BaseDBOperation
{
    var result: [Note]?
    
    override init(notebook: FileNotebook)
    {
        super.init(notebook: notebook)
    }
    
    override func main()
    {
        /*
        let documentsDirectoryPathString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let documentsDirectoryPath = NSURL(string: documentsDirectoryPathString)!
        let jsonFilePath = documentsDirectoryPath.appendingPathComponent("Notes.json")!
        var isDirectory: ObjCBool = false
        if !FileManager.default.fileExists(atPath: jsonFilePath.absoluteString, isDirectory: &isDirectory)
        {
            notebook.saveToFile()
        }
        notebook.loadFromFile()
        result = notebook.note
         */
        NotificationCenter.default.addObserver(self, selector: #selector(managedObjectContextDidSave(notification:)), name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil)
        let request = NSFetchRequest<NoteCoreData>(entityName: "NoteCoreData")
        var notesFromDb: [NoteCoreData] = []
        do
        {
            notesFromDb = try context.fetch(request)
        }
        catch
        {
            print("Can't fetch: \(error.localizedDescription)")
        }
        var newNote: Note?
        DispatchQueue.global(qos: .userInitiated).async
            {
                [weak self] in
                guard let sself = self else { return }
                sself.backgroundContext.performAndWait
                {
                    sself.result = []
                    for i in 0..<notesFromDb.count
                    {
                        let color = UIColor(red: CGFloat(notesFromDb[i].r), green: CGFloat(notesFromDb[i].g), blue: CGFloat(notesFromDb[i].b), alpha: CGFloat(notesFromDb[i].a))
                        guard let uuid = notesFromDb[i].uuid else { return }
                        guard let title = notesFromDb[i].title else { return }
                        guard let content = notesFromDb[i].content else { return }
                        //print("selfDesctructionDate = \(notesFromDb[i].selfDesctructionDate)")
                        let selfDesctructionDate = notesFromDb[i].selfDesctructionDate
                        //print("importance = \(notesFromDb[i].importance)")
                        guard let importance = notesFromDb[i].importance else { return }
                        var newImportance: Importance = .unknown
                        switch importance
                        {
                        case "important":
                            newImportance = Importance.important
                        case "common":
                            newImportance = Importance.common
                        case "unimportant":
                            newImportance = Importance.unimportant
                        default:
                            newImportance = Importance.unknown
                        }
                        newNote = Note(uuid: uuid, title: title, content: content, color: color, importance: newImportance, selfDestructionDate: selfDesctructionDate)
                        sself.result?.append(newNote!)
                        sself.notebook.add(newNote!)
                    }
                }
        }
        
        finish()
    }
    
    @objc func managedObjectContextDidSave(notification: Notification)
    {
        context.perform
        {
            self.context.mergeChanges(fromContextDidSave: notification)
        }
    }
}

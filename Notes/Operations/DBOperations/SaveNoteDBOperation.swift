import Foundation
import CoreData
import UIKit

class SaveNoteDBOperation: BaseDBOperation
{
    private let note: Note
    
    init(note: Note,
         notebook: FileNotebook)
    {
        self.note = note
        super.init(notebook: notebook)
        NotificationCenter.default.addObserver(self, selector: #selector(managedObjectContextDidSave(notification:)), name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil)
    }
    
    @objc func managedObjectContextDidSave(notification: Notification)
    {
        context.perform
        {
            self.context.mergeChanges(fromContextDidSave: notification)
        }
    }
    
    override func main()
    {
        //notebook.loadFromFile()
        notebook.add(note)
        //notebook.saveToFile()
        //print("notebook = \(notebook.note)")
        guard let backgroundContext = backgroundContext else { return }
        DispatchQueue.global(qos: .userInitiated).async
        {
            [weak self] in
            guard let sself = self else { return }
            sself.backgroundContext.performAndWait
            {
                guard let noteFromDb = NSEntityDescription.insertNewObject(forEntityName: "NoteCoreData", into: backgroundContext) as? NoteCoreData else { return }
                noteFromDb.title = sself.note.title
                noteFromDb.uuid = sself.note.uuid
                noteFromDb.content = sself.note.content
                noteFromDb.selfDesctructionDate = sself.note.selfDestructionDate
                var newImportance = ""
                switch sself.note.importance
                {
                case .important:
                    newImportance = "important"
                case .unimportant:
                    newImportance = "unimportant"
                case .common:
                    newImportance = "common"
                default:
                    newImportance = "unknown"
                }
                noteFromDb.importance = newImportance
                var r: CGFloat = 0.0
                var g: CGFloat = 0.0
                var b: CGFloat = 0.0
                var a: CGFloat = 0.0
                sself.note.color.getRed(&r, green: &g, blue: &b, alpha: &a)
                noteFromDb.r = Float(r)
                noteFromDb.g = Float(b)
                noteFromDb.b = Float(b)
                noteFromDb.a = Float(a)
                do
                {
                    try sself.backgroundContext.save()
                }
                catch
                {
                    print("Save error: \(error.localizedDescription)")
                }
                sself.finish()
            }
        }
        //finish()
        
    }
}

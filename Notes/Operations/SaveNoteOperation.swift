import Foundation

class SaveNoteOperation: AsyncOperation
{
    private let note: Note
    private let notebook: FileNotebook
    private let saveToDb: SaveNoteDBOperation
    private var saveToBackend: SaveNotesBackendOperation?
    
    private(set) var result: Bool? = false
    
    init(note: Note,
         notebook: FileNotebook,
         backendQueue: OperationQueue,
         dbQueue: OperationQueue)
    {
        self.note = note
        self.notebook = notebook
        saveToDb = SaveNoteDBOperation(note: note, notebook: notebook)
        super.init()
        addDependency(saveToDb)
        dbQueue.addOperations([saveToDb], waitUntilFinished: true)
        let saveToBackend = SaveNotesBackendOperation(notes: notebook.note)
        self.saveToBackend = saveToBackend
        self.addDependency(saveToBackend)
        backendQueue.addOperations([saveToBackend], waitUntilFinished: true)
    }
    
    override func main()
    {
        switch saveToBackend!.result!
        {
        case .success:
            result = true
        case .failure:
            result = false
        }
        finish()
    }
}

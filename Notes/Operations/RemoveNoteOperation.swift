//
//  RemoveNoteOperation.swift
//  Notes
//
//  Created by Kateryna Kozlova on 27/07/2019.
//  Copyright © 2019 Kateryna Kozlova. All rights reserved.
//

import Foundation

class RemoveNoteOperation: AsyncOperation
{
    private let note: Note
    private let notebook: FileNotebook
    private let removeFromDB: RemoveNoteDBOperation
    private var saveToBackend: SaveNotesBackendOperation?
    private(set) var result: Bool? = false
    
    init(note: Note,
         notebook: FileNotebook,
         backendQueue: OperationQueue,
         dbQueue: OperationQueue)
    {
        self.note = note
        self.notebook = notebook
        removeFromDB = RemoveNoteDBOperation(note: note, notebook: notebook)
        super.init()
        addDependency(removeFromDB)
        dbQueue.addOperations([removeFromDB], waitUntilFinished: true)
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

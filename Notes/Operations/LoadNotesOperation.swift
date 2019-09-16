//
//  LoadNotesOperation.swift
//  Notes
//
//  Created by Kateryna Kozlova on 27/07/2019.
//  Copyright © 2019 Kateryna Kozlova. All rights reserved.
//

import Foundation

class LoadNotesOperation: AsyncOperation
{
    private let notebook: FileNotebook
    private let loadFromDB: LoadNotesDBOperation
    private var loadFromBackend: LoadNotesBackedOperation?
    private(set) var result: Bool? = false
    public var resultNotes: [Note] = []
    
    init(notebook: FileNotebook,
         backendQueue: OperationQueue,
         dbQueue: OperationQueue)
    {
        self.notebook = notebook
        loadFromDB = LoadNotesDBOperation(notebook: notebook)
        super.init()
        addDependency(loadFromDB)
        dbQueue.addOperations([loadFromDB], waitUntilFinished: true)
        let loadFromBackend = LoadNotesBackedOperation(notes: notebook.note)
        self.loadFromBackend = loadFromBackend
        self.addDependency(loadFromBackend)
        backendQueue.addOperations([loadFromBackend], waitUntilFinished: true)
    }
    
    override func main()
    {
        switch loadFromBackend!.result
        {
        case .success(let notes):
            result = true
            resultNotes = notes
        case .failure:
            result = false
            if let result = loadFromDB.result
            {
                resultNotes = result
            }
        }
        finish()
    }
}

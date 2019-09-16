//
//  FileNotebook.swift
//  Notes
//
//  Created by Kateryna Kozlova on 29/06/2019.
//  Copyright © 2019 Kateryna Kozlova. All rights reserved.
//

import Foundation


class FileNotebook: Decodable
{
    private var _notes: [Note] = []
    
    public var note: [Note]
    {
        get
        {
            return self._notes
        }
    }
    
    public func add(_ note: Note)
    {
        if !_notes.contains(where: { $0.uuid == note.uuid})
        {
            self._notes.append(note)
        }
    }
    
    public func remove(with uid: String)
    {
        _notes.removeAll(where: {$0.uuid == uid})
    }
    
    public func saveToFile()
    {
        let documentsDirectoryPathString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let documentsDirectoryPath = NSURL(string: documentsDirectoryPathString)!
        let jsonFilePath = documentsDirectoryPath.appendingPathComponent("Notes.json")!
        var isDirectory: ObjCBool = false
        //print(jsonFilePath)
        var jsonArr: [[String: Any]] = []
        for i in 0..<_notes.count
        {
            jsonArr.append(_notes[i].json)
        }
        do
        {
            let data = try JSONSerialization.data(withJSONObject: jsonArr, options: [])
            if !FileManager.default.fileExists(atPath: jsonFilePath.absoluteString, isDirectory: &isDirectory)
            {
                let created = FileManager.default.createFile(atPath: jsonFilePath.absoluteString, contents: data, attributes: nil)
                if created
                {
                    print("File created")
                }
                else
                {
                    print("Couldn't create file for some reason")
                }
            }
            else
            {
                print("File already exists")
                do
                {
                    let file = try FileHandle(forWritingTo: jsonFilePath)
                    file.truncateFile(atOffset: 0)
                    file.write(data)
                    print("JSON data was written to the file successfully!")
                }
                catch let error as NSError
                {
                    print("Couldn't write to file: \(error.localizedDescription)")
                }
            }
        }
        catch
        {
            print("error")
        }
    }
    
    public func loadFromFile()
    {
        guard let documentsDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileUrl = documentsDirectoryUrl.appendingPathComponent("Notes.json")
        print(fileUrl)
        do
        {
            let data = try Data(contentsOf: fileUrl, options: [])
            guard let noteArray = try JSONSerialization.jsonObject(with: data, options: []) as? NSArray else
            {
                print("error?")
                return
            }
            _notes = []
            for i in 0..<noteArray.count
            {
                _notes.append(Note.parse(json: noteArray[i] as! [String : Any])!)
            }
        }
        catch
        {
            print(error)
        }
    }
}

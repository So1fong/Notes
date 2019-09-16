//
//  NotesViewController.swift
//  Notes
//
//  Created by Kateryna Kozlova on 21/07/2019.
//  Copyright © 2019 Kateryna Kozlova. All rights reserved.
//

import UIKit

var notebook = FileNotebook()
var isNew = false
var myIndex = 0

class NotesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return NotesViewController.notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as! NotesTableViewCell
        cell.colorImageView.backgroundColor = NotesViewController.notes[indexPath.row].color
        cell.titleLabel.text = NotesViewController.notes[indexPath.row].title
        cell.descriptionLabel.text = NotesViewController.notes[indexPath.row].content
        cell.descriptionLabel.adjustsFontSizeToFitWidth = false
        cell.selectionStyle = .none
        return cell
    }
    
    @IBOutlet weak var tableView: UITableView!
    static var notes: [Note] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 116
        tableView.rowHeight = UITableView.automaticDimension
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addButtonTapped(sender:)))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editButtonTapped(sender:)))
        //fillNotebook()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        let queue = OperationQueue()
        let loadNotes = LoadNotesOperation(notebook: notebook, backendQueue: OperationQueue(), dbQueue: OperationQueue())
        queue.addOperation(loadNotes)
        loadNotes.completionBlock = {
            NotesViewController.notes = loadNotes.resultNotes
            print("RESULT NOTES = \(loadNotes.resultNotes)")
        }
        loadNotes.waitUntilFinished()
        tableView.reloadData()
    }
    
    @objc func addButtonTapped(sender: UIBarButtonItem)
    {
        isNew = true
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "EditNoteVC") as! EditNoteViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func editButtonTapped(sender: UIBarButtonItem)
    {
        if tableView.isEditing
        {
            tableView.isEditing = false
        }
        else
        {
            tableView.isEditing = true
        }
    }
    
    private func fillNotebook()
    {
        let note1 = Note(uuid: UUID().uuidString, title: "Заголовок 1", content: "Пример заметки", color: .red, importance: .important, selfDestructionDate: nil)
        let note2 = Note(uuid: UUID().uuidString, title: "Длинная заметка", content: "Очень длинная заметка очень длинная заметка очень длинная заметка очень длинная заметка очень длинная заметка очень длинная заметка очень длинная заметка", color: .green, importance: .unimportant, selfDestructionDate: nil)
        let note3 = Note(uuid: UUID().uuidString, title: "Еще одна заметка", content: "Не очень длинная заметка не очень длинная заметка не очень длинная заметка", color: .blue, importance: .important, selfDestructionDate: nil)
        notebook.add(note1)
        notebook.add(note2)
        notebook.add(note3)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        guard editingStyle == .delete else { return }
        let noteToDelete = notebook.note[indexPath.row]
        let _ = RemoveNoteOperation(note: noteToDelete, notebook: notebook, backendQueue: OperationQueue(), dbQueue: OperationQueue())
        let loadNotes = LoadNotesOperation(notebook: notebook, backendQueue: OperationQueue(), dbQueue: OperationQueue())
        let queue = OperationQueue()
        queue.addOperation(loadNotes)
        loadNotes.completionBlock = {
            NotesViewController.notes = loadNotes.resultNotes
        }
        notebook.remove(with: noteToDelete.uuid)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        isNew = false
        myIndex = indexPath.row
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "EditNoteVC") as! EditNoteViewController
        navigationController?.pushViewController(vc, animated: true)
    }
}

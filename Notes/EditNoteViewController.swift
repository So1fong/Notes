//
//  ViewController.swift
//  Notes
//
//  Created by Kateryna Kozlova on 25/06/2019.
//  Copyright © 2019 Kateryna Kozlova. All rights reserved.
//

import UIKit


class EditNoteViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, GradientButtonTapped, CheckStateOfPushButtons
{
    func checkState() -> Bool
    {
        var result = true
        if !firstButton.isSelected && !secondButton.isSelected && !thirdButton.isSelected
        {
           result = true
        }
        else
        {
            result = false
        }
        return result
    }
    
    func performSegue()
    {
        performSegue(withIdentifier: "segueToColorPickerVC", sender: nil)
    }
    
    func gradientButtonTapped()
    {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ColorPickerVC") as! ColorPickerViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    let titleTextField = UITextField()
    let descriptionTextView = UITextView()
    let noteLabel = UILabel()
    let destroyLabel = UILabel()
    let dateSwitch = UISwitch()
    let firstButton = PushButton()
    let secondButton = PushButton()
    let thirdButton = PushButton()
    let fourthButton = GradientButton()
    let scrollView = UIScrollView()
    let verticalStackView = UIStackView()
    let switchStackView = UIStackView()
    let buttonsStackView = UIStackView()
    let datePicker = UIDatePicker()
    let saveButton = UIButton()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupUI()
        scrollView.delegate = self
        titleTextField.delegate = self
        firstButton.delegate = self
        secondButton.delegate = self
        thirdButton.delegate = self
        fourthButton.delegate = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        if isNew
        {
            titleTextField.text = ""
            descriptionTextView.text = ""
        }
        else
        {
            titleTextField.text = notebook.note[myIndex].title
            descriptionTextView.text = notebook.note[myIndex].content
        }
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        if firstButton.checked
        {
            firstButton.backgroundColor = ColorPickerViewController.getColor()
            firstButton.setNeedsDisplay()
            firstButton.checkMark?.backgroundColor = ColorPickerViewController.getColor()
        }
        else if secondButton.checked
        {
            secondButton.backgroundColor = ColorPickerViewController.getColor()
            secondButton.setNeedsDisplay()
            secondButton.checkMark?.backgroundColor = ColorPickerViewController.getColor()
        }
        else if thirdButton.checked
        {
            thirdButton.backgroundColor = ColorPickerViewController.getColor()
            thirdButton.setNeedsDisplay()
            thirdButton.checkMark?.backgroundColor = ColorPickerViewController.getColor()
        }
    }
    
    @objc func keyboardWillShow(sender: NSNotification)
    {
        if let keyboardSize = (sender.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0
            {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(sender: NSNotification)
    {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        view.endEditing(true)
        return false
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }

    func setupUI()
    {
        setupScrollView()
        setupVerticalStackView()
        setupTextField()
        setupButtonsStackView()
        setupPushButton(button: firstButton)
        setupPushButton(button: secondButton)
        secondButton.backgroundColor = .red
        setupPushButton(button: thirdButton)
        thirdButton.backgroundColor = .green
        setupButton(button: fourthButton)
        setupSwitchStackView()
        setupSwitch()
        setupDestroyLabel()
        setupDescriptionTextField()
        setupSaveButton()
        setupDatePicker()
    }

    func setupScrollView()
    {
        view.addSubview(scrollView)
        scrollView.addSubview(verticalStackView)
        let margins = view.layoutMarginsGuide
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: margins.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
    }
    
    func setupTextField()
    {
        titleTextField.placeholder = "Введите название заметки"
        titleTextField.borderStyle = .roundedRect
    }
    
    func setupButtonsStackView()
    {
        buttonsStackView.axis = .horizontal
        buttonsStackView.distribution = .equalSpacing
        buttonsStackView.spacing = 20
        buttonsStackView.addArrangedSubview(firstButton)
        buttonsStackView.addArrangedSubview(secondButton)
        buttonsStackView.addArrangedSubview(thirdButton)
        buttonsStackView.addArrangedSubview(fourthButton)
    }
    
    func setupPushButton(button: PushButton)
    {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupButton(button: GradientButton)
    {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
    }

    func setupSwitchStackView()
    {
        switchStackView.axis = .horizontal
        switchStackView.distribution = .fill
        switchStackView.alignment = .leading
        switchStackView.spacing = 25
        switchStackView.addArrangedSubview(destroyLabel)
        switchStackView.addArrangedSubview(dateSwitch)
    }
    
    func setupDestroyLabel()
    {
        destroyLabel.text = "Удалить после даты:"
        destroyLabel.translatesAutoresizingMaskIntoConstraints = false
        destroyLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        destroyLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupSwitch()
    {
        dateSwitch.isOn = false
        dateSwitch.translatesAutoresizingMaskIntoConstraints = false
        dateSwitch.widthAnchor.constraint(equalToConstant: 50).isActive = true
        dateSwitch.heightAnchor.constraint(equalToConstant: 30).isActive = true
        dateSwitch.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
    }
    
    @objc func switchValueChanged()
    {
        var hidden = false
        if dateSwitch.isOn
        {
            hidden = false
        }
        else
        {
            hidden = true
        }
        UIView.transition(with: datePicker, duration: 0.5, options: .transitionCrossDissolve, animations:
        {
            self.datePicker.isHidden = hidden
        })
    }
    
    func setupDescriptionTextField()
    {
        descriptionTextView.text = ""
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        descriptionTextView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.isScrollEnabled = false
        descriptionTextView.textContainer.heightTracksTextView = true
    }
    
    func setupDatePicker()
    {
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.datePickerMode = .date
        datePicker.isHidden = true
    }
    
    func setupSaveButton()
    {
        saveButton.setTitle("Сохранить", for: .normal)
        saveButton.setTitleColor(.blue, for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.topAnchor.constraint(equalTo: buttonsStackView.bottomAnchor, constant: 20).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        saveButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    @objc func saveButtonTapped()
    {
        let title = titleTextField.text!
        let content = descriptionTextView.text
        let color = ColorPickerViewController.getColor()
        var date: Date?
        if dateSwitch.isOn
        {
            date = datePicker.date
        }
        let newNote = Note(uuid: UUID().uuidString, title: title, content: content!, color: color, importance: .important, selfDestructionDate: date)
        let queue = OperationQueue()
        let saveNote = SaveNoteOperation(note: newNote, notebook: notebook, backendQueue: OperationQueue(), dbQueue: OperationQueue())
        if isNew
        {
            queue.addOperation(saveNote)
            saveNote.waitUntilFinished()
            NotesViewController.notes.append(newNote)
        }
        else
        {
            print("IS NEW = \(isNew)")
            let removeNote = RemoveNoteOperation(note: notebook.note[myIndex], notebook: notebook, backendQueue: OperationQueue(), dbQueue: OperationQueue())
            NotesViewController.notes.removeAll(where: { $0.uuid == notebook.note[myIndex].uuid })
            NotesViewController.notes.append(newNote)
        }
        navigationController?.popViewController(animated: true)
    }
    
    func setupVerticalStackView()
    {
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 20
        verticalStackView.alignment = .center
        verticalStackView.distribution = .fill
        verticalStackView.addArrangedSubview(titleTextField)
        verticalStackView.addArrangedSubview(descriptionTextView)
        verticalStackView.addArrangedSubview(switchStackView)
        verticalStackView.addArrangedSubview(datePicker)
        verticalStackView.addArrangedSubview(buttonsStackView)
        verticalStackView.addArrangedSubview(saveButton)
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 30).isActive = true
        verticalStackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        verticalStackView.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        verticalStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -30).isActive = true
    }

}


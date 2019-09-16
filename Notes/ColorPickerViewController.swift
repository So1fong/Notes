//
//  ColorPickerViewController.swift
//  Notes
//
//  Created by Kateryna Kozlova on 13/07/2019.
//  Copyright © 2019 Kateryna Kozlova. All rights reserved.
//

import UIKit

extension UIColor
{
    func toHex() -> String
    {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return NSString(format:"#%06x", rgb) as String
    }
}

class ColorPickerViewController: UIViewController, ColorPickerProtocol
{
    private static var color: UIColor = .white
    private var tapped = false
    
    static func getColor() -> UIColor
    {
        return color
    }
    
    static func setColor(color: UIColor)
    {
        ColorPickerViewController.color = color
    }
    
    func getColor()
    {
        tapped = true
        colorView.backgroundColor = colorPicker.currentColor
        colorCodeLabel.text = colorPicker.currentColor.toHex()
    }
    
    @IBOutlet weak var colorSuperView: UIView!
    @IBOutlet weak var colorPicker: ColorPicker!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var colorCodeLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        colorPicker.delegate = self
        colorView.backgroundColor = ColorPickerViewController.color
        colorCodeLabel.text = colorView.backgroundColor?.toHex()
        colorSuperView.layer.cornerRadius = 10
        colorSuperView.layer.borderWidth = 1
        colorSuperView.layer.borderColor = UIColor.black.cgColor
        colorSuperView.layer.masksToBounds = true
    }
    
    @IBAction func doneButtonTapped(_ sender: UIButton)
    {
        if tapped
        {
            ColorPickerViewController.color = colorPicker.currentColor
            tapped = false
        }
        navigationController?.popViewController(animated: true)
    }
}

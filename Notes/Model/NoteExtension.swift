//
//  NoteExtension.swift
//  Notes
//
//  Created by Kateryna Kozlova on 29/06/2019.
//  Copyright © 2019 Kateryna Kozlova. All rights reserved.
//

import Foundation
import UIKit

extension Note
{
    var json: [String: Any]
    {
        var dict: [String: Any] = [:]
        dict["uuid"] = self.uuid
        dict["title"] = self.title
        dict["content"] = self.content
        if self.color != .white
        {
            var r: CGFloat = 0.0
            var g: CGFloat = 0.0
            var b: CGFloat = 0.0
            var a: CGFloat = 0.0
            self.color.getRed(&r, green: &g, blue: &b, alpha: &a)
            dict["r"] = r
            dict["g"] = g
            dict["b"] = b
            dict["a"] = a
        }
        switch self.importance
        {
        case .important:
            dict["importance"] = "important"
        case .unimportant:
            dict["importance"] = "unimpornant"
        default:
            break
        }
        if let date = self.selfDestructionDate
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dict["selfDestructionDate"] = dateFormatter.string(from: date)
        }
        else
        {
            dict["selfDestructionDate"] = nil
        }
        return dict
    }
    
    static func parse(json: [String: Any]) -> Note?
    {
        guard
            let uuid = json["uuid"] as? String,
            let title = json["title"] as? String,
            let content = json["content"] as? String
        else
        {
            return nil
        }
        var r: CGFloat? = nil
        var g: CGFloat? = nil
        var b: CGFloat? = nil
        var a: CGFloat? = nil
        if let red = json["r"] as? CGFloat
        {
            r = red
        }
        if let green = json["g"] as? CGFloat
        {
            g = green
        }
        if let blue = json["b"] as? CGFloat
        {
            b = blue
        }
        if let alpha = json["a"] as? CGFloat
        {
            a = alpha
        }
        var color: UIColor = .white
        if r != nil && g != nil && b != nil && a != nil
        {
            color = UIColor(red: r!, green: g!, blue: b!, alpha: a!)
        }
        var importanceString: String? = nil
        var importance: Importance = .common
        if let imp = json["importance"] as? String
        {
            importanceString = imp
            switch importanceString
            {
            case "important":
                importance = .important
            case "unimportant":
                importance = .unimportant
            default:
                importance = .common
            }
        }
        var dateString: String? = nil
        var date = Date()
        if let dt = json["selfDestructionDate"] as? String
        {
            dateString = dt
            let dateString = json["selfDestructionDate"] as? String
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            date = dateFormatter.date(from: dateString!)!
        }
        let note = Note(uuid: uuid, title: title, content: content, color: color ?? .white, importance: importance, selfDestructionDate: date)
        return note
    }
}

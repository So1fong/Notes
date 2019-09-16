//
//  Note.swift
//  Notes
//
//  Created by Kateryna Kozlova on 25/06/2019.
//  Copyright © 2019 Kateryna Kozlova. All rights reserved.
//

import UIKit
import Foundation

enum Importance: Decodable
{
    case unimportant
    case common
    case important
    case unknown
    
    private enum RawValues: String, Decodable
    {
        case unimportant = "unimportant"
        case common = "common"
        case impotrant = "important"
        case unknown = "unknown"
    }
    
    init(from decoder: Decoder) throws
    {
        let contanier = try decoder.singleValueContainer()
        let stringForRawValues = try contanier.decode(String.self)
        switch stringForRawValues
        {
        case RawValues.unimportant.rawValue:
            self = .unimportant
        case RawValues.common.rawValue:
            self = .common
        case RawValues.impotrant.rawValue:
            self = .important
        default:
            self = .unknown
        }
        
    }
    
    
    /*
    init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: Key.self)
        let rawValue = try container.decode(Int.self, forKey: .rawValue)
        switch rawValue
        {
        case 0:
            if let value = try container.decodeIfPresent(String.self, forKey: .associatedValue)
            {
                self = .unimportant(value)
            }
        case 1:
            if let value = try container.decodeIfPresent(String.self, forKey: .associatedValue)
            {
                self = .common(value)
            }
        case 2:
            if let value = try container.decodeIfPresent(String.self, forKey: .associatedValue)
            {
                self = .important(value)
            }
        default:
            throw CodingError.unknownValue
        }
 
    }
     */
}

//extension Importance: Decodable
//{

    
    
    /*
    enum Key: CodingKey
    {
        case rawValue
        case associatedValue
    }
    
    enum CodingError: Error
    {
        case unknownValue
    }
     */
//}

struct Color: Codable
{
    var red: CGFloat = 0.0, green: CGFloat = 0.0, blue: CGFloat = 0.0, alpha: CGFloat = 0.0
    
    var uiColor: UIColor
    {
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    init(uiColor: UIColor)
    {
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    }
}

struct Note: Decodable
{
    let uuid: String
    let title: String
    let content: String
    let color: UIColor
    let importance: Importance
    let selfDestructionDate: Date?
    
    init(uuid: String = UUID().uuidString, title: String, content: String, color: UIColor = .white, importance: Importance, selfDestructionDate: Date? = nil)
    {
        self.uuid = uuid
        self.title = title
        self.content = content
        self.color = color
        self.importance = importance
        self.selfDestructionDate = selfDestructionDate
    }
    
    enum CodingKeys: String, CodingKey
    {
        case uuid, title, content, color, importance, selfDescructionDate
    }
    
    init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        content = try container.decode(String.self, forKey: .content)
        title = try container.decode(String.self, forKey: .title)
        uuid = try container.decode(String.self, forKey: .uuid)
        color = try container.decode(Color.self, forKey: .color).uiColor
        selfDestructionDate = try container.decode(Date.self, forKey: .selfDescructionDate)
        importance = try container.decode(Importance.self, forKey: .importance)
        //let selfDescrictionDateString = try container.decode(String.self, forKey: .selfDescructionDate)
        //let formatter = DateFormatter()
        //selfDestructionDate = formatter.date(from: selfDescrictionDateString)
        
        //importance = try container.decode(String.self, forKey: .importance)
        //if let string = try container.decode(String.self, forKey: .importance)
        //{
        //    self =
        //}
    }
}

extension Note: Equatable
{
    static func == (lhs: Note, rhs: Note) -> Bool
    {
        return lhs.color == rhs.color &&
               lhs.content == rhs.content &&
               lhs.importance == rhs.importance &&
               lhs.selfDestructionDate == rhs.selfDestructionDate &&
               lhs.title == rhs.title &&
               lhs.uuid == rhs.uuid
    }
}


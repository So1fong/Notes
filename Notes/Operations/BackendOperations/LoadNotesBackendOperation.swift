//
//  LoadNotesBackedOperation.swift
//  Notes
//
//  Created by Kateryna Kozlova on 27/07/2019.
//  Copyright © 2019 Kateryna Kozlova. All rights reserved.
//

import Foundation

struct Gist: Codable
{
    let files: [String: GistFile]
}

struct GistFile: Codable
{
    let filename: String
    let content: String
}

enum LoadNotesBackendResult
{
    case success([Note])
    case failure(NetworkError)
}

class LoadNotesBackedOperation: BaseBackendOperation
{
    var result: LoadNotesBackendResult = .failure(.unreachable)
    
    init(notes: [Note])
    {
        super.init()
    }
    
    override func main()
    {
        let id = "your_id"
        let stringUrl = "https://api.github.com/gists/\(id)"
        guard let url = URL(string: stringUrl) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request, completionHandler:
        { (data, response, error) in
            guard let data = data else { return }
            if let response = response as? HTTPURLResponse
            {
                switch response.statusCode
                {
                case 200..<300:
                    print("success")
                    guard let gist = try? JSONDecoder().decode(Gist.self, from: data) else { return }
                    let gistFile = gist.files
                    if let content = gistFile["ios-course-notes-db"]?.content
                    {
                        var notes: [Note] = []
                        guard let jsonData = content.data(using: .utf8) else { return }
                        guard let json = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [Dictionary<String, Any>] else { return }
                        //print(json)
                        for i in 0..<json.count
                        {
                            notes.append(Note.parse(json: json[i])!)
                        }
                        //print(notes)
                        self.result = .success(notes)
                        self.finish()
                    }
                default:
                    print("status: \(response.statusCode)")
                    self.result = .failure(.unreachable)
                    self.finish()
                }
            }
        }).resume()
    }
}


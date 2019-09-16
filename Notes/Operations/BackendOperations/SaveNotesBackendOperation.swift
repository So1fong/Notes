import Foundation

enum NetworkError
{
    case unreachable
}

enum SaveNotesBackendResult
{
    case success
    case failure(NetworkError)
}

class SaveNotesBackendOperation: BaseBackendOperation
{
    var result: SaveNotesBackendResult?
    var notes: [Note] = []
    
    init(notes: [Note])
    {
        super.init()
        self.notes = notes
    }
    
    override func main()
    {
        let id = "your_id"
        let stringUrl = "https://api.github.com/gists/\(id)"
        let token = "your_token"
        guard let url = URL(string: stringUrl) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        var jsonArr: [[String: Any]] = []
        for i in 0..<notes.count
        {
            jsonArr.append(notes[i].json)
        }
        do
        {
            let data = try JSONSerialization.data(withJSONObject: jsonArr, options: .prettyPrinted)
            let convertedString = String(data: data, encoding: .utf8)
            let gistFile = GistFile(filename: "ios-course-notes-db", content: convertedString!)
            let gist = Gist(files: ["" : gistFile])
            request.httpBody = try JSONEncoder().encode(gist)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("token \(token)", forHTTPHeaderField: "Authorization")
        }
        catch let error
        {
            print(error.localizedDescription)
        }
        URLSession.shared.dataTask(with: request, completionHandler:
            { (data, response, error) in
                guard let data = data else { return }
                if let response = response as? HTTPURLResponse
                {
                    //print(String(data: data, encoding: .utf8))
                    switch response.statusCode
                    {
                    case 200..<300:
                        print("success")
                        self.result = .success
                        self.finish()
                    default:
                        print("status: \(response.statusCode)")
                        self.result = .failure(.unreachable)
                        self.finish()
                    }
                }
        }).resume()
    }
}

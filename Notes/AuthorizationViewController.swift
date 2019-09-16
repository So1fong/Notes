//
//  AuthorizationViewController.swift
//  Notes
//
//  Created by Kateryna Kozlova on 11/08/2019.
//  Copyright © 2019 Kateryna Kozlova. All rights reserved.
//

import UIKit

class AuthorizationViewController: UIViewController
{
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    struct GitHubError: Codable
    {
        var message = ""
        var documentation_url = ""
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    func authenticationRequest(username: String, password: String)
    {
        guard let url = URL(string: "https://api.github.com/user") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let combinedString = username + ":" + password
        if let encodingString = combinedString.data(using: .utf8)?.base64EncodedString()
        {
            request.setValue("Basic " + encodingString, forHTTPHeaderField: "Authorization")
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        }
        URLSession.shared.dataTask(with: request) { (data, response, error)  in
            guard let data = data else { return }
            do
            {
                if let response = response as? HTTPURLResponse
                {
                    switch response.statusCode
                    {
                    case 200..<300:
                        print("success")
                        DispatchQueue.main.async
                        {
                            self.performSegue(withIdentifier: "segueToTabBarController", sender: nil)
                        }
                    default:
                        print("status: \(response.statusCode)")
                        var gitHubError = GitHubError(message: "", documentation_url: "")
                        do
                        {
                            gitHubError = try JSONDecoder().decode(GitHubError.self, from: data)
                        }
                        catch
                        {
                            print(error.localizedDescription)
                        }
                        DispatchQueue.main.async
                        {
                            let alert = UIAlertController(title: "Ошибка сервера", message: gitHubError.message, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
                            self.present(alert, animated: true)
                        }
                    }
                }
            }
            catch let error
            {
                print(error.localizedDescription)
            }
            }.resume()
        
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton)
    {
        if loginTextField.text == ""
        {
            let alert = UIAlertController(title: "Ошибка", message: "Введите логин", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        else if passwordTextField.text == ""
        {
            let alert = UIAlertController(title: "Ошибка", message: "Введите пароль", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        else
        {
            guard let login = loginTextField.text else { return }
            guard let password = passwordTextField.text else { return }
            authenticationRequest(username: login, password: password)
        }
    }
    
    @IBAction func loginOfflineButtonTapped(_ sender: UIButton)
    {
        self.performSegue(withIdentifier: "segueToTabBarController", sender: nil)
    }
    
}

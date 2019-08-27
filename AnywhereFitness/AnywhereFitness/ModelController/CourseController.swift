//
//  CourseController.swift
//  AnywhereFitness
//
//  Created by Bradley Yin on 8/27/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import Foundation

class CourseController {
    let baseURL = URL(string: "https://bw-anywhere-fitness.herokuapp.com/")!
    
    func signUp(firstName: String, lastName: String, username: String, password: String, client: Bool, trainer: Bool, completion: @escaping (NetworkError?) -> Void) {
        let newUser = User(firstName: firstName, lastName: lastName, username: username, password: password, client: client, trainer: trainer)
        
        let signUpURL = baseURL.appendingPathComponent("api/register")
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue
        do {
            let userData = try JSONEncoder().encode(newUser)
            request.httpBody = userData
        } catch {
            NSLog("Error encoding user when registering: \(error)")
            completion(.noEncode)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog("Error posting url request: \(error)")
                completion(.badRequest)
                return
            }
            guard let data = data else {
                NSLog("no data return on registration")
                completion(.noData)
                return
            }
            do {
                let userIdDict = try JSONDecoder().decode([String : Int].self, from: data)
                let userId = userIdDict.map({$0.value}).first ?? 0
                print(userId)
                UserDefaults.standard.set(userId, forKey: "userID")
            } catch {
                NSLog("Error decoding when registering: \(error)")
                completion(.noDecode)
                return
            }
        }
    }
}
enum HTTPMethod: String{
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}
enum NetworkError: Error {
    case noToken
    case badRequest
    case noData
    case noDecode
    case noEncode
    case otherError(Error)
}

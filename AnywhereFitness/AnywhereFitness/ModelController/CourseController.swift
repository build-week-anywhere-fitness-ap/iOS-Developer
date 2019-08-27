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
    
    init() {
        
        print("init")
        //        signUp(firstName: "brad2", lastName: "test2", username: "bradtest5", password: "123456", client: true, instructor: false) { (error) in
        //            if let error = error {
        //                print(error)
        //            }
        //            print("sign up")
        //        }
        login(username: "bradtest5", password: "123456") { (error) in
            if let error = error {
                NSLog("Error login:\(error)")
                return
            }
            print("login sucess")
        }
    }
    
    func signUp(firstName: String, lastName: String, username: String, password: String, client: Int, instructor: Int, completion: @escaping (NetworkError?) -> Void) {
        let newUser = User(id: nil, firstName: firstName, lastName: lastName, username: username, password: password, client: client, instructor: instructor, token: nil)
        
        let signUpURL = baseURL.appendingPathComponent("api/register")
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            print(newUser)
            let userData = try JSONEncoder().encode(newUser)
            request.httpBody = userData
        } catch {
            NSLog("Error encoding user when registering: \(error)")
            completion(.noEncode)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog("Error posting url request when register: \(error)")
                completion(.badRequest)
                return
            }
            guard let data = data else {
                completion(.noData)
                return
            }
            do {
                let userIdDict = try JSONDecoder().decode([Int].self, from: data)
                if userIdDict.first != nil {
                    completion(nil)
                } else {
                    completion(.noData)
                    return
                }
                
            } catch {
                NSLog("Error decoding when login: \(error)")
                completion(.noDecode)
                return
            }
            
            
            
            
            }.resume()
    }
    func login (username: String, password: String, completion: @escaping (NetworkError?)-> Void) {
        //let loginInfo = ["username": username, "password": password]
        let loginInfo = UserLogin(username: username, password: password)
        let loginURL = baseURL.appendingPathComponent("api/login")
        var request = URLRequest(url: loginURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let loginData = try JSONEncoder().encode(loginInfo)
            let loginDict = try JSONDecoder().decode(UserLogin.self, from: loginData)
            print(loginDict)
            request.httpBody = loginData
        } catch {
            NSLog("Error encoding user when login: \(error)")
            completion(.noEncode)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog("Error posting url request when login: \(error)")
                completion(.badRequest)
                return
            }
            guard let data = data else {
                NSLog("no data return on login")
                completion(.noData)
                return
            }
            do {
                let user = try JSONDecoder().decode(User.self, from: data)
                if let token = user.token, let userId = user.id {
                    UserDefaults.standard.set(token, forKey: "token")
                    UserDefaults.standard.set(userId, forKey: "userId")
                    print(user)
                    completion(nil)
                } else {
                    completion(.noToken)
                }
            } catch {
                NSLog("Error decoding when login: \(error)")
                completion(.noDecode)
                return
            }
        }.resume()
    }
    
    func updateUser(firstName: String) {
        
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

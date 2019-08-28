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
//                signUp(firstName: "brad", lastName: "test", username: "bradtest", password: "123456", client: 1, instructor: 0) { (error) in
//                    if let error = error {
//                        print(error)
//                    }
//                    print("sign up")
//                }
//        login(username: "bradtest", password: "123456") { (error) in
//            if let error = error {
//                NSLog("Error login:\(error)")
//                return
//            }
//            print("login sucess")
//        }
        updateUser(firstName: "brad", lastName: "test123", password: "123456") { (error) in
            if let error = error {
                NSLog("Error login:\(error)")
                return
            }
            print("update sucess")
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
//            let loginDict = try JSONDecoder().decode(UserLogin.self, from: loginData)
//            print(loginDict)
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
                    print(token)
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
    
    func updateUser(firstName: String, lastName: String, password: String, completion: @escaping (NetworkError?) -> Void) {
        let userId = UserDefaults.standard.integer(forKey: "userId")
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            completion(.noToken)
            return
        }
        print(token)
        let updateJson = ["firstName": firstName, "lastName": lastName, "password": password]
        
        let updateURL = baseURL.appendingPathComponent("api/users/\(userId)")
        var request = URLRequest(url: updateURL)
        request.httpMethod = HTTPMethod.put.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(token, forHTTPHeaderField: "Authorization")
        
        do {
            let userData = try JSONEncoder().encode(updateJson)
            request.httpBody = userData
        } catch {
            NSLog("Error encoding user when updating: \(error)")
            completion(.noEncode)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog("Error posting url request when update: \(error)")
                completion(.badRequest)
                return
            }
            completion(nil)
//            guard let data = data else {
//                completion(.noData)
//                return
//            }
//            do {
//                let responseInt = try JSONDecoder().decode(Int.self, from: data)
//                if responseInt == 1 {
//                    completion(nil)
//                    return
//                } else {
//                    completion(.failure)
//                    return
//                }
//
//            } catch {
//                NSLog("Error decoding when update: \(error)")
//                completion(.noDecode)
//                return
//            }
        }.resume()
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
    case failure
    case otherError(Error)
}

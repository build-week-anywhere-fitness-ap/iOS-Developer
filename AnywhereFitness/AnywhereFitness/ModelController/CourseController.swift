//
//  CourseController.swift
//  AnywhereFitness
//
//  Created by Bradley Yin on 8/27/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import Foundation
import CoreData

class CourseController {
    let baseURL = URL(string: "https://bw-anywhere-fitness.herokuapp.com/")!
    
    var userLocalURL: URL?{
        let fm = FileManager.default
        guard let dir = fm.urls(for: .documentDirectory, in: .userDomainMask).first else {return nil}
        print(dir.path)
        return dir.appendingPathComponent("User.plist")
    }
    
    var currentUser: User?
    
    //var courses: [Course] = []
    
    //for testing
    let userName = "bradTestInstructor"
    let password = "123456"
    
    init() {
    }
    
    
}

extension CourseController {
    //MARK:- User related
    
    func signUp(firstName: String, lastName: String, username: String, password: String, client: Bool, instructor: Bool, completion: @escaping (NetworkError?) -> Void) {
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
                print(user)
                self.currentUser = user
                self.saveLocalUser()
                
                completion(nil)
            } catch {
                NSLog("Error decoding when login: \(error)")
                completion(.noDecode)
                return
            }
        }.resume()
    }
    
    func saveLocalUser() {
        guard let url = self.userLocalURL else{ return }
        
        do{
            let data = try PropertyListEncoder().encode(currentUser)
            try data.write(to: url)
        }catch{
            print("Error saving data: \(error)")
        }
    }
    
    func updateUser(firstName: String, lastName: String, password: String, completion: @escaping (NetworkError?) -> Void) {
        guard currentUser != nil, let userId = currentUser?.id else { return }
        guard let token = currentUser?.token else {
            completion(.noToken)
            return
        }
        print(token)
        
        // local update
        currentUser?.firstName = firstName
        currentUser?.lastName = lastName
        currentUser?.password = password
        
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
        }.resume()
    }
}

extension CourseController {
    
    //MARK:- course CRUD
    
    func createCourse(with name: String, location: String, type: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let instructorId = currentUser?.id else { return }
        context.performAndWait {
            let course = Course(id: nil, name: name, type: type, location: location, instructorId: Int64(instructorId))
            print(course)
            
            do{
                try CoreDataStack.shared.save(context: context)
            } catch {
                NSLog("Error saving context when creating new course: \(error)")
            }
            
            post(course: course, completion: {
                self.deleteLocalCourseAfterCreate(course: course)
            })
        }
    }
    func deleteLocalCourseAfterCreate (course: Course, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        context.performAndWait {
            context.delete(course)
            do{
                try CoreDataStack.shared.save(context: context)
            } catch {
                NSLog("Error saving context when deleting course: \(error)")
            }
            fetchCoursesFromServer()
        }
    }
}
extension CourseController {
    //MARK:- CRUD for pass
    func createPass(with classId: Int64, completed: Bool = false, timesUsed: Int64 = 0, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let clientId = currentUser?.id else { return }
        context.performAndWait {
            let pass = Pass(id: nil, classId: classId, clientId: Int64(clientId), completed: completed, timesUsed: timesUsed)
            print(pass)
            
            do{
                try CoreDataStack.shared.save(context: context)
            } catch {
                NSLog("Error saving context when creating new pass: \(error)")
            }
            
            post(pass: pass, completion: {
                self.deleteLocalPassAfterCreate(pass: pass)
            })
        }
    }
    func deleteLocalPassAfterCreate (pass: Pass, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        context.performAndWait {
            context.delete(pass)
            do{
                try CoreDataStack.shared.save(context: context)
            } catch {
                NSLog("Error saving context when deleting course: \(error)")
            }
            fetchPassesFromServer()
        }
    }
    
    func updatePass(pass: Pass, timesUsed: Int64, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        context.performAndWait {
            pass.timesUsed = timesUsed
            do {
                try CoreDataStack.shared.save(context: context)
            } catch {
                NSLog("Error saving to persistent when updating:\(error)")
                context.reset()
            }
            update(pass: pass)
        }
    }
}

extension CourseController {
    //MARK:- CRUD for session
    func createSession(with classId: Int64, dateTime: Date, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        context.performAndWait {
            let session = Session(id: nil, classId: classId, dateTime: dateTime, context: context)
            print(session)
            
            do{
                try CoreDataStack.shared.save(context: context)
            } catch {
                NSLog("Error saving context when creating new session: \(error)")
            }
            
            post(session: session, completion: {
                self.deleteLocalSessionAfterCreate(session: session, classId: classId, context: context)
            })
        }
    }
    func deleteLocalSessionAfterCreate (session: Session, classId: Int64, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        context.performAndWait {
            context.delete(session)
            do{
                try CoreDataStack.shared.save(context: context)
            } catch {
                NSLog("Error saving context when deleting course: \(error)")
            }
            fetchSessionsFromServer(classId: classId)
        }
    }
    func updateSession(session: Session, dateTime: Date, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        context.performAndWait {
            session.dateTime = dateTime
            do {
                try CoreDataStack.shared.save(context: context)
            } catch {
                NSLog("Error saving to persistent when updating:\(error)")
                context.reset()
            }
            update(session: session)
        }
    }
}
extension CourseController {
    //MARK:- network stuffs
    
    func fetchCoursesFromServer(completion: @escaping () -> Void = {}) {
        guard let token = currentUser?.token else { return }
        let requestURL = baseURL.appendingPathComponent("api/classes")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(token, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching courses from server: \(error)")
                return
            }
            guard let data = data else {
                NSLog("No data returned from data task")
                return
            }
            do {
                let decoder = JSONDecoder()
                let courseRepresentations = try decoder.decode([CourseRepresentation].self, from: data)
                
                // loop through the course representations
                let moc = CoreDataStack.shared.container.newBackgroundContext()
                self.updatePersistentStore(with: courseRepresentations, context: moc)
            }catch {
                NSLog("Error decoding: \(error)")
            }
            completion()
        }.resume()
    }
    
    func updatePersistentStore(with courseRepresentations: [CourseRepresentation], context: NSManagedObjectContext) {
        context.performAndWait {
            for courseRepresentation in courseRepresentations {
                //see if a task with the same identifier exist in core data
                guard let id = courseRepresentation.id else { continue }
                // update it if one does exist, or create a Task if it doesn't
                if let course = course(for: id, context: context) {
                    //task exist in core data, update it
                    course.name = courseRepresentation.name
                    course.location = courseRepresentation.location
                    course.type = courseRepresentation.type
                } else {
                    //task not exist, make new one
                    Course(courseRepresentation: courseRepresentation, context: context)
                }
            }
            do {
                try CoreDataStack.shared.save(context: context)
            } catch {
                NSLog("Error saving \(error)")
                context.reset()
            }
        }
    }
    func course(for id: Int64, context: NSManagedObjectContext) -> Course? {
        
        
        let predicate = NSPredicate(format: "id == %i", id as Int64)
        
        let fetchRequest: NSFetchRequest<Course> = Course.fetchRequest()
        fetchRequest.predicate = predicate
        
        var course: Course? = nil
        do {
            course = try context.fetch(fetchRequest).first
        } catch {
            NSLog("Error fetching course for identifier: \(error)")
        }
        return course
    }
    
    func fetchPassesFromServer(completion: @escaping () -> Void = {}) {
        guard let token = currentUser?.token, let clientId = currentUser?.id else { return }
        let requestURL = baseURL.appendingPathComponent("api/users/\(clientId)/passes")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(token, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching passes from server: \(error)")
                return
            }
            guard let data = data else {
                NSLog("No data returned from data task")
                return
            }
            do {
                let decoder = JSONDecoder()
                let passRepresentations = try decoder.decode([PassRepresentation].self, from: data)
                
                // loop through the course representations
                let moc = CoreDataStack.shared.container.newBackgroundContext()
                self.updatePersistentStore(with: passRepresentations, context: moc)
            }catch {
                NSLog("Error decoding: \(error), no pass for this user")
            }
            completion()
            }.resume()
    }
    
    func updatePersistentStore(with passRepresentations: [PassRepresentation], context: NSManagedObjectContext) {
        context.performAndWait {
            for passRepresentation in passRepresentations {
                //see if a task with the same identifier exist in core data
                guard let id = passRepresentation.id else { continue }
                // update it if one does exist, or create a Task if it doesn't
                if let pass = pass(for: id, context: context) {
                    //task exist in core data, update it
                    pass.timesUsed = passRepresentation.timesUsed ?? 0
                    pass.completed = passRepresentation.completed ?? false
                } else {
                    //task not exist, make new one
                    Pass(passRepresentation: passRepresentation, context: context)
                }
            }
            do {
                try CoreDataStack.shared.save(context: context)
            } catch {
                NSLog("Error saving \(error)")
                context.reset()
            }
        }
    }
    func pass(for id: Int64, context: NSManagedObjectContext) -> Pass? {
        
        
        let predicate = NSPredicate(format: "id == %i", id as Int64)
        
        let fetchRequest: NSFetchRequest<Pass> = Pass.fetchRequest()
        fetchRequest.predicate = predicate
        
        var pass: Pass? = nil
        do {
            pass = try context.fetch(fetchRequest).first
        } catch {
            NSLog("Error fetching course for identifier: \(error)")
        }
        return pass
    }
    
    func fetchSessionsFromServer(classId: Int64, completion: @escaping () -> Void = {}) {
        guard let token = currentUser?.token else { return }
        let requestURL = baseURL.appendingPathComponent("api/classes/ \(classId)/sessions")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(token, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching sessions from server: \(error)")
                return
            }
            guard let data = data else {
                NSLog("No data returned from data task")
                return
            }
            do {
                let decoder = JSONDecoder()
                let dateformatter = DateFormatter()
                dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                decoder.dateDecodingStrategy = .formatted(dateformatter)
                let sessionRepresentations = try decoder.decode([SessionRepresentation].self, from: data)
                
                // loop through the course representations
                let moc = CoreDataStack.shared.container.newBackgroundContext()
                self.updatePersistentStore(with: sessionRepresentations, context: moc)
            }catch {
                NSLog("Error decoding: \(error)")
            }
            completion()
        }.resume()
    }
    
    func updatePersistentStore(with sessionRepresentations: [SessionRepresentation], context: NSManagedObjectContext) {
        context.performAndWait {
            for sessionRepresentation in sessionRepresentations {
                //see if a task with the same identifier exist in core data
                guard let id = sessionRepresentation.id else { continue }
                // update it if one does exist, or create a Task if it doesn't
                if let session = session(for: id, context: context) {
                    //task exist in core data, update it
                    session.dateTime = sessionRepresentation.dateTime
                } else {
                    //task not exist, make new one
                    Session(sessionRepresentation: sessionRepresentation, context: context)
                }
            }
            do {
                try CoreDataStack.shared.save(context: context)
            } catch {
                NSLog("Error saving \(error)")
                context.reset()
            }
        }
    }
    func session(for id: Int64, context: NSManagedObjectContext) -> Session? {
        
        
        let predicate = NSPredicate(format: "id == %i", id as Int64)
        
        let fetchRequest: NSFetchRequest<Session> = Session.fetchRequest()
        fetchRequest.predicate = predicate
        
        var session: Session? = nil
        do {
            session = try context.fetch(fetchRequest).first
        } catch {
            NSLog("Error fetching course for identifier: \(error)")
        }
        return session
    }
    
    func post(course: Course, completion: @escaping () -> Void = {}) {
        guard let token = currentUser?.token else { return }
        let requestURL = baseURL.appendingPathComponent("api/classes")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(token, forHTTPHeaderField: "Authorization")
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        var courseRep = course.courseRepresentation
        courseRep.id = nil
        do {
            let courseData = try encoder.encode(courseRep)
            request.httpBody = courseData
            
        } catch {
            NSLog("Error encoding course representation: \(error)")
            completion()
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error POSTing course representation to server: \(error)")
            }
            guard let data = data else {
                NSLog("no data")
                return
            }
            do {
                let classIdArray = try JSONDecoder().decode([Int].self, from: data)
                print(classIdArray)
                if let classId = classIdArray.first {
                    print(classId)
                }
            } catch {
                NSLog("Error decoding when PUTing to server: \(error)")
                return
            }
            completion()
        }.resume()
    }
    
    func post(pass: Pass, completion: @escaping () -> Void = {}) {
        guard let token = currentUser?.token else { return }
        let requestURL = baseURL.appendingPathComponent("api/passes")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(token, forHTTPHeaderField: "Authorization")
        let encoder = JSONEncoder()
        var passRep = pass.passRepresentation
        passRep.id = nil
        do {
            let passData = try encoder.encode(passRep)
            request.httpBody = passData
            
        } catch {
            NSLog("Error encoding pass representation: \(error)")
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error POSTing pass representation to server: \(error)")
            }
            guard let data = data else {
                NSLog("no data")
                return
            }
            do {
                let passIdArray = try JSONDecoder().decode([Int].self, from: data)
                print(passIdArray)
                if let passId = passIdArray.first {
                    print(passId)
                }
            } catch {
                NSLog("Error decoding when POSTing to server: \(error)")
                return
            }
            completion()
            }.resume()
    }
    
    func update(pass: Pass, completion: @escaping () -> Void = {}) {
        guard let token = currentUser?.token else { return }
        let passId = pass.id
        let requestURL = baseURL.appendingPathComponent("api/passes/\(passId)")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(token, forHTTPHeaderField: "Authorization")
        let encoder = JSONEncoder()
        let passRep = pass.passRepresentation
        //passRep.id = nil
        do {
            let passData = try encoder.encode(passRep)
            request.httpBody = passData
            
        } catch {
            NSLog("Error encoding pass representation: \(error)")
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error PUTing pass representation update to server: \(error)")
            }
//            guard let data = data else {
//                NSLog("no data")
//                return
//            }
//            do {
//                let passIdArray = try JSONDecoder().decode([Int].self, from: data)
//                print(passIdArray)
//                if let passId = passIdArray.first {
//                    print(passId)
//                }
//            } catch {
//                NSLog("Error decoding when PUTing to server: \(error)")
//                return
//            }
            completion()
            }.resume()
    }
    
    func post(session: Session, completion: @escaping () -> Void = {}) {
        guard let token = currentUser?.token else { return }
        let requestURL = baseURL.appendingPathComponent("api/sessions")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(token, forHTTPHeaderField: "Authorization")
        let encoder = JSONEncoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        var sessionRep = session.sessionRepresentation
        sessionRep.id = nil
        do {
            let sessionData = try encoder.encode(sessionRep)
            request.httpBody = sessionData
            
        } catch {
            NSLog("Error encoding session representation: \(error)")
            completion()
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error POSTing session representation to server: \(error)")
            }
            guard let data = data else {
                NSLog("no data")
                return
            }
            do {
                let sessionIdArray = try JSONDecoder().decode([Int].self, from: data)
                print(sessionIdArray)
                if let sessionId = sessionIdArray.first {
                    print(sessionId)
                }
            } catch {
                NSLog("Error decoding when POSTing to server: \(error)")
                return
            }
            completion()
        }.resume()
    }
    
    func update(session: Session, completion: @escaping () -> Void = {}) {
        guard let token = currentUser?.token else { return }
        let sessionId = session.id
        let requestURL = baseURL.appendingPathComponent("api/sessions/\(sessionId)")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(token, forHTTPHeaderField: "Authorization")
        let encoder = JSONEncoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        let sessionRep = session.sessionRepresentation
        //passRep.id = nil
        do {
            let sessionData = try encoder.encode(sessionRep)
            request.httpBody = sessionData
            
        } catch {
            NSLog("Error encoding session representation: \(error)")
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error PUTing pass representation update to server: \(error)")
            }
            completion()
        }.resume()
    }
    
    
    
//    func deleteFromServer(course: Course, completion: (() -> Void)? = nil) {
//        guard let identifier = task.identifier else {
//            completion?()
//            return
//        }
//        let requestURL = baseURL.appendingPathComponent(identifier.uuidString).appendingPathExtension("json")
//        var request = URLRequest(url: requestURL)
//        request.httpMethod = "DELETE"
//
//        URLSession.shared.dataTask(with: request) { (_, _, error) in
//            if let error = error {
//                NSLog("Error DELETEing task representation to server: \(error)")
//            }
//            completion?()
//            }.resume()
//    }
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

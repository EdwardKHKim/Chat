//
//  DatabaseManager.swift
//  Chat
//
//  Created by Edward Kim on 2021-01-20.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
}

extension DatabaseManager {
    
    public func userExists(with email: String, completion: @escaping ((Bool) -> Void)) {
        
        var correctEmail = email.replacingOccurrences(of: ".", with: "-")
        correctEmail = correctEmail.replacingOccurrences(of: "@", with: "-")
        
        database.child(correctEmail).observeSingleEvent(of: .value, with: { snapshot in
            guard snapshot.value as? String != nil else {
                completion(false)
                return
            }
            
            completion(true)
        })
    }
    
    /// Add new user to database
    public func addUser(with user: User) {
        database.child(user.correctEmail).setValue([
            "first_name": user.firstName,
            "last_name": user.lastName
        ])
    }
}

struct User {
    let firstName: String
    let lastName: String
    let email: String
    
    var correctEmail: String {
        var correctEmail = email.replacingOccurrences(of: ".", with: "-")
        correctEmail = correctEmail.replacingOccurrences(of: "@", with: "-")
        return correctEmail
    }
}

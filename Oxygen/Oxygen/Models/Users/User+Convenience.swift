//
//  User+Convenience.swift
//  Oxygen
//
//  Created by Hunter Oppel on 4/28/20.
//  Copyright © 2020 Casanova Studios. All rights reserved.
//

import Foundation
import CoreData

extension User {
    
    var userRepresentation: UserRepresentation? {
        guard let id = id,
            let username = username,
            let password = password,
            let phoneNumber = phoneNumber else { return nil }
        
        return UserRepresentation(id: id,
                                  username: username,
                                  password: password,
                                  phoneNumber: phoneNumber)
    }
    
    @discardableResult convenience init(id: String?,
                                        username: String,
                                        password: String,
                                        phoneNumber: String,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.id = id
        self.username = username
        self.password = password
        self.phoneNumber = phoneNumber
    }
    
    @discardableResult convenience init?(userRepresentation: UserRepresentation,
                                         context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let phoneNumber = userRepresentation.phoneNumber else { return nil }
        
        self.init(id: userRepresentation.id,
                  username: userRepresentation.username,
                  password: userRepresentation.password,
                  phoneNumber: phoneNumber,
                  context: context)
    }
}

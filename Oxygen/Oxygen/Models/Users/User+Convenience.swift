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
        guard let username = username else { return nil }
        return UserRepresentation(id: Int(id ?? ""),
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
//    @discardableResult convenience init?(userRepresentation: UserRepresentation,
//                                         context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
//        guard let phoneNumber = userRepresentation.phoneNumber,
//            let password = userRepresentation.password else { return nil }
//
//        self.init(id: String(userRepresentation.id ?? 0),
//                  username: userRepresentation.username,
//                  password: password,
//                  phoneNumber: phoneNumber,
//                  context: context)
//    }
}

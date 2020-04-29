//
//  UserRepresentation.swift
//  Oxygen
//
//  Created by Hunter Oppel on 4/28/20.
//  Copyright © 2020 Casanova Studios. All rights reserved.
//

import Foundation

struct UserRepresentation: Codable {
    let id: String?
    let username: String
    let password: String
    let phoneNumber: String?
}

//
//  PlantRepresentation.swift
//  Oxygen
//
//  Created by Hunter Oppel on 4/28/20.
//  Copyright © 2020 Casanova Studios. All rights reserved.
//

import Foundation

struct PlantRepresentation: Codable {
    let id: Int
    let commonName: String
    let scientificName: String
    let h2oFrequency: Double
    var idString: String {
        return String(id)
    }
}

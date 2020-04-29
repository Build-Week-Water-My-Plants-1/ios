//
//  PlantRepresentation.swift
//  Oxygen
//
//  Created by Hunter Oppel on 4/28/20.
//  Copyright © 2020 Casanova Studios. All rights reserved.
//

import Foundation

struct PlantRepresentation: Codable {
    let id: String
    let commonName: String
    let scientificName: String
    let h2oFrequency: Double
}

//
//  Plant+Convenience.swift
//  Oxygen
//
//  Created by Hunter Oppel on 4/28/20.
//  Copyright © 2020 Casanova Studios. All rights reserved.
//

import Foundation
import CoreData

extension Plant {
    
    var plantRepresentation: PlantRepresentation? {
        guard let id = id,
            let commonName = commonName,
            let scientificName = scientificName,
            let idInt = Int(id) else { return nil }
        
        return PlantRepresentation(id: idInt,
                                   commonName: commonName,
                                   scientificName: scientificName,
                                   h2oFrequency: h2oFrequency)
    }
    
    @discardableResult convenience init(id: String = UUID().uuidString,
                                        commonName: String,
                                        scientificName: String,
                                        frequency: Double = 1.0,
                                        image: String?,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.id = id
        self.commonName = commonName
        self.scientificName = scientificName
        self.h2oFrequency = frequency
        self.image = image
    }
    
    @discardableResult convenience init?(plantRepresentation: PlantRepresentation,
                                         context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(id: plantRepresentation.idString,
                  commonName: plantRepresentation.commonName,
                  scientificName: plantRepresentation.scientificName,
                  frequency: plantRepresentation.h2oFrequency,
                  image: nil,
                  context: context)
    }
}

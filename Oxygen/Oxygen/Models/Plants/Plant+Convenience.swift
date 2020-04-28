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
            let scientificName = scientificName else { return nil }
        
        return PlantRepresentation(id: id,
                                   commonName: commonName,
                                   scientificName: scientificName)
    }
    
    @discardableResult convenience init(id: UUID = UUID(),
                                        commonName: String,
                                        scientificName: String,
                                        frequency: String = "Once a day",
                                        image: String?,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.id = id
        self.commonName = commonName
        self.scientificName = scientificName
        self.frequency = frequency
        self.image = image
    }
    
    @discardableResult convenience init?(plantRepresentation: PlantRepresentation,
                                         context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(id: plantRepresentation.id,
                  commonName: plantRepresentation.commonName,
                  scientificName: plantRepresentation.scientificName,
                  frequency: "Once a day",
                  image: nil,
                  context: context)
    }
}

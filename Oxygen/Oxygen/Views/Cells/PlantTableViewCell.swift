//
//  PlantTableViewCell.swift
//  Oxygen
//
//  Created by Ezra Black on 4/27/20.
//  Copyright © 2020 Casanova Studios. All rights reserved.
//

import UIKit

class PlantTableViewCell: UITableViewCell {
    
    //MARK: Properties
    
    @IBOutlet weak var plantNickname: UILabel!
    @IBOutlet weak var plantSpecies: UILabel!
    
    //let controller = controller.shared <------- SINGLETON
    
    
    // This is using the core data stack reference(?) 👇
    
    //TODO: Uncomment for production & once CoreData is set.
    
//    var plant: Plant? {
//        didSet {
//            updateViews()
//        }
//    }
    
    //FIXME: Add a Water plants button on the cell if time permits
    
    //MARK: Actions

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
//    func updateViews() {
//        if let plant = plant {
//            plantNameCLbl.text = plant.commonName
//            plantSpeciesCLbl.text = plant.scientificName
//        }
//    }

}

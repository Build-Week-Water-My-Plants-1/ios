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
     @IBOutlet weak var plantWateredButton: UIButton!
    //let controller = controller.shared <------- SINGLETON
    
    
    // This is using the core data stack reference(?) 👇
    
    //TODO: Uncomment for production & once CoreData is set.
    
    var plant: Plant? {
        didSet {
            updateViews()
        }
    }
    
    //FIXME: Add a Water plants button on the cell if time permits
    
        
        //let controller = controller.shared <------- SINGLETON
        
        
        // This is using the core data stack reference(?) 👇
        
        //TODO: Uncomment for production & once CoreData is set.
        
        
        var isPlantWatered: Bool = false
        
        
        //MARK: Actions
        @IBAction func waterPlantButtonTapped(_ sender: UIButton) {
    //        sender.isSelected.toggle()
            
            
            if isPlantWatered == false {
                plantWateredButton.setImage(#imageLiteral(resourceName: "UncoloredPlantUpset.png") , for: .normal)
            } else if isPlantWatered == isHighlighted {
                plantWateredButton.setImage( #imageLiteral(resourceName: "UncoloredPlant.png") , for: .highlighted)
            } else if isPlantWatered == isSelected { 
                plantWateredButton.setImage( #imageLiteral(resourceName: "ColoredPlant.png") , for: .selected)
            }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateViews() {
        if let plant = plant {
            plantNickname.text = plant.commonName
            plantSpecies.text = plant.scientificName
        }
    }

}

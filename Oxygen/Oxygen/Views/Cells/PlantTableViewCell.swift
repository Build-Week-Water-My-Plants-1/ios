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
    
    var plant: Plant? {
        didSet {
            updateViews()
        }
    }
    
//    var timer: Timer = Timer()
    
    //FIXME: Add a Water plants button on the cell if time permits
    
        
        //let controller = controller.shared <------- SINGLETON
        
        
        // This is using the core data stack reference(?) 👇
        
        //TODO: Uncomment for production & once CoreData is set.
        
        
        var isPlantWatered: Bool = false
        
        //MARK: Actions
        @IBAction func waterPlantButtonTapped(_ sender: UIButton) {
            guard let plant = plant else { return }
            plant.isWatered.toggle()
            
            updateViews()
            
            // Start Timer
            runTimer()
//            self.timer = Timer.scheduledTimer(withTimeInterval: plant.h2oFrequency, repeats: false) { _ in
//                self.timer.invalidate()
//                self.timerFired()
//            }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Private Functions
    
//    @objc private func timerFired() {
//        guard let plant = plant else { return }
//        plant.isWatered = false
//        updateViews()
//    }
    
    private func runTimer() {
        guard let plant = plant else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + plant.h2oFrequency) {
            plant.isWatered = false
            self.updateViews()
        }
    }
    
    private func updateViews() {
        guard let plant = plant else { return }
        
        plantNickname.text = plant.commonName
        plantSpecies.text = plant.scientificName
        
        if plant.isWatered == false {
            plantWateredButton.isEnabled = true
            plantWateredButton.setImage(#imageLiteral(resourceName: "UncoloredPlantUpset.png") , for: .normal)
        } else if plant.isWatered {
            plantWateredButton.isEnabled = false
            plantWateredButton.setImage( #imageLiteral(resourceName: "UncoloredPlant.png") , for: .normal)
        }
    }

}

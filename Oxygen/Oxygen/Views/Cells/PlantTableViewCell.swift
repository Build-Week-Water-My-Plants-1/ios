//
//  PlantTableViewCell.swift
//  Oxygen
//
//  Created by Ezra Black on 4/27/20.
//  Copyright © 2020 Casanova Studios. All rights reserved.
//

import UIKit

protocol PlantCellDelegate {
    func timerDidFire(plant: Plant) -> Void
}

class PlantTableViewCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var plantNickname: UILabel!
    @IBOutlet weak var plantSpecies: UILabel!
    @IBOutlet weak var plantWateredButton: UIButton!
    // MARK: - Properties
    var plant: Plant? {
        didSet {
            updateViews()
        }
    }
     var delegate: PlantCellDelegate?
    var isPlantWatered: Bool = false
    @IBAction func waterPlantButtonTapped(_ sender: UIButton) {
        guard let plant = plant else { return }
        plant.isWatered.toggle()
        updateViews()
        // Start Timer
        runTimer()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    // MARK: - Private Functions
    private func runTimer() {
        guard let plant = plant else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + plant.h2oFrequency) {
            plant.isWatered = false
            self.updateViews()
            self.delegate?.timerDidFire(plant: plant)
        }
    }
    private func updateViews() {
        guard let plant = plant else { return }
        plantNickname.text = plant.commonName
        plantSpecies.text = plant.scientificName
        if plant.isWatered == false {
            plantWateredButton.isEnabled = true
            plantWateredButton.setImage(#imageLiteral(resourceName: "UncoloredPlantUpset.png") ,
                                        for: .normal)
        } else if plant.isWatered {
            plantWateredButton.isEnabled = false
            plantWateredButton.setImage( #imageLiteral(resourceName: "UncoloredPlant.png") ,
                                         for: .normal)
        }
    }
}

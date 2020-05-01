//
//  PlantDetailViewController.swift
//  Oxygen
//
//  Created by Ezra Black on 4/27/20.
//  Copyright © 2020 Casanova Studios. All rights reserved.
//

import UIKit

class PlantDetailViewController: UIViewController {

    // MARK: - Outlets
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var plantNameTextField: UITextField!
    @IBOutlet weak var speciesTextField: UITextField!
    @IBOutlet weak var frequencyTextField: UITextField!
    
    // MARK: - Properties
    
    var plant: Plant?
    
    var apiController: ApiController?
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        plantNameTextField.text = plant?.commonName
        speciesTextField.text = plant?.scientificName
        frequencyTextField.text = String(plant?.h2oFrequency ?? 0)
    }
    
    // MARK: - Actions
    
    @IBAction func savePlantButton(_ sender: Any) {
        guard let commonName = plantNameTextField.text,
            let scientificName = speciesTextField.text,
            let frequency = frequencyTextField.text,
            let doubleFrequency = Double(frequency) else { return }
        
        if let plant = plant {
            plant.commonName = commonName
            plant.scientificName = scientificName
            plant.h2oFrequency = doubleFrequency
            
            apiController?.sendPlantToServer(plant: plant, completion: { result in
                switch result {
                case .success(_):
                    print("eggy")
                case .failure(_):
                    print("weggy")
                }
            })
        } else {
            let plant = Plant(commonName: commonName, scientificName: scientificName, frequency: doubleFrequency, image: nil)
            
            apiController?.sendPlantToServer(plant: plant, completion: { result in
                switch result {
                case .success(_):
                    print("eggy")
                case .failure(_):
                    print("weggy")
                }
            })
        }
        
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func ImageButton(_ sender: Any) {
        
    }
    
}

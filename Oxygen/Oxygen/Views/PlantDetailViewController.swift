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
    @IBOutlet weak var pickerView: UIPickerView!
    // MARK: - Properties
    let imagePickerController = UIImagePickerController()
    var plant: Plant?
    var apiController: ApiController?
    enum PickerOptions: String, CaseIterable {
        case onceADay = "Once a day"
        case everyTwoDays = "Every two days"
        case everyThreeDays = "Every three days"
        case onceAWeek = "Once a week"
        case demo = "Demo Purposes: 5 seconds"
    }
    private var pickerData: [String] {
        var pickerData = [String]()
        for data in PickerOptions.allCases {
            pickerData.append(data.rawValue)
        }
        return pickerData
    }
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = ["public.image"]
        pickerView.delegate = self
        pickerView.dataSource = self
        frequencyTextField.delegate = self
        pickerView.isHidden = true
        plantNameTextField.text = plant?.commonName
        speciesTextField.text = plant?.scientificName
        frequencyTextField.text = determineFrequencyText()
        if let image = plant?.image {
            let data = image.data(using: .utf8)!
            imageView.image = UIImage(data: data)
        }
    }
    // MARK: - Actions
    @IBAction func savePlantButton(_ sender: Any) {
        guard let commonName = plantNameTextField.text,
            let scientificName = speciesTextField.text else { return }
        if let plant = plant {
            plant.commonName = commonName
            plant.scientificName = scientificName
            plant.h2oFrequency = determineFrequency()
            apiController?.sendPlantToServer(plant: plant, completion: { result in
                switch result {
                case .success(_):
                    print("eggy")
                case .failure(_):
                    print("weggy")
                }
            })
        } else {
            let plant = Plant(commonName: commonName, scientificName: scientificName,
                              frequency: determineFrequency(),
                              image: nil)
            apiController?.sendPlantToServer(plant: plant,
                                             completion: { result in
                switch result {
                case .success(_ ):
                    print("eggy")
                case .failure(_ ):
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
    @IBAction func imageButton(_ sender: Any) {
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true)
    }
    // This is so inefficient its not even funny but it's 11:35 PM and I can't be bothered.
    private func determineFrequency() -> Double {
        guard let frequency = frequencyTextField.text else { return 0 }
        switch frequency {
        case PickerOptions.onceADay.rawValue:
            return 86400
        case PickerOptions.everyTwoDays.rawValue:
            return 172800
        case PickerOptions.everyThreeDays.rawValue:
            return 259200
        case PickerOptions.onceAWeek.rawValue:
            return 604800
        case PickerOptions.demo.rawValue:
            return 5
        default:
            return 0
        }
    }
    private func determineFrequencyText() -> String? {
        guard let plant = plant else { return nil }
        switch plant.h2oFrequency {
        case 86400:
            return PickerOptions.onceADay.rawValue
        case 172800:
            return PickerOptions.everyTwoDays.rawValue
        case 259200:
            return PickerOptions.everyThreeDays.rawValue
        case 604800:
            return PickerOptions.onceAWeek.rawValue
        case 5:
            return PickerOptions.demo.rawValue
        default:
            return nil
        }
    }
}

extension PlantDetailViewController: UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        frequencyTextField.text = pickerData[row]
        pickerView.isHidden = true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        pickerView.isHidden = false
        return false
    }
}

extension PlantDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
        controller.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            return self.imagePickerController(picker, didSelect: nil)
        }
        imageView.image = image
        if let plant = plant {
            let dataString = String(data: (imageView.image?.pngData()!)!, encoding: .utf8)
            plant.image = dataString
            do {
                try CoreDataStack.shared.mainContext.save()
            } catch {
                NSLog("Error saving managed object context: \(error)")
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

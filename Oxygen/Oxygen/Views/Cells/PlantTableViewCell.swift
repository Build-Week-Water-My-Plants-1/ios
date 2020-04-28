//
//  PlantTableViewCell.swift
//  Oxygen
//
//  Created by Ezra Black on 4/27/20.
//  Copyright © 2020 Casanova Studios. All rights reserved.
//

import UIKit

class PlantTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var plantImage: UIImageView!
    @IBOutlet weak var plantName: UILabel!
    @IBOutlet weak var plantSpecies: UILabel! 
    
    
    func updateViews() {
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}

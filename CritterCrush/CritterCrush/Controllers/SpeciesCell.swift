//
//  SpeciesTableViewCell.swift
//  CritterCrush
//
//  Created by min joo on 3/10/23.
//

import UIKit

class SpeciesCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var scienceLabel: UILabel!
    
    //@IBOutlet var bugImage: UIImage!
    //we dont have images yet
    //but naming convention:
    //icon_species{ID}.png
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

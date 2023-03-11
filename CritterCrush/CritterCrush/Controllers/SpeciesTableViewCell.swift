//
//  SpeciesTableViewCell.swift
//  CritterCrush
//
//  Created by min joo on 3/10/23.
//

import UIKit

class SpeciesTableViewCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var bugImage: UIImage!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

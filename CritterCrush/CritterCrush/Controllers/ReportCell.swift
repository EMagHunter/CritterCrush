//
//  ReportCell.swift
//  CritterCrush
//
//  Created by min joo on 3/19/23.
//For use in Collection View

import UIKit

class ReportCell: UICollectionViewCell {
    @IBOutlet weak var reportImg: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        reportImg.contentMode = .scaleAspectFill
        //reportImg.backgroundColor = .black
       // reportImg.layer.borderColor = UIColor.black.cgColor
       // reportImg.layer.borderWidth = 1
        
       
        //backgroundImage.contentMode = .scaleToFill
        
        //backgroundImage.backgroundColor = .yellow
       
        //backgroundImage.layer.masksToBounds = true
        //backgroundImage.layer.cornerRadius = 10
        //backgroundImage.layer.borderColor = UIColor.lightGray.cgColor
        //backgroundImage.layer.borderWidth = 1
        
        backgroundImage.contentMode = .scaleToFill
        
        // Initialization code
    }

}

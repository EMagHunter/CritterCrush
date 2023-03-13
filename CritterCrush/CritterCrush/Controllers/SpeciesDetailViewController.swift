//
//  SpeciesDetailViewController.swift
//  CritterCrush
//segue: https://ronm333.medium.com/a-simple-table-view-example-in-swift-cbf9a405f975
//horizontal gallery:
//https://github.com/zhiyao92/Horizontal-Sliding-Image

//  Created by min joo on 3/9/23.
//

import UIKit

class SpeciesDetailViewController: UIViewController, UITableViewDelegate{
    
    @IBOutlet var speciesName: UILabel!
    var titleStringViaSegue: String!
    var bugIDViaSegue: Int!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.speciesName.text = self.titleStringViaSegue
        
        // Do any additional setup after loading the view.
    }
    
    //programatically based on species
    //protocol stubs for table

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  DetailSubmissionViewController.swift
//  CritterCrush
//
//  Created by min joo on 3/10/23.
//

import UIKit

class DetailSubmissionViewController: UIViewController{
    
    //UICollectionViewDelegate, UICollectionViewDataSource
    @IBOutlet var speciesName: UILabel!
    
    @IBOutlet var scienceName: UILabel!

    var titleStringViaSegue: String!
    var bugID: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.speciesName.text = self.titleStringViaSegue
        
        // Do any additional setup after loading the view.
        
        self.speciesName.text = self.titleStringViaSegue

        if let i = speciesList.firstIndex(where: { $0.id == bugID }) {
            self.scienceName.text = speciesList[i].science
        }

    }
    
    //MARK:
    /*
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        <#code#>
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }*/
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

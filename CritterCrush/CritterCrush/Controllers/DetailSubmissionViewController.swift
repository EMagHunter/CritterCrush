//
//  DetailSubmissionViewController.swift
//  CritterCrush
//
//  Created by min joo on 3/10/23.
//

import UIKit

class DetailSubmissionViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource{
    
    //
    @IBOutlet weak var imgGrid: UICollectionView!
    @IBOutlet weak var speciesName: UILabel!
    
    @IBOutlet weak var scienceName: UILabel!

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
    //MARK: Image grabbing
    
    /*
     https://inaturalist-open-data.s3.amazonaws.com/photos/241037789/medium.jpg
     */
    
    
    //MARK:
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = imgGrid.dequeueReusableCell(withReuseIdentifier: "ReportCell", for: indexPath) as! ReportCell
        
        return cell
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

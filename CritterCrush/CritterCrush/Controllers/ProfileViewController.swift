//
//  ProfileViewController.swift
//  CritterCrush
//
//  Created by Ana Fuentes on 3/5/23.
//
//MARK: API CALLS
//GET: user stats
//PARAM: userID (logged in)
//400: fail, 201: get json, 401: unauthorized

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //PROGRAM BUTTON TO GO TO SETTINGS
    // @IBOutlet var speciesTitle: UILabel!
     @IBOutlet weak var tableView: UITableView!
     
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var crittercrushPointsLabel: UILabel!
    @IBOutlet weak var totalPointsLabel: UILabel!
    
    //let speciesList = listSpecies
     
     //let speciesList:Array<Species> = [SLF,ALB,EAB,SPM]
     
     override func viewDidLoad() {
         super.viewDidLoad()
         
         usernameLabel.text = user.username

         let nib = UINib(nibName:"SpeciesCell", bundle: nil)
         tableView.register(nib, forCellReuseIdentifier: "SpeciesCell")
         tableView.delegate = self
         tableView.dataSource = self
         // Do any additional setup after loading the view.
     }
     
     
     //MARK: table
     
     //TableView: icons of our bugs
     // 2 columns
     //links to species detail view

     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         
         self.performSegue(withIdentifier: "showDetailReport", sender: self)
         
     }
     
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         
         return speciesList.count
     }
     
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         
         let cell = tableView.dequeueReusableCell(withIdentifier: "SpeciesCell", for: indexPath) as! SpeciesCell
         
         cell.nameLabel.text = speciesList[indexPath.row].name
         
         cell.scienceLabel.text = speciesList[indexPath.row].science
         
         let imgName = "bugicon\(speciesList[indexPath.row].id)"
         cell.iconImage.image = UIImage(named: imgName)
         
         return cell
     }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200.0;
    }

     // MARK: - Navigation
    
    let detailSegueIdentifier = "showDetailReport"
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if  segue.identifier == detailSegueIdentifier,
             let destination = segue.destination as? DetailSubmissionViewController,
             let bugIndex = tableView.indexPathForSelectedRow?.row
         {
             destination.titleStringViaSegue = speciesList[bugIndex].name
             destination.bugID = speciesList[bugIndex].id
         }
     }
}

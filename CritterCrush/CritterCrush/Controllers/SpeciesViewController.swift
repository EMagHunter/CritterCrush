//
//  SpeciecsViewController.swift
//  CritterCrush
//
//  Created by Ana Fuentes on 3/5/23.
//

import UIKit

class SpeciesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

   // @IBOutlet var speciesTitle: UILabel!
    @IBOutlet var tableView: UITableView!
    
    //let speciesList = listSpecies
    
    //let speciesList:Array<Species> = [SLF,ALB,EAB,SPM]
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        self.performSegue(withIdentifier: "showDetailView", sender: self)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return speciesList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SpeciesCell", for: indexPath) as! SpeciesCell
        
        cell.nameLabel.text = speciesList[indexPath.row].name
        
        cell.scienceLabel.text = speciesList[indexPath.row].science
        
        let imgName = "icon/icon_bug\(speciesList[indexPath.row].id)"
        cell.iconImage.image = UIImage(named: imgName)
        
        return cell
    }
    
    let detailSegueIdentifier = "showDetailView"

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == detailSegueIdentifier,
            let destination = segue.destination as? SpeciesDetailViewController,
            let bugIndex = tableView.indexPathForSelectedRow?.row
        {
            destination.titleStringViaSegue = speciesList[bugIndex].name
            destination.bugID = speciesList[bugIndex].id
        }
    }

}

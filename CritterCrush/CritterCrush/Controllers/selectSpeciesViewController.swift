//
//  selectSpeciesViewController.swift
//  CritterCrush
//
//  Created by Ana Fuentes on 3/12/23.
//

import UIKit

class selectSpeciesViewController: UITableViewController {
    var selectedSpecies = ""
    
    let allSpecies = [
        "",
        "spotted lanternfly",
        "asian longhorned beetle",
        "emerald ash borer",
        "spongy moth"
    ]
    var selectedPath = IndexPath()
    var indexPath = 0
    override func viewDidLoad() {
      super.viewDidLoad()
        for i in 0..<allSpecies.count {
        if allSpecies[i] == selectedSpecies {
          selectedPath = IndexPath(row: i, section: 0)
            break
            }
        }
    }
    override func tableView( _ tableView: UITableView, numberOfRowsInSection section: Int ) -> Int {
      return allSpecies.count
    }
    override func tableView( _ tableView: UITableView, cellForRowAt path: IndexPath ) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell( withIdentifier: "Box", for: path)
        
      let speciesName = allSpecies[path.row]
      cell.textLabel!.text = speciesName
        
      if speciesName == selectedSpecies {
        // change the checkmark for somethig more unique
          cell.accessoryType = .checkmark
          indexPath = path.row
      } else {
          cell.accessoryType = .none
      }
        return cell
    }
    override func tableView( _ tableView: UITableView, didSelectRowAt path: IndexPath
    ){
        if path.row != selectedPath.row {
            if let newCell = tableView.cellForRow(at: path) {
                //change it to something more unique
                newCell.accessoryType = .checkmark
                indexPath = path.row
            }
            if let oldCell = tableView.cellForRow( at: selectedPath) {
                oldCell.accessoryType = .none
                
            }
            selectedPath = path
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?
    ){
    if segue.identifier == "didPickSegue" {
        selectedSpecies = allSpecies[indexPath]
        }
        
    }
}
        

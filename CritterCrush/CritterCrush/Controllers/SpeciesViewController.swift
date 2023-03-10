//
//  SpeciecsViewController.swift
//  CritterCrush
//
//  Created by Ana Fuentes on 3/5/23.
//

import UIKit

class SpeciesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var bugName: UILabel!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    //MARK: table
    
    //TableView: icons of our bugs
    // 2 columns
    //links to species detail view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
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

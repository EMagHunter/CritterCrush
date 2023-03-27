//
//  SingleSubmissionViewController.swift
//  CritterCrush
//
//  Created by min joo on 3/10/23.
//

import UIKit

class SingleSubmissionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    //STRUCT TO PASS REPORTS
    struct bugReport{
        var subID: Int = 0 //report ID
        var bugID: Int = 0 //bugID
        var subDate: String
        //we only need report ID
    }
    //
    
    @IBOutlet weak var tableView: UITableView!
    
    var selectedReportID: Int?
  
        override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "singlesubmissioncell", for: indexPath) as! SingleSubmissionCell
        
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

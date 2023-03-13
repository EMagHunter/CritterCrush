//
//  AddSpeciesViewController.swift
//  CritterCrush
//
//  Created by Ana Fuentes on 3/12/23.
//
import UIKit
import CoreLocation
//private let dateFormatter: DateFormatter = {
//    let formatter = DateFormatter()
//    formatter.dateStyle = .medium
//    formatter.timeStyle = .short
//    return formatter
//}()
class AddSpeciesViewController: UITableViewController {
    @IBOutlet var speciesNameLabel: UILabel!
    @IBOutlet var speciesDescriptionTextView: UITextView!
    @IBOutlet var addressLabel: UILabel!
    var placemark: CLPlacemark?
    var Address = ""
    var speciesName = ""
    @IBOutlet weak var datePicker: UIDatePicker!
  // MARK: - Actions
    @IBAction func submit() {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func reset() {
        navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
      super.viewDidLoad()
        speciesDescriptionTextView.text = ""
        speciesNameLabel.text = speciesName
        if Address != ""{
            addressLabel.text = Address
        } else {
            addressLabel.text = "No Address Found"
        }
    }

    @IBAction func AddressAdded(
      _ segue: UIStoryboardSegue
    ){
    let controller = segue.source as! AddressUploadViewController
        Address = controller.addressAdded
        placemark = controller.placemark
        addressLabel.text = Address
    }
    override func prepare(for segue: UIStoryboardSegue, sender:
    Any?) {
        if segue.identifier == "AddressAdder" {
            let controller = segue.destination as! AddressUploadViewController
            controller.placemark = placemark
            controller.addressAdded = Address
      }
        if segue.identifier == "selectSpecies" {
            let controller = segue.destination as! selectSpeciesViewController
            controller.selectedSpecies = speciesName
        }
    }
    @IBAction func DidPickSpecies(
      _ segue: UIStoryboardSegue
    ){
    let controller = segue.source as! selectSpeciesViewController
        speciesName = controller.selectedSpecies
        speciesNameLabel.text = speciesName
    }
    
    // MARK: - Table View Delegates
//    override func tableView( _ tableView: UITableView, willSelectRowAt indexPath: IndexPath
//    ) -> IndexPath? {
//      if indexPath.section == 0 || indexPath.section == 1 {
//        return indexPath
//      } else {
//    return nil
//    } }
    
}

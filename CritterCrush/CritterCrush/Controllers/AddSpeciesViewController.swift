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
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var uploadImageLabel : UILabel!
    var image: UIImage?
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
            addressLabel.text = ""
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
    
   
    override func tableView( _ tableView: UITableView, didSelectRowAt indexPath: IndexPath ) {
        if indexPath.section == 0 {
            tableView.deselectRow(at: indexPath, animated: true)
            choosePhoto()
        }
    }
    func show(image: UIImage) {
        imageView.image = image
        imageView.isHidden = false
        uploadImageLabel.text = "Image Uploaded"
    }
    
}
extension AddSpeciesViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func getPicWithCamera() {
      let pickerImg = UIImagePickerController()
      pickerImg.sourceType = .camera
      pickerImg.delegate = self
      pickerImg.allowsEditing = true
      present(pickerImg, animated: true, completion: nil)
  }
    func imagePickerController( _ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any] ){
        image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
          if let theImage = image {
            show(image: theImage)
          }
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel( _ picker: UIImagePickerController ){
        dismiss(animated: true, completion: nil)
    }
    func pickImgFromLibrary() {
        let pickerImg = UIImagePickerController()
        pickerImg.sourceType = .photoLibrary
        pickerImg.delegate = self
        pickerImg.allowsEditing = true
        
        
      present(pickerImg, animated: true, completion: nil)
    }
    func choosePhoto() {
      if UIImagePickerController.isSourceTypeAvailable(.camera) {
        showPhotoMenu()
      } else {
          pickImgFromLibrary()
      }
    }
    func showPhotoMenu() {
        let alert = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .actionSheet)
        let actCancel = UIAlertAction(
            title: "Exit",
            style: .cancel,
            handler: nil)
        alert.addAction(actCancel)
        let actPhoto = UIAlertAction(
            title: "Camera",
            style: .default) { _ in
                self.getPicWithCamera()
            }
        alert.addAction(actPhoto)
        let actLibrary = UIAlertAction(
            title: "Gallery",
            style: .default){_ in
                self.pickImgFromLibrary()
            }
        alert.addAction(actLibrary)
        present(alert, animated: true, completion: nil)
        }
    
}

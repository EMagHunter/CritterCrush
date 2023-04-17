//
//  AddSpeciesViewController.swift
//  CritterCrush
//
//  Created by Ana Fuentes on 3/12/23.
//POST: Report
//200: Success
//400: fail, 201: get json, 401: unauthorized

import UIKit
import CoreLocation
import Alamofire
import AlamofireImage
//private let dateFormatter: DateFormatter = {
//    let formatter = DateFormatter()
//    formatter.dateStyle = .medium
//    formatter.timeStyle = .short
//    return formatter
//}()

class AddReportViewController: UITableViewController {
    @IBOutlet var speciesNameLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    var placemark: CLPlacemark?
    var Address = ""
    var speciesName = ""
    @IBOutlet weak var datePicker: UIDatePicker!
    var date:String = ""
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var uploadImageLabel : UILabel!
    var image: UIImage?
    var locationLon: Double = 0
    var locationLat: Double = 0
    let formatter = DateFormatter()
    
    
    @IBOutlet weak var predictBug: UIButton!
    
    var selectedReportEdit:Datum? = nil
    //var selectedReportEdit:Submission? = nil
    
    // MARK: - Actions
    //https://stackoverflow.com/questions/26845307/generate-random-alphanumeric-string-in-swift
    //for image name
    func randomName(length: Int) -> String {
        let allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let allowedCharsCount = UInt32(allowedChars.count)
        var randomString = ""

        for _ in 0 ..< length {
            let randomNum = Int(arc4random_uniform(allowedCharsCount))
            let randomIndex = allowedChars.index(allowedChars.startIndex, offsetBy: randomNum)
            let newCharacter = allowedChars[randomIndex]
            randomString += String(newCharacter)
        }

        return randomString
    }
    
    
    //MARK: Predict
    @IBAction func predict() {
        //API CALL FOR IMAGE RECOGNITION
        predictImage(useImage:image!){ (result: Result<Data, Error>) in
            switch result {
            case .success(let report):
                print(report)
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }//predictImage
        
        
    } // predict
    
    func predictImage(useImage: UIImage, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let imageData = useImage.jpegData(compressionQuality: 0.8) else {
            // Handle error if unable to convert image to data
            return
        }
        
        let hostName =   "69.125.216.66"
        let urlString = "http://\(hostName)/api/critterdetect"
        
        // Define the image upload parameters
        let parameters: [String: Any] = [
            "reportImage": imageData
        ]
        
        let imgName = randomName(length:7)
        print(imgName)
        
        // Use Alamofire to upload the image as a parameter
        AF.upload(
            multipartFormData: { multipartFormData in
                for (key, value) in parameters {
                    if let data = value as? Data {
                        multipartFormData.append(data, withName: key, fileName: "\(imgName).jpg", mimeType: "image/jpeg")
                    } else if let stringValue = value as? String, let data = stringValue.data(using: .utf8) {
                        multipartFormData.append(data, withName: key)
                    }
                }
            },
            to: urlString, method: .get
        ).responseData { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    } //upimage
    
    
    func showPredictAlert(){
        let alert = UIAlertController(
            title: "Predict Image",
            message: "Your image:" ,
            preferredStyle: .alert)
        //        let Action = UIAlertAction(
        //            title: "Exit",
        //            style: .default,
        //            handler: nil)
        //        alert.addAction(Action)
        present(alert, animated: true,completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    
    //MARK: Add Report
    struct Report {
        var userid: Int
        var speciesid: Int
        var numspecimens: Int = 1
        var latitude: Double
        var longitude: Double
        var reportdate: Int
        // var image = UIImage()
    }
    //Submit
    
    @IBAction func submit() {
        formatter.locale = Locale(identifier: "en_us")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        date = formatter.string(from: datePicker.date)
        
        //convert date to epoch time
        let day = datePicker.date.timeIntervalSince1970
        //Date().timeIntervalSince1970
        let loguserID = UserDefaults.standard.object(forKey: "userid") as! Int
        
        let speciesReport = Report(userid: UserDefaults.standard.object(forKey: "userid") as! Int, speciesid: 0, numspecimens: 1, latitude: locationLat, longitude: locationLon, reportdate: Int(day))
        
        print(speciesReport)
        
        let hostName =   "69.125.216.66"
        let afLink = "http://\(hostName)/api/reports"
        
        
        let authToken: String? = KeychainHelper.standard.read(service: "com.crittercrush.authToken", account: "authToken", type: String.self)
        
        let headers: HTTPHeaders = [
            "Authorization": "\(authToken!)"
        ]
        
        let parameter: [String: Data]? = [:]
        
        /*
        AF.upload(
            multipartFormData: { multipartFormData in
                for (key, keyValue) in parameter {
                    if let keyData = keyValue.data(using: .utf8){
                                    multipartFormData.append(keyData, withName: key)
                                }
                }
                multipartFormData.append(self.image!.jpegData(compressionQuality: 0.5)!, withName: "reportImage" , fileName: "\(self.locationLat)\(loguserID)\(self.date).jpeg", mimeType: "image/jpeg")
            },
            to: afLink, method: .post, headers: headers)
        .responseData { response in
            print(response)
            
        }*/
        
        resetLabels()
        
        showSubmitAlert()
    }//submit
    
    @IBAction func reset() {
        showResetAlert()
        resetLabels()
    }
    
    //view
    override func viewDidLoad() {
        super.viewDidLoad()
        if title == "Edit Report"{
            //            print(selectedReportEdit)
        }
        speciesNameLabel.text = speciesName
        if Address != ""{
            addressLabel.text = ""
            addressLabel.text = Address
        } else {
            addressLabel.text = "No Address Found"
        }
    }//view
    
    @IBAction func AddressAdded(
        _ segue: UIStoryboardSegue
    ){
        let controller = segue.source as! AddressUploadViewController
        Address = controller.addressAdded
        placemark = controller.placemark
        addressLabel.text = Address
        locationLat = controller.location!.coordinate.longitude
        locationLon = controller.location!.coordinate.latitude
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
        if indexPath.section == 0 && indexPath.row == 0{
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
extension AddReportViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
    func showSubmitAlert(){
        let alert = UIAlertController(
            title: "Submittion Sucess",
            message: "Thank you For submitting. You can go to the map Screen to see your pins" ,
            preferredStyle: .alert)
        let Action = UIAlertAction(
            title: "Exit",
            style: .default,
            handler: nil)
        alert.addAction(Action)
        present(alert, animated: true,completion: nil)
        
    }
    func showResetAlert(){
        let alert = UIAlertController(
            title: "Reset Sucess",
            message: "The information has been reset" ,
            preferredStyle: .alert)
        //        let Action = UIAlertAction(
        //            title: "Exit",
        //            style: .default,
        //            handler: nil)
        //        alert.addAction(Action)
        present(alert, animated: true,completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
    func resetLabels(){
        speciesName = ""
        speciesNameLabel.text = speciesName
        imageView.image = nil
        imageView.isHidden = true
        Address = ""
        addressLabel.text = Address
        locationLat = 0
        locationLon = 0
        placemark = nil
        datePicker.setDate(Date(), animated: true)
        
    }
    
}

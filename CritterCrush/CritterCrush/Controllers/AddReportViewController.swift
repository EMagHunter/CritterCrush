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
    var speciesID = 1
    @IBOutlet weak var datePicker: UIDatePicker!
    var date:String = ""
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var uploadImageLabel : UILabel!
    var image: UIImage?
    var locationLon: Double = 0
    var locationLat: Double = 0
    let formatter = DateFormatter()
    var report_score = 0
    
    //segue
    var segCoordinate: CLLocationCoordinate2D?
    
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
        //UNWRAP THE RESULT
        //ALSO MAKE IT SO I CANT CLICK IT IF PHOTO IS EMPTY
        if let imgUp = image {
            
            predictImage(useImage:imgUp){ (result: Result<Data, Error>) in
                switch result {
                case .success(let report):
                    do {
                        //let str = String(decoding: report, as: UTF8.self)
                        let asJSON = try JSONSerialization.jsonObject(with: report)
                        if let responseDict = asJSON as? [String: Any],
                           let dataDict = responseDict["data"] as? [String: Any], let bugCount = dataDict["count"] as? Int, let predSpecies = dataDict["speciesid"] as? Int {
                            self.showPredictAlert(message: "Count:  \(bugCount)\nSpecies: \(speciesList[predSpecies-1].name)")
                        }
                    } catch {
                        print("error")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
        
        }//predictImage
    
    } // predict
    
    func predictImage(useImage: UIImage, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let imageData = useImage.jpegData(compressionQuality: 0.5) else {
            // Handle error if unable to convert image to data
            return
        }
        
        let hostName =   localhost.hostname
        let urlString = "\(hostName)/api/critterdetect"
        
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
            to: urlString, method: .post
        ).responseData { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    } //upimage
    
    
    func showPredictAlert(message: String){
        let alert = UIAlertController(
            title: "Image Prediction",
            message: message,
            preferredStyle: .alert)
        let Action = UIAlertAction(
            title: "Close",
            style: .default,
            handler: nil)
        alert.addAction(Action)
        present(alert, animated: true,completion: nil)
        /*
         DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            alert.dismiss(animated: true, completion: nil)
        }*/
    } //predict alert
    
    //MARK: Add Report
    
    @IBAction func submit() {
        
        let imgUp = image!
        upImage(useImage:imgUp){ (result: Result<Data, Error>) in
            switch result {
            case .success(let report):
                let str = String(decoding: report, as: UTF8.self)
                print(str)
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }//predictImage
        
        resetLabels()
        
        showSubmitAlert()
    }//submit
    
    func upImage(useImage: UIImage, completion: @escaping (Result<Data, Error>) -> Void) {
            guard let imageData = useImage.jpegData(compressionQuality: 0.5) else {
                // Handle error if unable to convert image to data
                return
            }
            
            let hostName = localhost.hostname
            let urlString = "\(hostName)/api/reports"
        //headers
            let authToken: String? = KeychainHelper.standard.read(service: "com.crittercrush.authToken", account: "authToken", type: String.self)
            
            let headers: HTTPHeaders = [
                "Authorization": "\(authToken!)"
            ]
            
            // Define the image upload parameters
        
        
        //convert date to epoch time
        let day = Int(datePicker.date.timeIntervalSince1970)
        //Date().timeIntervalSince1970
        let loguserID = UserDefaults.standard.object(forKey: "userid") as! Int
        var bugID = 1
        if let i = speciesList.firstIndex(where: { $0.name == speciesName }) {
            bugID = speciesList[i].id
            print(bugID)
        }
        var lat = 0.0
        var lon = 0.0
        if let unwrapped = segCoordinate {
            lat = unwrapped.latitude
            lon = unwrapped.longitude
            print(segCoordinate)
        } else {
            print("no geocoding")
        }
        
        let param: [String:Any] = [
                "speciesid": bugID,
                "numspecimens": 1,
                "latitude": lat,
                "longitude": lon,
                "reportdate": day,
                "reportImage": imageData
            ]
            
            let imgName = randomName(length:7)
            print(imgName)
            
            // Use Alamofire to upload the image as a parameter
            AF.upload(
                multipartFormData: { multipartFormData in
                    for (key, value) in param {
                        print("\(key), \(value)")
                        if (key != "reportImage") {
                            let entry:String = String(describing: value)
                            multipartFormData.append(entry.data(using: .utf8)!, withName: key)
                        }
                        
                        if let data = value as? Data {
                            multipartFormData.append(data, withName: key, fileName: "\(imgName).jpg", mimeType: "image/jpeg")
                            print("sent value: \(data)")
                        } else if let stringValue = value as? String, let data = stringValue.data(using: .utf8) {
                            print("STRINGVALUE\(stringValue)")
                            multipartFormData.append(data, withName: key)
                        }
                        
                    }
                },
                to: urlString, method: .post, headers:headers
            ).responseData { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } //upimage
    
    //reset
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
        segCoordinate = controller.addressCoord
        locationLat = controller.location?.coordinate.longitude ?? 0.0
        locationLon = controller.location?.coordinate.latitude ?? 0.0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender:
                          Any?) {
        if segue.identifier == "AddressAdder" {
            let controller = segue.destination as! AddressUploadViewController
            controller.placemark = placemark
            controller.addressAdded = Address
            controller.addressCoord = segCoordinate
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

//
//  FridgeViewController.swift
//  IBMCFCShizen01
//
//  Created by アリフ on 2021/06/29.
//

import UIKit
import MapKit
import Alamofire

class FridgeViewController: UITableViewController, UINavigationControllerDelegate {

    var fridge: Fridge!
    var owner: Bool!
    var progressView: UIProgressView!
    var user: User?
    var website: String!
    var fac_location: CLLocationCoordinate2D!
    
    // independent variable
    var mapView: MKMapView!
    var imageView: UIImageView!
    var mapSet = false // fridge is set on map or not
    var itsuploaded = false

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isToolbarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title  = fridge.title
        
        // toolbar setting
        let iconSize = view.frame.size.height * 0.05
        // add camera button on toolbar
        let cameraButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(camera))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        // add progress view
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.widthAnchor.constraint(equalToConstant: iconSize * 3).isActive = true
        progressView.heightAnchor.constraint(equalToConstant: iconSize * 0.2).isActive = true
        progressView.isHidden = true
        let progressBar = UIBarButtonItem(customView: progressView)
        
        if owner == true{
            toolbarItems = [spacer, cameraButton, spacer, progressBar]
        } else {
            toolbarItems = [spacer,progressBar]
        }
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Name"
        //case 1:
        //    return "Description"
        case 1:
            return "Location"
        case 2:
            return "Image"
        default:
            return ""
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell: UITableViewCell
            if owner != true {
                cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath)
                cell.textLabel?.text = fridge.title
                cell.textLabel?.isEnabled = false
            } else {
                cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell", for: indexPath)
                if let cellTextField = cell.viewWithTag(1) as? UITextField{
                    if fridge.id > 0 || fridge.title != "" {
                        cellTextField.text = fridge.title
                    } else {
                        cellTextField.placeholder = "New fridge name"
                    }
                }
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MapCell", for: indexPath)
            cell.heightAnchor.constraint(equalToConstant: 300).isActive = true
            // Add map to cell
            mapView = MKMapView()
            // registering custom view for show pin on map
            mapView.register(FridgeMarkerView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
            mapView.translatesAutoresizingMaskIntoConstraints = false
            cell.addSubview(mapView)
            mapView.widthAnchor.constraint(equalTo: cell.widthAnchor).isActive = true
            mapView.heightAnchor.constraint(equalTo: cell.heightAnchor).isActive = true
            mapView.delegate = self
            var region: MKCoordinateRegion = mapView.region
            if owner != true {
                mapView.setCenter(fridge.coordinate, animated: true)
                region.center = fridge.coordinate
                
            } else {
                mapView.setCenter(fac_location, animated: true)
                region.center = fac_location
            }
            region.span.latitudeDelta = 0.02
            region.span.longitudeDelta = 0.02
            mapView.setRegion(region, animated: true)
            
            // long press gesture recognizer setting
            if owner == true {
                let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
                lpgr.minimumPressDuration = 0.5
                lpgr.delaysTouchesBegan = true
                lpgr.delegate = self
                mapView.addGestureRecognizer(lpgr)
            }
            // add pin on map for registered fridge
            if fridge.id > 0 {
                mapView.addAnnotation(fridge)
                mapSet = true
            }
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageViewCell", for:  indexPath)
            
            if let imageViewInCell = cell.viewWithTag(1) as? UIImageView{
                imageView = imageViewInCell
                if fridge.id != -1 {
                    imageView.load(url: URL(string: fridge.image)!)
                }
                imageView.translatesAutoresizingMaskIntoConstraints = false
                imageView.heightAnchor.constraint(equalToConstant: 300).isActive = true
            }
            //cell.translatesAutoresizingMaskIntoConstraints = false
            //cell.heightAnchor.constraint(equalToConstant: 300).isActive = true
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubtitleCell", for: indexPath)
            cell.textLabel?.text = "Unexpected Cell"
            cell.detailTextLabel?.text = "Please let admin know for this"
            return cell
        }
    }
    
    @objc func camera(){
        if fridge.title == "" || mapSet == false {
            let ac = UIAlertController(title: "Warning", message: "Make sure the fridge name is typed and location is set", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default))
            present(ac,animated: true)
        } else {
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            //picker.sourceType = .savedPhotosAlbum
            picker.allowsEditing = true
            picker.delegate = self
            present(picker, animated: true)
        }
    }

    func upload(image: UIImage, title: String = UUID().uuidString, progressCompletion: @escaping (_ percent: Float) -> Void, completion: @escaping() -> Void){
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            let ac = UIAlertController(title: "conversion Error", message: "Image cannot be converted to JPEG", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            return
        }
        let identity = user?.identity ?? "noidentity"
        let password = user?.password ?? "nopassword"
        let latitude = String(fridge.coordinate.latitude)
        let longitude = String(fridge.coordinate.longitude)
        let fridge_id = String(fridge.id)
        Alamofire.upload(multipartFormData: { multipartFormData in
            // Parameters value set
            multipartFormData.append(title.data(using: .utf8)!, withName: "title")
            multipartFormData.append(fridge_id.data(using: .utf8)!, withName: "fridge_id")
            multipartFormData.append(identity.data(using: .utf8)!, withName: "identify")
            multipartFormData.append(password.data(using: .utf8)!, withName: "password")
            multipartFormData.append(latitude.data(using: .utf8)!, withName: "latitude")
            multipartFormData.append(longitude.data(using: .utf8)!, withName: "longitude")
            multipartFormData.append(imageData, withName: "image", fileName: "image.jpg", mimeType: "image/jpeg")
        },
        //to: "https://polite-whistler-62234.herokuapp.com/uploadimage",
        //to: "https://comfridge.herokuapp.com/uploadimage",
        to: "\(website!)/uploadimage",
        headers: ["Authorization": "Basic ifneedit"],
        encodingCompletion: {encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.uploadProgress { progress in
                    progressCompletion(Float(progress.fractionCompleted))
                }
                upload.validate()
                upload.responseJSON { response in
                    self.dismiss(animated: false, completion: nil)
                    let ac = UIAlertController(title: "Uploaded", message: "Upload progress completed", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "Ok", style: .default))
                    self.present(ac,animated: true)
                    self.navigationItem.hidesBackButton = false
                    self.getRate()
                }
            
            case .failure(let encodingError):
                //print(encodingError)
                self.dismiss(animated: false, completion: nil)
                self.navigationItem.hidesBackButton = false
                let ac = UIAlertController(title: "Upload failed", message: "\(encodingError.localizedDescription)", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "閉じる", style: .cancel))
                self.present(ac, animated: true)
            }
        })
    }
    func getRate(){
        let paramsString = "/apis/get_fridge?identify=\(user?.identity ?? "")&password=\(user?.password ?? "")&fridge_id=\(fridge.id)"
        if let url = URL(string: website + paramsString){
            if let data = try? Data(contentsOf: url){
                let code = parseMetadata(json: data)
                if code == 200 {
                    let decoder = JSONDecoder()
                    if let jsonUser = try? decoder.decode(Results.self, from: data){
                        var arrayString = [String]()
                        arrayString = jsonUser.results
                        fridge.currentVolume = Int(arrayString[0]) ?? 0
                        fridge.id = Int(arrayString[1]) ?? -1
                        fridge.image = "\(website ?? "")\(arrayString[2])"
                    }
                    //navigationItem.hidesBackButton = false
                  
                } else {
                   // navigationItem.hidesBackButton = false
                }
                
            }
        }
    }
    
    func parseMetadata(json: Data) -> Int {
        let decoder = JSONDecoder()
        if let jsonMetadata = try? decoder.decode(Metadata.self, from: json){
            return jsonMetadata.metadata.responseInfo.status
        } else {
            return 0
        }
    }
}

// to set pin on map
extension FridgeViewController: MKMapViewDelegate, UIGestureRecognizerDelegate {
    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer){
        if gestureRecognizer.state != UIGestureRecognizer.State.ended  {
            let touchLocation = gestureRecognizer.location(in: mapView)
            let locationCoordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
            fridge.coordinate = locationCoordinate
            mapSet = true
            if mapView.annotations.count > 0 {
                mapView.removeAnnotation(fridge)
            }
            fridge.coordinate = locationCoordinate
            mapView.addAnnotation(fridge)
            return
        }
        if gestureRecognizer.state != UIGestureRecognizer.State.began{
            return
        }
    }
}

extension FridgeViewController: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        fridge.title = textField.text
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

extension FridgeViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true)
        guard let image = info[.editedImage] as? UIImage else { return }
        imageView.image = image
        progressView.isHidden = false
        navigationItem.hidesBackButton = true
        itsuploaded = true
        
        let alert = UIAlertController(title: nil, message: "🙇🏻‍♂️Please wait...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.large
        loadingIndicator.startAnimating()
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        upload(image: image, title: fridge.title ?? "", progressCompletion: {[weak self] percent in
            self?.progressView.setProgress(percent, animated: true)
        },
        completion: {[weak self] in
            self?.progressView.isHidden = true
        })
    }
}




//
//  ViewController.swift
//  IBMCFCShizen01
//
//  Created by アリフ on 2021/06/29.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    // Map Variables
    var mapView: MKMapView!
    var facilities = [Facility]()
    
    // Web domain
    var website = "https://comfridge.herokuapp.com"
    
    // User
    var user: User!
    var user_setting = Setting(identity: "", password: "", phrase: "")
    
    override func viewWillAppear(_ animated: Bool) {
        //show toolbar
        navigationController?.isToolbarHidden = false
        mapView.removeAnnotations(facilities)
        retrieveFacilities()
        mapView.addAnnotations(facilities)
    
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // init user
        user_init()
        
        // Add map into view
        mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        mapView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        mapView.delegate = self
        
        // Title set
        title = "Fridge Scope"
        
        // Setup toolbar
        //navigationController?.isToolbarHidden = false
        
        let cameraButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(camera))
        let settingButton = UIBarButtonItem(barButtonSystemItem: .organize , target: self, action: #selector(setting))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    
        toolbarItems = [spacer, cameraButton, spacer, settingButton, spacer]
        
        // Centering map and boundary
        let sbsCenter = CLLocation(latitude: 34.96044797500092, longitude: 138.4044472577484)
        let region = MKCoordinateRegion(center: sbsCenter.coordinate, latitudinalMeters: 50000, longitudinalMeters: 60000)
        mapView.setCameraBoundary(MKMapView.CameraBoundary(coordinateRegion: region), animated: true)
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 200000)
        mapView.setCameraZoomRange(zoomRange, animated: true)
        
        // register annotationView
        mapView.register(
          FacilityMarkerView.self,
          forAnnotationViewWithReuseIdentifier:
            MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        // sample pin on map
        retrieveFacilities()
        
        // add pin to map
        mapView.addAnnotations(facilities)
    }
    
    // Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let facilityToShow: Facility
        if sender is Facility{
            // not an owner facility
            facilityToShow = sender as! Facility
        } else {
            // owner of facility
            facilityToShow = user.facility
        }
        // not an owner facility -> show fridges in facility
        if let facilityViewController = segue.destination as? FacilityViewController{
            facilityViewController.facility = facilityToShow
            facilityViewController.website = website
        }
        // owner of facility -> need to login.
        if let facilityViewController = segue.destination as? LoginViewController{
            //facilityViewController.facility = facilityToShow
            facilityViewController.user = user
            facilityViewController.website = website
        }
    }
    
    @objc func camera(){
        
    }
  
    
    @objc func setting(){
        // show facility
        performSegue(withIdentifier: "ShowLogin", sender: view)
    }
    
    func user_init(){
        let ownFacility = Facility(id: -1, title: "unamed", content: "unregister", coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0), fridges: []) // dummy facility for first user
        user = User(phrase: "", identity: "", name: "", email: "", password: "", facility: ownFacility, authenticated: false)
        load()

    }
    
    func load(){
        do {
            let path = IOHelper.getDocumentsDirectory().appendingPathComponent("user")
            let data = try Data(contentsOf: path)
            user_setting = try(NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Setting) ?? Setting(identity: "", password: "", phrase: "")
            performSelector(inBackground: #selector(lightLogin), with: nil)
        } catch {
            let ac = UIAlertController(title: "Fridge Scope", message: "Welcome to the community, you may tap any pin on map and see what inside the refrigerator. For Facility manager, please go to ⚙️ icon for login and customize the facility site.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default))
            present(ac, animated: true)
        }
    }
    
    @objc func lightLogin(){
        let paramsString = "/apis/lightlogin?identify=\(user_setting.identity)&password=\(user_setting.password)"
        if let url = URL(string: website + paramsString){
            if let data = try? Data(contentsOf: url){
                let code = parseMetadata(json: data)
                if code == 200 {
                    user.authenticated = true
                    user.phrase = user_setting.phrase
                    user.identity = user_setting.identity
                    user.password = user_setting.password
                    retrieveUserFacility()
                } else {
                    user.authenticated = false
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
    
    func retrieveFacilities(){
        let paramsString = "/apis/retrieve_facilities"
        facilities.removeAll()
        if let url = URL(string: website + paramsString){
            if let data = try? Data(contentsOf: url){
                let decoder = JSONDecoder()
                if let jsonFacility = try? decoder.decode(Facs.self, from: data){
                    var facs: [Fac]
                    facs = jsonFacility.facilities
                    for fac in facs {
                        var fris = [Fridge]()
                        for fri in fac.fridges{
                            let tempFridge = Fridge(id: fri.id, title: fri.name, content: fri.description, time: fri.date, image: "\(website)\(fri.image)", currentVolume: Int(fri.rate), coordinate: CLLocationCoordinate2D(latitude: Double(fri.lat) ?? 0.0, longitude: Double(fri.lon) ?? 0.0))
                            fris.append(tempFridge)
                        }
                        let facility = Facility(id: fac.id, title: fac.name, content: "", coordinate: CLLocationCoordinate2D(latitude: Double(fac.lat) ?? 0.0, longitude: Double(fac.lon) ?? 0.0), fridges: fris)
                        facilities.append(facility)
                    }
                }
            }
        }
    }
    
    func retrieveUserFacility(){
        let paramsString = "/apis/retrieve_fridges?identify=\(user.identity)&password=\(user.password)"
        if let url = URL(string: website + paramsString){
            if let data = try? Data(contentsOf: url){
                let decoder = JSONDecoder()
                if let jsonFacility = try? decoder.decode(UserFac.self, from: data){
                    let fac: Fac
                    fac = jsonFacility.facility
                    user.facility.id = fac.id
                    user.facility.title = fac.name
                    user.facility.coordinate = CLLocationCoordinate2D(latitude:
                                                                        Double(fac.lat) ?? 0.0, longitude: Double(fac.lon) ?? 0.0)
                    user.facility.currentVolume = Int(fac.rate)
                    user.facility.fridges.removeAll()
                    for fri in fac.fridges{
                        user.facility.fridges.append(Fridge(id: fri.id, title: fri.name, content: fri.description, time: fri.date, image: "\(website)\(fri.image)", currentVolume: Int(fri.rate), coordinate: CLLocationCoordinate2D(latitude: Double(fri.lat) ?? 0.0, longitude: Double(fri.lon) ?? 0.0)))
                    }
                }
            }
        }
    }
  
}

extension ViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let facility = view.annotation as? Facility else {
            return
        }
        performSegue(withIdentifier: "ShowFacility", sender: facility)
        
    }
}

extension UIImageView{
    func load(url: URL){
        DispatchQueue.global().async {
            [weak self] in
            if let data = try? Data(contentsOf: url){
                if let image = UIImage(data: data){
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

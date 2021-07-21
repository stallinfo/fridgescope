//
//  FacilityViewController.swift
//  IBMCFCShizen01
//
//  Created by アリフ on 2021/06/29.
//

import UIKit
import MapKit
import CoreLocation

class FacilityViewController: UITableViewController {

    // Facility
    var facility: Facility!
    var owner: Bool!
    var user: User?
    var website: String!
    
    // Map
    let locationManager = CLLocationManager()
    var userLocation = CLLocationCoordinate2D()
    
    var delFridge: Fridge?
    
    override func viewWillAppear(_ animated: Bool) {
        if owner == true {
            //retrieveUserFacility()
            performSelector(inBackground: #selector(retrieveUserFacility), with: nil)
        }
        //tableView.reloadData()
        navigationController?.isToolbarHidden = true

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set default facility cell
        title = facility.title
        if owner == true {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFridge))
        }
        tableView.tableFooterView = UIView()
        
        // GPS Setting
        if owner == true {
            locationManager.requestWhenInUseAuthorization()
            if CLLocationManager.locationServicesEnabled(){
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.startUpdatingLocation()
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return facility.fridges.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = facility.fridges[indexPath.row].title
        cell.detailTextLabel?.text = "\(facility.fridges[indexPath.row].currentVolume)%"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if owner == true{
            return indexPath.section == 0
        } else {
            return indexPath.section == 1
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        delFridge = facility.fridges[indexPath.row]
        performSelector(inBackground: #selector(deleteFridge), with: nil)
        facility.fridges.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    @objc func deleteFridge(){
        let paramsString = "/apis/del_fridge?identify=\(user?.identity ?? "")&password=\(user?.password ?? "")&fridge_id=\(delFridge?.id ?? 0)"
        if let url = URL(string: website + paramsString){
            if let data = try? Data(contentsOf: url){
                let code = parseMetadata(json: data)
                if code == 200 {
                } else {
                }
            }
        }
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let fridgeToShow: Fridge
        if sender is Fridge{
            fridgeToShow = sender as! Fridge
        } else {
            guard let selectedIndexPath = tableView.indexPathForSelectedRow else { return }
            fridgeToShow = facility.fridges[selectedIndexPath.row]
        }

        if let fridgeViewController = segue.destination as? FridgeViewController{
            fridgeViewController.fridge = fridgeToShow
            fridgeViewController.owner = owner
            fridgeViewController.user = user
            fridgeViewController.website = website
            fridgeViewController.fac_location = facility.coordinate
        }
    }
    
    @objc func addFridge(){
        let newFridge = Fridge(id: -1, title: "", content: "", time: "", image: "", currentVolume: 0, coordinate: facility.coordinate)
        facility.fridges.append(newFridge)
        performSegue(withIdentifier: "ShowFridge", sender: newFridge)
    }

    func parseMetadata(json: Data) -> Int {
        let decoder = JSONDecoder()
        if let jsonMetadata = try? decoder.decode(Metadata.self, from: json){
            return jsonMetadata.metadata.responseInfo.status
        } else {
            return 0
        }
    }
    
    @objc func retrieveUserFacility(){
        guard let tempUser = user else {return}
        let paramsString = "/apis/retrieve_fridges?identify=\(tempUser.identity)&password=\(tempUser.password)"
        if let url = URL(string: website + paramsString){
            if let data = try? Data(contentsOf: url){
                let decoder = JSONDecoder()
                if let jsonFacility = try? decoder.decode(UserFac.self, from: data){
                    let fac: Fac
                    fac = jsonFacility.facility
                    tempUser.facility.id = fac.id
                    tempUser.facility.title = fac.name
                    tempUser.facility.coordinate = CLLocationCoordinate2D(latitude:
                                                                        Double(fac.lat) ?? 0.0, longitude: Double(fac.lon) ?? 0.0)
                    tempUser.facility.currentVolume = Int(fac.rate)
                    tempUser.facility.fridges.removeAll()
                    for fri in fac.fridges{
                        tempUser.facility.fridges.append(Fridge(id: fri.id, title: fri.name, content: fri.description, time: fri.date, image: "\(website ?? "")\(fri.image)", currentVolume: Int(fri.rate), coordinate: CLLocationCoordinate2D(latitude: Double(fri.lat) ?? 0.0, longitude: Double(fri.lon) ?? 0.0)))
                    }
                }
            }
        }
        performSelector(onMainThread: #selector(reloadTable), with: nil, waitUntilDone: false)
    }
    
    @objc func reloadTable(){
        tableView.reloadData()
        title = self.facility.title
    }
}

extension FacilityViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = CLLocationCoordinate2D(latitude: locations.last!.coordinate.latitude, longitude: locations.last!.coordinate.longitude)
        locationManager.stopUpdatingLocation()
    }
}


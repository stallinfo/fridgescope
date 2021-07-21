//
//  LoginViewController.swift
//  IBMCFCShizen01
//
//  Created by アリフ on 2021/06/29.
//

import UIKit

class LoginViewController: UITableViewController {

    //var facility: Facility!
    var user: User!
    var website: String!
    var service = Service(name: "", desc: "")
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        navigationController?.isToolbarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Facility"
        case 1:
            return "Menu"
        default:
            return ""
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 2
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubtitleCell", for: indexPath)
            if user.authenticated == true {
                cell.textLabel?.text = user.facility.title
                cell.detailTextLabel?.text = user.identity
            } else {
                cell.textLabel?.text = "Fac.Setting"
                cell.detailTextLabel?.text = "You need to sign in to manage your facility"
            }
            return cell
        case 1:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath)
                cell.textLabel?.text = "Sign in"
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "RightDetailCell", for: indexPath)
                cell.textLabel?.text = "Fridge setting"
                cell.detailTextLabel?.text = "\(user.facility.fridges.count)📦"
                if user.authenticated == false {
                    cell.isUserInteractionEnabled = false
                    cell.detailTextLabel?.text = "inactive"
                } else {
                    cell.isUserInteractionEnabled = true
                }
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SubtitleCell", for: indexPath)
                cell.textLabel?.text = "Error"
                cell.detailTextLabel?.text = "Record not found"
                return cell
            }
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubtitleCell", for: indexPath)
            cell.textLabel?.text = "Error"
            cell.detailTextLabel?.text = "Record not found"
            return cell
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let signInViewController = segue.destination as? SignInViewController{
            signInViewController.user = user
            signInViewController.website = website
            signInViewController.service = service
        }
        if let facilityViewController = segue.destination as? FacilityViewController{
            facilityViewController.facility = user.facility
            facilityViewController.owner = true
            facilityViewController.user = user
            facilityViewController.website = website
        }
    }
}

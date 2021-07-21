//
//  SignInViewController.swift
//  IBMCFCShizen01
//
//  Created by アリフ on 2021/06/29.
//

import UIKit

class SignInViewController: UITableViewController {

    var user: User!
    var confirmPassword: String?
    var website: String!
    var service: Service!
    var user_setting: Setting!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Authentification"
        tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Service connection phrase (sent to you)"
        case 1:
            return "Identify (sent to you)"
        case 2:
            return "Password"
        case 3:
            return "Confirm password"
        case 4:
            return "Full name"
        case 5:
            return "Email"
        default:
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < 5 {
            return 1
        } else {
            return 2
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell", for: indexPath)
            switch indexPath.section {
            case 0:
                if let cellTextField = cell.viewWithTag(1) as? UITextField {
                    cellTextField.placeholder = "FridgeScope#12345"
                    cellTextField.tag = 901
                }
            case 1:
                if let cellTextField = cell.viewWithTag(1) as? UITextField{
                    cellTextField.placeholder = "YFITNEDI001"
                    cellTextField.tag = 902
                }
            case 2:
                if let cellTextField = cell.viewWithTag(1) as? UITextField{
                    cellTextField.isSecureTextEntry = true
                    cellTextField.tag = 903
                }
            case 3:
                if let cellTextField = cell.viewWithTag(1) as? UITextField{
                    cellTextField.isSecureTextEntry = true
                    cellTextField.tag = 904
                }
            case 4:
                if let cellTextField = cell.viewWithTag(1) as? UITextField{
                    cellTextField.placeholder = "John Doe"
                    cellTextField.tag = 905
                }
            case 5:
                if let cellTextField = cell.viewWithTag(1) as? UITextField{
                    cellTextField.placeholder = "lorem@ipsum.com"
                    cellTextField.tag = 906
                }
            default:
                if let cellTextField = cell.viewWithTag(1) as? UITextField {
                    cellTextField.placeholder = "SBS情報システム"
                }
            }
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BlankCell", for: indexPath)
                cell.textLabel?.text = "To submit press i button on the right"
            cell.accessoryType = .detailDisclosureButton
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        if indexPath.section == 5 && indexPath.row == 1 {
       
            user_authetification()
        }
    }
    
    func user_authetification(){
        
        
        //user.authenticated = true
        // sample change
        // user.facility.title = "Sunshine Fridge"
        // user.facility.content = "Fride for connecting people!"
        //let deviceName = UIDevice().name
        
        // for temporary
        //user.phrase = "SZK01"
        //user.identity = "shizumania"
        //user.password = "aaaaaaaa"
        //confirmPassword = user.password
        //user.email = "maulanamania@gmail.com"
        // ---- end temporary
        
        if user.password != confirmPassword{
            let ac = UIAlertController(title: "Login failed", message: "Password not match", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            return
        }
        
        let paramsString = "/apis/login?connection_phrase=\(user.phrase)&identify=\(user.identity)&password=\(user.password)&email=\(user.email)"
        if let url = URL(string: "\(website ?? "")\(paramsString)"){
            if let data = try? Data(contentsOf: url){
                let code = parseMetadata(json: data)
                if code == 200 {
                    user.authenticated = true
                    title = "Autheticated🤩"
                    let decoder = JSONDecoder()
                    if let jsonUser = try? decoder.decode(Results.self, from: data){
                        let userInfo: [String]
                        userInfo = jsonUser.results
                        if userInfo != [] {
                            service.name = userInfo[0]
                            service.desc = userInfo[1]
                            user.facility.id = Int(userInfo[2])
                            user.facility.title = userInfo[3]
                        }
                    }
                    user_setting = Setting(identity: user.identity, password: user.password, phrase: user.phrase)
               
                    save()
                    
                    let ac = UIAlertController(title: "User Authenticated", message: "Your facility features are ready to use. Please return to previous page by pressing back button on the top left side.", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    present(ac, animated: true)
                } else {
                   
                    let ac = UIAlertController(title: "Login failed", message: "Please re-type the identification or contact administrator", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    present(ac, animated: true)
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
    @objc func save(){
        do{
            let path = IOHelper.getDocumentsDirectory().appendingPathComponent("user")
            let data = try NSKeyedArchiver.archivedData(withRootObject: user_setting!, requiringSecureCoding: false)
            try data.write(to: path)
        } catch {
            errorMessage(errorMessage: error.localizedDescription)
        }
    }
    func errorMessage(errorMessage: String, errorTitle: String = "Error!😫"){
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
}

extension SignInViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 901:
            user.phrase = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        case 902:
            user.identity = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        case 903:
            user.password = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        case 904:
            confirmPassword = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        case 905:
            user.name = textField.text ?? ""
        case 906:
            user.email = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        default:
            user.phrase = ""
        }
    }
}


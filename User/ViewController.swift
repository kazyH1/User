//
//  ViewController.swift
//  User
//
//  Created by HuyNguyen on 25/05/2023.
//

import UIKit
import Alamofire
import NVActivityIndicatorView

struct User: Codable {
    let id: Int
    let email: String
    let first_Name: String
    let last_Name: String
    let avatar: String
}

class ViewController: UIViewController {
    
    @IBOutlet weak var tbvUser: UITableView!
    
    var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        registerTableviewCell()
        fetchUsers()
    }
    
    func fetchUsers() {
        let activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 45, height: 45), type: .ballPulse, color: .gray)
        self.view.addSubview(activityIndicator)
        activityIndicator.center = self.view.center
        activityIndicator.startAnimating()
        
        let apiUrl = "https://reqres.in/api/users"
        
        AF.request(apiUrl).responseJSON { [weak self] response in
            activityIndicator.stopAnimating()
            
            switch response.result {
            case .success(let value):
                if let json = value as? [String: Any],
                   let dataArray = json["data"] as? [[String: Any]] {
                    let decoder = JSONDecoder()
                    if let jsonData = try? JSONSerialization.data(withJSONObject: dataArray, options: []),
                       let users = try? decoder.decode([User].self, from: jsonData) {
                        self?.users = users
                        self?.tbvUser.reloadData()
                    }
                } else {
                    self?.alertController(inputTitleController: "Error", titleButtonOK: "OK", titleButtonCancel: "", inputMessage: "Failed to load users.") { result in
                    }
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                self?.alertController(inputTitleController: "Error", titleButtonOK: "OK", titleButtonCancel: "", inputMessage: "Failed to load users.") { result in
                }
            }
        }
    }
    
    private func alertController(inputTitleController: String, titleButtonOK: String, titleButtonCancel: String, inputMessage: String, completion: @escaping (_ result: Bool) -> Void) {
        let alert = UIAlertController(title: inputTitleController, message: inputMessage, preferredStyle: .alert)
        if titleButtonOK != "" {
            alert.addAction(UIAlertAction(title: titleButtonOK,style: .default, handler: { _ in
                completion(true)
            }))
        }
        if titleButtonCancel != "" {
            alert.addAction(UIAlertAction(title: titleButtonCancel,style: .cancel, handler: { _ in
                completion(false)
            }))
        }
        present(alert, animated: true, completion: nil)
    }
}


extension ViewController: UITableViewDelegate,UITableViewDataSource {
    private func registerTableviewCell() {
        tbvUser.delegate = self
        tbvUser.dataSource = self
        tbvUser.register(UINib(nibName: "NameEmployeeTableViewCell", bundle: nil), forCellReuseIdentifier: "cell1")
        tbvUser.register(UINib(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "cell2")
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tbvUser.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! NameTableViewCell
            let data = users[indexPath.row]
            cell.configCell(data: data)
            return cell
        } else {
            let cell = tbvUser.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! ProfileTableViewCell
            let data = users[indexPath.row]
            cell.configCell(data: data)
            return cell
        }
    }
}




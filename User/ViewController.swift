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
    var email, firstName, lastName, avatar : String
    var id: Int
    
    enum CodingKeys: String, CodingKey {
        case email = "email"
        case firstName = "first_name"
        case lastName = "last_name"
        case avatar = "avatar"
        case id = "id"
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var tbvUser: UITableView!
    
    var users: [User] = []
    var loading: NVActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        registerTableviewCell()
        loading = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 45, height: 45), type: .ballPulse, color: .gray)
        self.view.addSubview(loading!)
        loading!.center = self.view.center
        fetchUsers()

        
    }
    
    func fetchUsers() {
        loading!.startAnimating()
        
        let apiUrl = "https://reqres.in/api/users"
        
        AF.request(apiUrl).responseJSON { [weak self] response in
            self?.loading!.stopAnimating()
            
            switch response.result {
            case .success(let value):
                if let json = value as? [String: Any],
                   let dataArray = json["data"] as? [[String: Any]] {
                    let decoder = JSONDecoder()
                    if let jsonData = try? JSONSerialization.data(withJSONObject: dataArray, options: []) {
                        do {
                            var user = try JSONDecoder().decode([User].self, from: jsonData)
                            self?.users = user
                            self?.tbvUser.reloadData()

                        } catch {
                            print("Decoding Error : \(error)")
                        }
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
    func registerTableviewCell() {
        tbvUser.delegate = self
        tbvUser.dataSource = self
        tbvUser.register(UINib(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tbvUser.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProfileTableViewCell
            let data = users[indexPath.row]
            cell.configCell(data: data)
            return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        210
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let selectedUser = users[indexPath.row]
           
           if (selectedUser.id+1) % 2 == 0 {
               let sb = UIStoryboard(name: "Main", bundle: nil)
               let otherVC = sb.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
               otherVC.user = selectedUser
               self.navigationController?.present(otherVC, animated: true)
           } else {
               let sb = UIStoryboard(name: "Main", bundle: nil)
               let profile = sb.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
               profile.user = selectedUser
               self.navigationController?.pushViewController(profile, animated: true)
           }
    }
}




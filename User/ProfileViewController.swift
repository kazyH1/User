//
//  ProfileViewController.swift
//  User
//
//  Created by HuyNguyen on 06/06/2023.
//

import UIKit

class ProfileViewController: UIViewController {
    var user: User?

    @IBOutlet weak var lbId: UILabel!
    @IBOutlet weak var lbEmail: UILabel!
    @IBOutlet weak var imageUser: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = user {
            lbName.text = "\(user.firstName) \(user.lastName)"
            lbId.text = "\(user.id)"
            lbEmail.text = user.email
            if let url = URL(string: user.avatar) {
                if let data = try? Data(contentsOf: url) {
                    self.imageUser.image = UIImage(data: data)
                }
            }
        }
        
    }
}

//
//  ProfileTableViewCell.swift
//  User
//
//  Created by HuyNguyen on 25/05/2023.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbId: UILabel!
    @IBOutlet weak var imageUser: UIImageView!
    @IBOutlet weak var lbProfile: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    func configCell(data: User) {
        lbId.text = "\(data.id)"
        lbName.text = "\(data.firstName) \(data.lastName)"
        lbProfile.text = data.email
        if let url = URL(string: data.avatar) {
            if let data = try? Data(contentsOf: url) {
                self.imageUser.image = UIImage(data: data)
            }
        }
    }
}

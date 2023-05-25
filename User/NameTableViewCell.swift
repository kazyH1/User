//
//  NameTableViewCell.swift
//  User
//
//  Created by HuyNguyen on 25/05/2023.
//

import UIKit

class NameTableViewCell: UITableViewCell {
    @IBOutlet weak var lbID: UILabel!
    @IBOutlet weak var lbName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configCell(data: User) {
        lbID.numberOfLines = data.id
        lbName.text = "\(data.first_Name) \(data.last_Name)"
    }
    
}

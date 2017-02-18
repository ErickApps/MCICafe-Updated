//
//  NotiTableViewCell.swift
//  MCICafe
//
//  Created by Erick Barbosa on 2/11/17.
//  Copyright © 2017 Erick Barbosa. All rights reserved.
//

import UIKit

class NotiTableViewCell: UITableViewCell {

    @IBOutlet weak var notificationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

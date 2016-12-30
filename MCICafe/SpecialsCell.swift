//
//  SpecialsCell.swift
//  MCICafe
//
//  Created by Erick Barbosa on 12/27/16.
//  Copyright © 2016 Erick Barbosa. All rights reserved.
//

import UIKit

class SpecialsCell: UITableViewCell {

    @IBOutlet weak var titleCellLabel: UILabel!
    @IBOutlet weak var descriptionCellLabel: UILabel!
    @IBOutlet weak var costCellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  ProductCell.swift
//  CourseWork
//
//  Created by IvanLyuhtikov on 6/10/20.
//  Copyright © 2020 IvanLyuhtikov. All rights reserved.
//

import UIKit

class ProductCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

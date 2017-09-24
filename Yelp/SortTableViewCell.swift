//
//  SortTableViewCell.swift
//  Yelp
//
//  Created by Mushaheed Kapadia on 9/24/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class SortTableViewCell: UITableViewCell {

    @IBOutlet weak var sortTextLabel: UILabel!
    
    var sort: String! {
        didSet {
            sortTextLabel.text = sort
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

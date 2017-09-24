//
//  ShowMoreTableViewCell.swift
//  Yelp
//
//  Created by Mushaheed Kapadia on 9/23/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class ShowMoreTableViewCell: UITableViewCell {

    @IBOutlet weak var showTextLabel: UILabel!
    
    var showingAll: Bool! {
        didSet {
            if showingAll {
                showTextLabel.text = "Show Less"
            }
            else {
                showTextLabel.text = "Show More"
            }
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

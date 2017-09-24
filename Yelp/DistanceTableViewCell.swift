//
//  DistanceTableViewCell.swift
//  Yelp
//
//  Created by Mushaheed Kapadia on 9/23/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class DistanceTableViewCell: UITableViewCell {

    
    @IBOutlet weak var distanceCellView: DistanceTableViewCell!
    @IBOutlet weak var distanceTextLabel: UILabel!
    
    var distance: Int! {
        didSet {
            distanceTextLabel.text = "\(distance!) miles"
        }
    }
    
    var currentlySelected: Bool! {
        didSet {
            if currentlySelected {
                distanceCellView?.backgroundColor! = UIColor.blue
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

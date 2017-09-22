//
//  BusinessTableViewCell.swift
//  Yelp
//
//  Created by Mushaheed Kapadia on 9/21/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessTableViewCell: UITableViewCell {

    @IBOutlet weak var businessImageView: UIImageView!
    @IBOutlet weak var reviewImageView: UIImageView!
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var addrssLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var business: Business! {
        didSet {
            self.businessNameLabel.text = business.name
            self.businessImageView.setImageWith(business.imageURL!)
            self.typeLabel.text = business.categories
            self.addrssLabel.text = business.address
            self.reviewLabel.text = "\(business.reviewCount!) reviews"
            self.reviewImageView.setImageWith(business.ratingImageURL!)
            self.distanceLabel.text = business.distance
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.businessImageView.layer.cornerRadius = 3
        self.businessImageView.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

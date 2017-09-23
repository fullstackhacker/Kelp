//
//  SwitchTableViewCell.swift
//  Yelp
//
//  Created by Mushaheed Kapadia on 9/22/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit


@objc protocol SwitchTableViewCellDelegate {
    @objc optional func switchTableViewCell(switchTableViewCell: SwitchTableViewCell, didChangeValue value: Bool)
}

class SwitchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var switchNameLabel: UILabel!
    @IBOutlet weak var settingSwitch: UISwitch!
    
    weak var delegate: SwitchTableViewCellDelegate?
    
    var category: Category! {
        didSet {
            switchNameLabel.text = category.name ?? ""
        }
    }
    
    var isOn: Bool! {
        didSet {
            print("------")
            print("name", category.name)
            print("setter ",isOn)
            settingSwitch.setOn(isOn, animated: false)
            print("switch state:", settingSwitch.isOn)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func toggleCategory(_ sender: Any) {
        delegate?.switchTableViewCell?(switchTableViewCell: self, didChangeValue: settingSwitch.isOn)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

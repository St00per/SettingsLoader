//
//  SettingsTableViewCell.swift
//  SettingsLoader
//
//  Created by Kirill Shteffen on 21/11/2018.
//  Copyright © 2018 Kirill Shteffen. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    static let name = String(describing: SettingsTableViewCell.self)
    
    @IBOutlet weak var presetNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setLabel(settings: SettingsObject) {
        presetNameLabel.text = settings.preset_name
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

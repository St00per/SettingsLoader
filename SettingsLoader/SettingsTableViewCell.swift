//
//  SettingsTableViewCell.swift
//  SettingsLoader
//
//  Created by Кирилл Штеффен on 21/11/2018.
//  Copyright © 2018 Кирилл Штеффен. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    static let name = String(describing: SettingsTableViewCell.self)
    
    @IBOutlet weak var settingsLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setLabel(settings: SettingsObject){
        settingsLabel.text = settings.settingsTitle
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

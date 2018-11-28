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
    var settingsListController: SettingsListViewController?
    var presetName: String?
    
    
    @IBOutlet weak var presetNameLabel: UILabel!
    
    @IBAction func deletePreset(_ sender: UIButton) {
        let alert = UIAlertController(title: "WARNING", message: "Delete this file?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
            guard let deletingPreset = self.presetName, let dataSource = self.settingsListController?.dataSource else { return }
            let settingsHandler = SettingsHandler()
            settingsHandler.deleteLocalPreset(named: deletingPreset, dataSource: dataSource)
            self.settingsListController?.fillSettingsList()
        }
        let cancel = UIAlertAction(title: "Cancel",
                                         style: .cancel) {(_) in
                                            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(ok)
        alert.addAction(cancel)
        settingsListController?.present(alert, animated: true, completion: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setLabel(settings: SettingsObject) {
        presetNameLabel.text = settings.preset_name
        presetName = settings.preset_name
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

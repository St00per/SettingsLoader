//
//  SettingsListViewController.swift
//  SettingsLoader
//
//  Created by Kirill Shteffen on 21/11/2018.
//  Copyright © 2018 Kirill Shteffen. All rights reserved.
//

import UIKit

class SettingsListViewController: UIViewController {

    var settingsList: [SettingsObject] = []
    
    @IBOutlet weak var settingsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillSettingsList()
    }
    
    func fillSettingsList() {
        let settingsOne = SettingsObject(withParameters: "High Settings", firstInputParameter: "High", secondInputParameter: "High")
        let settingsTwo = SettingsObject(withParameters: "Medium Settings", firstInputParameter: "Medium", secondInputParameter: "Medium")
        let settingsThree = SettingsObject(withParameters: "Low Settings", firstInputParameter: "Low", secondInputParameter: "Low")
        
        settingsList.append(settingsOne)
        settingsList.append(settingsTwo)
        settingsList.append(settingsThree)
    }
}

extension SettingsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.name, for: indexPath) as? SettingsTableViewCell else {
            return UITableViewCell()
        }
        
        cell.setLabel(settings: settingsList[indexPath.row])
        return cell
    }
    
    
}

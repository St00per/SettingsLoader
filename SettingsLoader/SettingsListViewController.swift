//
//  SettingsListViewController.swift
//  SettingsLoader
//
//  Created by Кирилл Штеффен on 21/11/2018.
//  Copyright © 2018 Кирилл Штеффен. All rights reserved.
//

import UIKit

class SettingsListViewController: UIViewController {

    var settingsList: [SettingsObject] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillSettingsList()
    }
    
    func fillSettingsList() {
        let settingsOne = SettingsObject(withParameters: "HighSettings", firstInputParameter: "High", secondInputParameter: "High")
        let settingsTwo = SettingsObject(withParameters: "MediumSettings", firstInputParameter: "Medium", secondInputParameter: "Medium")
        let settingsThree = SettingsObject(withParameters: "LowSettings", firstInputParameter: "Low", secondInputParameter: "Low")
        
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

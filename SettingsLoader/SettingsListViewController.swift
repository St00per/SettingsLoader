//
//  SettingsListViewController.swift
//  SettingsLoader
//
//  Created by Kirill Shteffen on 21/11/2018.
//  Copyright © 2018 Kirill Shteffen. All rights reserved.
//

import UIKit
import Firebase

class SettingsListViewController: UIViewController {
    
    var settingsList: [SettingsObject] = []
    
    @IBOutlet weak var settingsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillSettingsList()
    }
    
    func fillSettingsList() {
        
        let url = Bundle.main.url(forResource: "preset", withExtension: "json")!
        do {
            let jsonData = try? Data(contentsOf: url)
            guard let localData = jsonData else {
                return
            }
            let settingsObject = try? JSONDecoder().decode(SettingsObject.self, from: localData)
            
            guard let createdObject = settingsObject else {
                return
            }
            settingsList.append(createdObject)
        }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let settingsObject = settingsList[indexPath.row]
        performSegue(withIdentifier: "Show Detail", sender: nil)
    }
}

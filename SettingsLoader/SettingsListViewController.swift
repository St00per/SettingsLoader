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
    var docRef: DocumentReference!
    
    enum DataState {
        case local
        case cloud
    }
    var dataState: DataState = .local
    
    @IBOutlet weak var settingsTable: UITableView!
    @IBAction func switchToLocal(_ sender: Any) {
        dataStateChange(dataState: .local)
    }
    @IBAction func switchToCloud(_ sender: Any) {
        dataStateChange(dataState: .cloud)
    }
    
    func dataStateChange(dataState: DataState)  {
        self.dataState = dataState
        fillSettingsList()
        //settingsTable.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        docRef = Firestore.firestore().collection("SettingsList").document("default_gain")
        fillSettingsList()
    }
    
    func fillSettingsList() {
        settingsList = []
        if dataState == .local {
            guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("newPreset.json") else { return }
                //Bundle.main.url(forResource: "preset", withExtension: "json")!
        do {
            let jsonData = try? Data(contentsOf: url)
            guard let localData = jsonData else { return }
            let settingsObject = try? JSONDecoder().decode(SettingsObject.self, from: localData)
            
            guard let createdObject = settingsObject else { return }
            settingsList.append(createdObject)
            self.settingsTable.reloadData()
            }
        }
        if dataState == .cloud {
            docRef.getDocument { (docSnapshot,error) in
                guard let docSnapshot = docSnapshot, docSnapshot.exists else { return }
                let myData = docSnapshot.data()
                var settingsObject = SettingsObject()
                settingsObject.preset_id = myData?["preset_id"] as? String ?? "(none)"
                
                self.settingsList.append(settingsObject)
                self.settingsTable.reloadData()
            }
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
        
        performSegue(withIdentifier: "Show Detail", sender: nil)
    }
}

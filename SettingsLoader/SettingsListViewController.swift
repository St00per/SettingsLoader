//
//  SettingsListViewController.swift
//  SettingsLoader
//
//  Created by Kirill Shteffen on 21/11/2018.
//  Copyright © 2018 Kirill Shteffen. All rights reserved.
//

import UIKit

enum DataSource {
    case local
    case cloud
}

class SettingsListViewController: UIViewController {
    
    let settingsHandler = SettingsHandler()
    var settingsList: [SettingsObject] = []
    var dataSource: DataSource = .local
    
    @IBOutlet weak var settingsTable: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func addNewPreset(_ sender: Any) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let desVC = mainStoryboard.instantiateViewController(withIdentifier: "DetailSettingsViewController") as? DetailSettingsViewController else {
            return
        }
        show(desVC, sender: nil)
    }
    
    //Storage source selection
    @IBAction func switchToLocal(_ sender: Any) {
        dataSourceChange(dataSource: .local)
    }
    @IBAction func switchToCloud(_ sender: Any) {
        dataSourceChange(dataSource: .cloud)
    }
    
    func dataSourceChange(dataSource: DataSource)  {
        self.dataSource = dataSource
        fillSettingsList()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        fillSettingsList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        fillSettingsList()
    }
    
    //Data receiving
    func fillSettingsList() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        settingsList = []
        settingsHandler.downloadData(source: dataSource) { (downloadedData) in
            if self.dataSource == .local {
                for data in downloadedData {
                    let settingsObject = self.receivedLocalObject(data: data as! Data)
                    self.settingsList.append(settingsObject as! SettingsObject)
                }
            }
            if self.dataSource == .cloud {
                for data in downloadedData {
                    let settingsObject = self.receivedCloudObject(data: data as! [String:Any])
                    self.settingsList.append(settingsObject as! SettingsObject)
                }
            }
            
            DispatchQueue.main.async {
                self.settingsTable.reloadData()
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
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
        cell.settingsListController = self
        cell.setLabel(settings: settingsList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let desVC = mainStoryboard.instantiateViewController(withIdentifier: "DetailSettingsViewController") as? DetailSettingsViewController else {
            return
        }
        desVC.selectedSettings = settingsList[indexPath.row]
        show(desVC, sender: nil)
    }
}
extension SettingsListViewController: SettingsHandlerReceiveDelegate {
    
    func receivedLocalObject(data: Data) -> Codable {
        let settingsObject = try? JSONDecoder().decode(SettingsObject.self, from: data)
        return settingsObject
    }
    
    func receivedCloudObject(data: Dictionary<String, Any>) -> Codable {
        var settingsObject = SettingsObject()
        settingsObject.preset_id = data["preset_id"] as? String ?? "(none)"
        settingsObject.preset_name = data["preset_name"] as? String ?? "(none)"
        settingsObject.type = data["type"] as? String ?? "(none)"
        settingsObject.is_enabled = data["preset_id"] as? Bool ?? false
        return settingsObject
    }
}

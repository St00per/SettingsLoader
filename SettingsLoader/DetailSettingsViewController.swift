//
//  DetailSettingsViewController.swift
//  SettingsLoader
//
//  Created by Kirill Shteffen on 22/11/2018.
//  Copyright © 2018 Кирилл Штеффен. All rights reserved.
//

import UIKit

class DetailSettingsViewController: UIViewController {

    
    var selectedSettings: SettingsObject?
    
    @IBOutlet weak var presetIDTextField: UITextField!
    @IBOutlet weak var presetNameTextField: UITextField!
    @IBOutlet weak var presetTypeTextField: UITextField!
    @IBOutlet weak var presetEnableSwitch: UISwitch!
    
    @IBAction func `return`(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setPlaceholders()
    }
    
    //Save changes to local storage
    @IBAction func saveLocalButton(_ sender: Any) {
        
        let settingsObject: SettingsObject = SettingsObject(preset_id: presetIDTextField.text ?? "(none)",
                                                            preset_name: presetNameTextField.text ?? "Unnamed",
                                                            is_enabled: presetEnableSwitch.isOn,
                                                            preset_type: nil,
                                                            type: presetTypeTextField.text ?? "(none)",
                                                            parameters: nil)
        let settingsToSave = dispatchedLocalObject(data: settingsObject)
        SettingsHandler.default.saveData(dataSource: .local,
                                         localData: settingsToSave,
                                         cloudData: nil,
                                         filename: presetNameTextField.text ?? "Unnamed")
        
        self.dismiss(animated: true)
    }
    
    //Save changes to cloud storage
    @IBAction func saveToCloudButton(_ sender: Any) {

        let settingsObject: SettingsObject = SettingsObject(preset_id: presetIDTextField.text ?? "(none)",
                                                            preset_name: presetNameTextField.text ?? "Unnamed",
                                                            is_enabled: presetEnableSwitch.isOn,
                                                            preset_type: nil,
                                                            type: presetTypeTextField.text ?? "(none)",
                                                            parameters: nil)
        let settingsToSave = dispatchedCloudObject(data: settingsObject)
        SettingsHandler.default.saveData(dataSource: .cloud,
                                         localData: nil,
                                         cloudData: settingsToSave,
                                         filename: presetNameTextField.text ?? "Unnamed")
        self.dismiss(animated: true)
    }
    
    func setPlaceholders() {
        presetIDTextField.text = selectedSettings?.preset_id
        presetNameTextField.text = selectedSettings?.preset_name
        presetTypeTextField.text = selectedSettings?.type
        presetEnableSwitch.isOn = selectedSettings?.is_enabled ?? false
    }
}
extension DetailSettingsViewController: SettingsHandlerDispatchDelegate {
    
    func dispatchedLocalObject<T>(data: T) -> Data where T : Decodable, T : Encodable {
        guard let jsonData = try? JSONEncoder().encode(data) else { return Data()}
        return jsonData
    }
    
    func dispatchedCloudObject<T>(data: T) -> Dictionary<String, Any> where T : Decodable, T : Encodable {
        guard let dataToSave = data.dictionary else { return ["":0] }
        return dataToSave
    }
}

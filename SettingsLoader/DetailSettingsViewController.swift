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
    
    let settingsHandler = SettingsHandler()
    @IBOutlet weak var presetIDTextField: UITextField!
    @IBOutlet weak var presetNameTextField: UITextField!
    @IBOutlet weak var presetTypeTextField: UITextField!
    @IBOutlet weak var presetEnableSwitch: UISwitch!
    
    @IBAction func `return`(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setPlaceholders()
    }
    
    //Save changes to local storage
    @IBAction func saveLocalButton(_ sender: Any) {
        
        let settingsToSave: SettingsObject = SettingsObject(preset_id: presetIDTextField.text ?? "(none)", preset_name: presetNameTextField.text ?? "Unnamed", is_enabled: presetEnableSwitch.isOn, preset_type: nil, type: presetTypeTextField.text ?? "(none)", parameters: nil)
        settingsHandler.saveToLocalStorage(settingsObject: settingsToSave)
        
        self.dismiss(animated: true)
    }
    
    //Save changes to cloud storage
    @IBAction func saveToCloudButton(_ sender: Any) {

        let settingsToSave: SettingsObject = SettingsObject(preset_id: presetIDTextField.text ?? "(none)", preset_name: presetNameTextField.text ?? "Unnamed", is_enabled: presetEnableSwitch.isOn, preset_type: nil, type: presetTypeTextField.text ?? "(none)", parameters: nil)
        
        settingsHandler.saveToCloudStore(settingsObject: settingsToSave)
        self.dismiss(animated: true)
    }
    
    func setPlaceholders() {
        presetIDTextField.text = selectedSettings?.preset_id
        presetNameTextField.text = selectedSettings?.preset_name
        presetTypeTextField.text = selectedSettings?.type
        presetEnableSwitch.isOn = selectedSettings?.is_enabled ?? false
    }
}

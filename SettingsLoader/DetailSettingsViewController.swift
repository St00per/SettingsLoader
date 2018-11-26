//
//  DetailSettingsViewController.swift
//  SettingsLoader
//
//  Created by Kirill Shteffen on 22/11/2018.
//  Copyright © 2018 Кирилл Штеффен. All rights reserved.
//

import UIKit
import Firebase

class DetailSettingsViewController: UIViewController {

    
    var docRef: DocumentReference!
    var selectedSettings: SettingsObject?
    
    @IBOutlet weak var presetIDTextField: UITextField!
    @IBOutlet weak var presetNameTextField: UITextField!
    @IBOutlet weak var presetTypeTextField: UITextField!
    @IBOutlet weak var presetEnableSwitch: UISwitch!
    
    @IBAction func `return`(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        docRef = Firestore.firestore().collection("SettingsList").document("default_gain")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setPlaceholders()
    }
    
    @IBAction func saveLocalButton(_ sender: Any) {
        
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try? jsonEncoder.encode(SettingsObject(preset_id: presetIDTextField.text, preset_name: presetNameTextField.text, is_enabled: presetEnableSwitch.isOn, preset_type: nil, type: presetTypeTextField.text, parameters: nil))
            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("newPreset.json")
            guard let writeUrl = url else { return }
            try! jsonData?.write(to: writeUrl)
        }
        self.dismiss(animated: true)
    }
    
    @IBAction func saveToCloudButton(_ sender: Any) {
        guard let editedText = presetIDTextField.text, !editedText.isEmpty else {
            return
        }
        let dataToSave: [String: Any] = ["preset_id": editedText]
        docRef.setData(dataToSave) { (error) in
            if let error = error {
                print ("ERROR: \(error.localizedDescription)")
            } else{
                print ("Data succefully saved")
            }
        }
        self.dismiss(animated: true)
    }
    
    func setPlaceholders() {
        presetIDTextField.placeholder = selectedSettings?.preset_id
        presetNameTextField.placeholder = selectedSettings?.preset_name
        presetTypeTextField.placeholder = selectedSettings?.type
    }
}

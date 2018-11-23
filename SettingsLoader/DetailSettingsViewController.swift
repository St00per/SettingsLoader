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
    
    @IBOutlet weak var settingEditTextField: UITextField!
    @IBAction func saveButton(_ sender: Any) {
        guard let editedText = settingEditTextField.text, !editedText.isEmpty else {
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        docRef = Firestore.firestore().collection("SettingsList").document("default_gain")
    }
}

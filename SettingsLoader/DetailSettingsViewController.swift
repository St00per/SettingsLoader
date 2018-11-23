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
    
    @IBOutlet weak var presetIDTextField: UITextField!
    
    @IBAction func saveLocalButton(_ sender: Any) {
        
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try? jsonEncoder.encode(SettingsObject(preset_id: "TESTIN", preset_name: nil, is_enabled: nil, preset_type: "BANG", type: nil, parameters: nil))
            //let fileManager = FileManager.default
            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("newPreset.json")
            //let jsonUrl = url?.appendingPathComponent("newPreset.json")
            print(url)
            guard let writeUrl = url else { return }
            try! jsonData?.write(to: writeUrl)
//            guard let dataToPrint = jsonData else { return }
//            let jsonString = String(data: dataToPrint, encoding: .utf8)
//            print("JSON String : " + jsonString!)
        }
        //performSegue(withIdentifier: "BackToList", sender: nil)
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
        performSegue(withIdentifier: "BackToList", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        docRef = Firestore.firestore().collection("SettingsList").document("default_gain")
    }
}

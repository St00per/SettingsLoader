//
//  SettingsHandler.swift
//  SettingsLoader
//
//  Created by Kirill Shteffen on 27/11/2018.
//  Copyright © 2018 Кирилл Штеффен. All rights reserved.
//

import Foundation
import Firebase

class SettingsHandler {
    
    var docRef: DocumentReference!
    
    func saveToLocalStorage(settingsObject: SettingsObject) {
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try! jsonEncoder.encode(settingsObject)
            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("\((settingsObject.preset_name ?? "Unnamed")).json")
            guard let writeUrl = url else { return }
            try? jsonData.write(to: writeUrl)
        }
    }
    
    func saveToCloudStore(settingsObject: SettingsObject) {
        docRef = Firestore.firestore().collection("SettingsList").document("default_gain")
        let dataToSave: [String: Any] = ["preset_id": settingsObject.preset_id ?? "(none)",
                                         "preset_name": settingsObject.preset_name ?? "Unnamed",
                                         "is_enabled": String(settingsObject.is_enabled ?? false),
                                         "type": settingsObject.type ?? "(none)"]
        docRef.setData(dataToSave) { (error) in
            if let error = error {
                print ("ERROR: \(error.localizedDescription)")
            } else{
                print ("Data succefully saved")
            }
        }
    }
}

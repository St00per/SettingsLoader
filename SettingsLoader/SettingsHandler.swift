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
    
    var collectionRef: CollectionReference!
    var docRef: DocumentReference!
    
    func downloadData(source: DataSource, onCompletion: @escaping ([SettingsObject])->Void) {
        var settingsList = [SettingsObject]()
        if source == .local {
            
            let fileManager = FileManager.default
            let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            guard let fileURLs = try? fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil) else { return onCompletion([SettingsObject]())}
            for url in fileURLs {
                guard let jsonData = try? Data(contentsOf: url) else { continue }
                let settingsObject = try? JSONDecoder().decode(SettingsObject.self, from: jsonData)
                let createdObject = settingsObject
                settingsList.append(createdObject ?? SettingsObject())
            }
            return onCompletion(settingsList)
        }
        
        if source == .cloud {
            collectionRef = Firestore.firestore().collection("SettingsList")
            collectionRef.getDocuments { (docsSnapshot, error) in
                guard let docsSnapshot = docsSnapshot?.documents, docsSnapshot.count != 0 else { return }
                var settingsObject = SettingsObject()
                for doc in docsSnapshot {
                let myData = doc.data()
                    settingsObject.preset_id = myData["preset_id"] as? String ?? "(none)"
                    settingsObject.preset_name = myData["preset_name"] as? String ?? "(none)"
                    settingsObject.type = myData["type"] as? String ?? "(none)"
                    settingsObject.is_enabled = myData["preset_id"] as? Bool ?? false
                    settingsList.append(settingsObject)
                }
                return onCompletion(settingsList)
            }
        }
    }
    
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
        docRef = Firestore.firestore().collection("SettingsList").document(settingsObject.preset_name ?? "Unnamed")
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
    
    func deleteLocalPreset(named: String, dataSource: DataSource) {
        
        if dataSource == .local {
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("\(named).json") else { return }
        try? FileManager.default.removeItem(at: url)
        }
        
        if dataSource == .cloud {
            docRef = Firestore.firestore().collection("SettingsList").document(named)
            docRef.delete()
            }
        }
    }

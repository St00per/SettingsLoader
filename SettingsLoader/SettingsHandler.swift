//
//  SettingsHandler.swift
//  SettingsLoader
//
//  Created by Kirill Shteffen on 27/11/2018.
//  Copyright © 2018 Кирилл Штеффен. All rights reserved.
//

import Foundation
import Firebase

protocol SettingsHandlerDelegate {
    func receivedLocalObject(data: Data) -> Codable
    func receivedCloudObject(data: Dictionary<String, Any>) -> Codable
    func dispatchedLocalObject<T : Codable>(data: T) -> Data
    func dispatchedCloudObject<T : Codable>(data: T) -> Dictionary<String, Any>
}

class SettingsHandler: SettingsHandlerDelegate {
    
    var collectionRef: CollectionReference!
    var docRef: DocumentReference!
    
    
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
    
    func dispatchedLocalObject<T : Codable>(data: T) -> Data {
        guard let jsonData = try? JSONEncoder().encode(data) else { return Data()}
        return jsonData
    }
    
    func dispatchedCloudObject<T : Codable>(data: T) -> Dictionary<String, Any> {
        
        guard let dataToSave = data.dictionary else { return ["":0] }
        return dataToSave
    }
    
    func downloadData(source: DataSource, onCompletion: @escaping ([SettingsObject])->Void) {
        var settingsList = [SettingsObject]()
        if source == .local {
            
            let fileManager = FileManager.default
            let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            guard let fileURLs = try? fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil) else { return onCompletion([SettingsObject]())}
            for url in fileURLs {
                guard let jsonData = try? Data(contentsOf: url) else { continue }
                let settingsObject = receivedLocalObject(data: jsonData)
                guard let createdObject = settingsObject as? SettingsObject else { continue }
                settingsList.append(createdObject)
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
                settingsObject = self.receivedCloudObject(data: myData) as? SettingsObject ?? SettingsObject()
                settingsList.append(settingsObject)
                }
                return onCompletion(settingsList)
            }
        }
    }
    
    func saveToLocalStorage(settingsObject: SettingsObject) {
        do {
            let jsonData = dispatchedLocalObject(data: settingsObject)
            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("\((settingsObject.preset_name ?? "Unnamed")).json")
            guard let writeUrl = url else { return }
            try? jsonData.write(to: writeUrl)
        }
    }
    
    func saveToCloudStore(settingsObject: SettingsObject) {
        docRef = Firestore.firestore().collection("SettingsList").document(settingsObject.preset_name ?? "Unnamed")
        let dataToSave: [String: Any] = dispatchedCloudObject(data: settingsObject)
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

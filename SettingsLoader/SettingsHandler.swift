//
//  SettingsHandler.swift
//  SettingsLoader
//
//  Created by Kirill Shteffen on 27/11/2018.
//  Copyright © 2018 Кирилл Штеффен. All rights reserved.
//

import Foundation
import Firebase

protocol SettingsHandlerReceiveDelegate {
    func receivedLocalObject(data: Data) -> Codable
    func receivedCloudObject(data: Dictionary<String, Any>) -> Codable
}

protocol SettingsHandlerDispatchDelegate {
    func dispatchedLocalObject<T : Codable>(data: T) -> Data
    func dispatchedCloudObject<T : Codable>(data: T) -> Dictionary<String, Any>
}

class SettingsHandler {
    
    var collectionRef: CollectionReference!
    var docRef: DocumentReference!
  
    
    func downloadData(source: DataSource, onCompletion: @escaping ([Any])->Void) {
        var dataList = [Data]()
        if source == .local {
            
            let fileManager = FileManager.default
            let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            guard let fileURLs = try? fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil) else { return onCompletion([Data]())}
            for url in fileURLs {
                guard let jsonData = try? Data(contentsOf: url) else { continue }
                dataList.append(jsonData)
            }
            return onCompletion(dataList)
        }
        
        if source == .cloud {
            var dictionaryList = [[String: Any]]()
            collectionRef = Firestore.firestore().collection("SettingsList")
            collectionRef.getDocuments { (docsSnapshot, error) in
                guard let docsSnapshot = docsSnapshot?.documents, docsSnapshot.count != 0 else { return }
                for doc in docsSnapshot {
                let myData = doc.data()
                dictionaryList.append(myData)
                }
                return onCompletion(dictionaryList)
            }
        }
    }
    
    func saveToLocalStorage(data: Data, filename: String) {
        do {
            let jsonData = data
            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("\(filename).json")
            guard let writeUrl = url else { return }
            try? jsonData.write(to: writeUrl)
        }
    }
    
    func saveToCloudStore(data: [String: Any], filename: String) {
        docRef = Firestore.firestore().collection("SettingsList").document(filename)
        docRef.setData(data) { (error) in
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

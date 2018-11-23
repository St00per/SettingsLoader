//
//  SettingsObject.swift
//  SettingsLoader
//
//  Created by Kirill Shteffen on 21/11/2018.
//  Copyright © 2018 Kirill Shteffen. All rights reserved.
//

import Foundation

struct SettingsPresets: Codable {
    let preset: SettingsObject
}

struct SettingsObject: Codable {
    
    let preset_id: String
    let preset_name: String
    let is_enabled: Bool
    let preset_type: String
    let type: String
    let parameters: Parameters
    
}

struct Parameters: Codable {
    let gain: Int
    let phase: Int
    let pad: Int
    let notch1: Int
    let notch2: Int
}

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
    
    var preset_id: String?
    let preset_name: String?
    let is_enabled: Bool?
    let preset_type: String?
    let type: String?
    let parameters: Parameters?
    
    init(preset_id: String? = nil, preset_name: String? = nil, is_enabled: Bool? = nil, preset_type: String? = nil, type: String? = nil, parameters: Parameters? = nil
         ) {
        self.preset_id = preset_id
        self.preset_name = preset_name
        self.is_enabled = is_enabled
        self.preset_type = preset_type
        self.type = type
        self.parameters = parameters
    }
    
}

struct Parameters: Codable {
    let gain: Int
    let phase: Int
    let pad: Int
    let notch1: Int
    let notch2: Int
}

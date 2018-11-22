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
    
}

//
//  SettingsObject.swift
//  SettingsLoader
//
//  Created by Kirill Shteffen on 21/11/2018.
//  Copyright © 2018 Kirill Shteffen. All rights reserved.
//

import Foundation

class SettingsObject {
    
    var settingsTitle = ""
    
    var firstParameter = ""
    var secondParameter = ""
    
    init(withParameters title: String, firstInputParameter: String, secondInputParameter: String) {
        settingsTitle = title
        firstParameter = firstInputParameter
        secondParameter = secondInputParameter
    }
    
}

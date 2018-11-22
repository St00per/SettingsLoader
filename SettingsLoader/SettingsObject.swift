//
//  SettingsObject.swift
//  SettingsLoader
//
//  Created by Кирилл Штеффен on 21/11/2018.
//  Copyright © 2018 Кирилл Штеффен. All rights reserved.
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

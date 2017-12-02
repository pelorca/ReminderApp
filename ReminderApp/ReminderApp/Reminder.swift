//
//  Reminder.swift
//  ReminderApp
//
//  Created by Aloc SP08161 on 01/12/2017.
//  Copyright © 2017 Aloc SP08161. All rights reserved.
//

import Foundation


class Reminder {
    
    var texto: String
    var date: Date?
    var isNotification: Bool
    
    
    init (_ texto: String, _ date: Date?, _ isNotification: Bool) {
        self.texto = texto
        self.date = date
        self.isNotification = isNotification
    }
    
    convenience init() {
        self.init("", nil, false)
        
    }
    
}

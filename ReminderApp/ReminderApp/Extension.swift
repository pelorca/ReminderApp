//
//  Extension.swift
//  ReminderApp
//
//  Created by Eduardo Pelorca on 01/12/2017.
//  Copyright © 2017 Eduardo Pelorca. All rights reserved.
//

import Foundation
import UserNotifications



extension Date {
    func convertToString() -> String {
        let formatter = DateFormatter()
       formatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        
        if self != nil {
             return formatter.string(from: self)
        } else  {
            return ""
        }
       
    }
    
}


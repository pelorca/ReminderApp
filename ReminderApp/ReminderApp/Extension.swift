//
//  Extension.swift
//  ReminderApp
//
//  Created by Aloc SP08161 on 01/12/2017.
//  Copyright © 2017 Aloc SP08161. All rights reserved.
//

import Foundation


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


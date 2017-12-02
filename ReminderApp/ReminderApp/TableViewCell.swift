//
//  TableViewCell.swift
//  ReminderApp
//
//  Created by Aloc SP08161 on 01/12/2017.
//  Copyright © 2017 Aloc SP08161. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var btnAdd: UIButton!
    
    @IBOutlet weak var imgNotification: UIImageView!
    
    @IBOutlet weak var txtTexto: UITextField!
   
    @IBOutlet weak var lblDate: UILabel!
    
    @IBAction func btnAdd(_ sender: UIButton) {
        self.txtTexto.isEnabled = true
        self.txtTexto.setNeedsFocusUpdate()
        self.txtTexto.becomeFirstResponder()
    }
    
    @objc func enableText() {
        self.txtTexto.isEnabled = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        self.txtTexto.isEnabled = true
    }
    
    

}

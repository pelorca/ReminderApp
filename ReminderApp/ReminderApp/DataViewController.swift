//
//  ViewController.swift
//  ReminderApp
//
//  Created by Aloc SP08161 on 01/12/2017.
//  Copyright © 2017 Aloc SP08161. All rights reserved.
//

import UIKit



class DataViewController: UIViewController {
    
    public var reminder: Reminder?
    
    
    @IBOutlet weak var txtEvent: UITextField!
    
    @IBOutlet weak var dateEvent: UIDatePicker!
    
    @IBOutlet weak var isNotification: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.txtEvent.text = self.reminder?.texto
        self.dateEvent.date =  self.reminder?.date ?? Date()
        self.navigationItem.hidesBackButton = true
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.editButtonPressed))
    }
    
    
    @objc func editButtonPressed(){
        self.reminder?.date = self.dateEvent.date
        self.reminder?.texto = self.txtEvent.text!
        self.reminder?.isNotification =  self.isNotification.isOn
        let controller =  (self.navigationController?.viewControllers[0] as! TableViewController)
        controller.selectedItem = self.reminder
        
        if self.reminder?.texto == ""{
            let alert = UIAlertController(title: "Alerta", message: "Campo Evento Obrigatório", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            if (self.reminder?.isNotification)! {
                controller.Notification((self.reminder?.texto)!, self.reminder?.date)
            }
            self.navigationController?.popViewController(animated: true)
        }
        
        
    }
}
   
    
    // MARK: - Private Methods
    
    




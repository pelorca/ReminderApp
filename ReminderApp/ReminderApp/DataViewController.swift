//
//  ViewController.swift
//  ReminderApp
//
//  Created by Aloc SP08161 on 01/12/2017.
//  Copyright © 2017 Aloc SP08161. All rights reserved.
//

import UIKit

class DataViewController: UIViewController {
    
    public var remimder: Reminder?
    
    
    @IBOutlet weak var txtEvent: UITextField!
    
    @IBOutlet weak var dateEvent: UIDatePicker!
    
    @IBOutlet weak var isNotification: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtEvent.text = self.remimder?.texto
        self.dateEvent.date =  self.remimder?.date ?? Date()
        self.navigationItem.hidesBackButton = true
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.editButtonPressed))
        
        
        // Do any additional setup after loading the view.
    }
    
    
    @objc func editButtonPressed(){
        self.remimder?.date = self.dateEvent.date
        self.remimder?.texto = self.txtEvent.text!
        self.remimder?.isNotification =  self.isNotification.isOn
        let controller =  (self.navigationController?.viewControllers[0] as! TableViewController)
        controller.selectedItem = self.remimder
        
        if self.remimder?.texto == ""{
            let alert = UIAlertController(title: "Alerta", message: "Campo Evento Obrigatório", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
             self.navigationController?.popViewController(animated: true)
        }
        
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    
    
}

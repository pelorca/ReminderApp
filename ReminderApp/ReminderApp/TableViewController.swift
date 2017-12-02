//
//  TableViewController.swift
//  ReminderApp
//
//  Created by Aloc SP08161 on 01/12/2017.
//  Copyright © 2017 Aloc SP08161. All rights reserved.
//

import UIKit
import UserNotifications

class TableViewController: UITableViewController, UITextFieldDelegate, UISearchBarDelegate {
    
    var selectedItem: Reminder?
    
    public var row: Int = 0
    var txtTexto: UITextField?
    var editingField: Bool = false
    public var listReminder = [Reminder]()
    var searchBar: Bool = false
    public var listReminderOriginal = [Reminder]()
    var indexPath: IndexPath?
    var tapGesture: Any?
    override func viewDidLoad() {
        super.viewDidLoad()
        listReminder.append(Reminder())
        listReminderOriginal = listReminder
        self.tableView.keyboardDismissMode = .interactive
        self.clearsSelectionOnViewWillAppear = false
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.editButtonPressed))
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        UNUserNotificationCenter.current().delegate = self
    }
    
    
    
    @objc func editButtonPressed(){
        self.tableView.setEditing(!tableView.isEditing, animated: true)
        if tableView.isEditing == true{
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action:  #selector(self.editButtonPressed))
        }else{
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.editButtonPressed))
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewDetails"{
            let page: DataViewController = segue.destination as! DataViewController
            page.reminder = (sender as! Reminder)
            
        }
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    @objc func hideKeyboard() {
        tableView.endEditing(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listReminder.count
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let text = listReminder[indexPath.row].texto
            if searchBar {
                listReminderOriginal = listReminderOriginal.filter{ $0.texto != text}
            }
            if listReminderOriginal.count == 1 {
                self.listReminder.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                self.listReminder.append(Reminder())
                tableView.reloadData()
                listReminderOriginal = listReminder
            } else {
                self.listReminder.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                if !searchBar {
                    listReminderOriginal = listReminder
                }
            }
            
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            listReminder = listReminderOriginal
            self.searchBar = false
            self.tableView.reloadData()
        } else {
            self.searchBar = true
            let filtered = listReminderOriginal.filter{
                let textToSearch = "\($0.texto)"
                return textToSearch.range(of: searchText) != nil
            }
            listReminder = filtered
        }
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        cell.txtTexto?.delegate = self
        cell.txtTexto?.text = listReminder[indexPath.row].texto
        
        if (listReminder[indexPath.row].texto != "") {
            cell.btnAdd.isHidden = true
        } else {
            cell.btnAdd.isHidden = false
        }
        cell.txtTexto?.autocorrectionType = UITextAutocorrectionType.no
        cell.txtTexto?.autocapitalizationType = UITextAutocapitalizationType.none
        cell.txtTexto?.adjustsFontSizeToFitWidth = true;
        
        cell.lblDate.text = listReminder[indexPath.row].date?.convertToString()
        
        if cell.lblDate.text != nil && cell.lblDate.text != "" {
            cell.txtTexto.frame.origin.x = 40
            cell.txtTexto.frame.origin.y = 0
        }
        cell.imgNotification.isHidden  = !listReminder[indexPath.row].isNotification
        cell.backgroundColor = #colorLiteral(red: 1, green: 0.988355577, blue: 0.5284820596, alpha: 0.13)
        
        
        return cell
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let cell = textField.superview?.superview as! TableViewCell
        cell.isEditing = true
        editingField = true
        self.txtTexto = textField
        self.tableView.addGestureRecognizer(tapGesture as! UIGestureRecognizer)
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.tableView.addGestureRecognizer(tapGesture as! UIGestureRecognizer)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.tableView.removeGestureRecognizer(tapGesture as! UIGestureRecognizer)
    }
    
    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if editingField {
            let cell = textField.superview?.superview as! TableViewCell
            cell.txtTexto.text = textField.text
            if !cell.btnAdd.isHidden && textField.text != "" {
                if selectedItem != nil {
                    selectedItem?.texto = textField.text!
                }
                listReminder.append(Reminder(textField.text!,nil, false))
                listReminderOriginal = listReminder
            }
            self.tableView.keyboardDismissMode = .none
            self.tableView.removeGestureRecognizer(tapGesture as! UIGestureRecognizer)
            self.tableView.reloadData()
        }
    }
    
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        if cell.txtTexto.text == "" {
            editingField = false
            listReminder.append(Reminder())
            self.selectedItem = listReminder[listReminder.count - 1]
            self.selectedItem?.texto = (self.txtTexto?.text)!
            
        } else {
            editingField = true
            self.selectedItem = listReminder[indexPath.row]
        }
        self.performSegue(withIdentifier: "viewDetails",  sender: selectedItem)
    }
    
    
    
    
    public func Notification(_ text: String, _ date: Date?) {
        
        UNUserNotificationCenter.current().getNotificationSettings { (notificationSettings) in
            switch notificationSettings.authorizationStatus {
            case .notDetermined:
                self.requestAuthorization(completionHandler: { (success) in
                    guard success else { return }
                    self.scheduleLocalNotification(text, date!)
                })
            case .authorized:
                self.scheduleLocalNotification(text, date!)
            case .denied:
                print("Application Not Allowed to Display Notifications")
            }
        }
        
    }
    
    private func requestAuthorization(completionHandler: @escaping (_ success: Bool) -> ()) {
        // Request Authorization
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
            if let error = error {
                print("Request Authorization Failed (\(error), \(error.localizedDescription))")
            }
            
            completionHandler(success)
        }
    }
    
    private func scheduleLocalNotification(_ text: String, _ date: Date) {
        // Create Notification Content
        let notificationContent = UNMutableNotificationContent()
        
        // Configure Notification Content
        notificationContent.title = "REMINDER APP"
        notificationContent.subtitle = ""
        notificationContent.body = text
        notificationContent.sound = UNNotificationSound.default()
        
        // Add Trigger
        
        let val = date.timeIntervalSinceNow - Date().timeIntervalSinceNow
        if val > 0 {
            let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: date.timeIntervalSinceNow, repeats: false)
            
            // Create Notification Request
            let notificationRequest = UNNotificationRequest(identifier: "reminder_app_pelorca", content: notificationContent, trigger: notificationTrigger)
            
            // Add Request to User Notification Center
            UNUserNotificationCenter.current().add(notificationRequest) { (error) in
                if let error = error {
                    print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
                }
            }
        }
    }
}



extension TableViewController: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert])
    }
    
}

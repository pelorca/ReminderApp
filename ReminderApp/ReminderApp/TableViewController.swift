//
//  TableViewController.swift
//  ReminderApp
//
//  Created by Aloc SP08161 on 01/12/2017.
//  Copyright © 2017 Aloc SP08161. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, UITextFieldDelegate, UISearchBarDelegate {
    
    var selectedItem: Reminder?
    
    public var row: Int = 0
    public var listReminder = [Reminder]()
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
            page.remimder = (sender as! Reminder)
            
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
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listReminder.count
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            if listReminder.count == 1 {
                self.listReminder.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                self.listReminder.append(Reminder())
                listReminderOriginal = listReminder
                tableView.reloadData()
            } else {
                self.listReminder.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                listReminderOriginal = listReminder
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            listReminder = listReminderOriginal
            self.tableView.reloadData()
        } else {
            
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
        self.tableView.addGestureRecognizer(tapGesture as! UIGestureRecognizer)
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.tableView.addGestureRecognizer(tapGesture as! UIGestureRecognizer)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.tableView.removeGestureRecognizer(tapGesture as! UIGestureRecognizer)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let cell = textField.superview?.superview as! TableViewCell
        if !cell.btnAdd.isHidden && textField.text != "" {
            listReminder.append(Reminder(textField.text!,nil, false))
            listReminderOriginal = listReminder
        }
        self.tableView.keyboardDismissMode = .none
        self.tableView.removeGestureRecognizer(tapGesture as! UIGestureRecognizer)
        self.tableView.reloadData()
    }
    //delegate method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {           textField.resignFirstResponder()
        return true
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let filtered = listReminderOriginal.filter{ $0.date == nil && $0.texto == ""}
        if filtered.count == 1 {
            listReminder.append(Reminder())
            self.selectedItem = listReminder[listReminder.count - 1]
            
        } else {
            self.selectedItem = listReminder[indexPath.row]
        }
        
        self.performSegue(withIdentifier: "viewDetails",  sender: selectedItem)
    }
    
}

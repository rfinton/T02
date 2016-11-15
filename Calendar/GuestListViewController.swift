//
//  CalendarTableViewController.swift
//  Calendar
//
//  Created by TIMMARAJU SAI V on 11/3/16.
//  Copyright © 2016 TIMMARAJU SAI V. All rights reserved.
//

import UIKit
import EVContactsPicker
import Contacts
import ContactsUI
class GuestListViewController: UITableViewController, EVContactsPickerDelegate {
    var store : CNContactStore? = nil
    var tableViewData:NSMutableArray? = []
    var dbString = ""
    @IBAction func AddGuests(_ sender: UIBarButtonItem) {
        showPicker()
    }
    func showPicker() {
        let contactPicker = EVContactsPickerViewController()
        contactPicker.delegate = self
        self.navigationController?.pushViewController(contactPicker, animated: true)
     
    }
    
    
    func didChooseContacts(_ contacts: [EVContactProtocol]?) {
        dbString = ""
        if let cons = contacts {
            for con in cons {
                let dict:AnyObject = ["identifier":con.identifier,"invited":"0"] as AnyObject
                if !(tableViewData?.contains(dict))! {
                    dbString.append("/\(con.identifier)")
                    tableViewData?.add(dict)
                }
            }
        }
        self.navigationController?.popViewController(animated: true)
        
    }
    func fetchDetails(id:String)
    {
        do {
            let appconact = try self.store?.unifiedContact(withIdentifier: (id), keysToFetch: [CNContactViewController.descriptorForRequiredKeys()] )
            print(appconact?.givenName)
            let vc = CNContactViewController(for: appconact!)
            CNContactViewController.descriptorForRequiredKeys()
            self.navigationController?.pushViewController(vc, animated: true)
        } catch {
            print("error")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
         self.store = CNContactStore()
        tableViewData = LoginViewController.dbOjbect.triggerDatabase(method: "retriveContacts/\(SprialViewController.eventId!)")
        self.tableView.reloadData()
       // showPicker()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if dbString.characters.count != 0{
            print(dbString)
             self.tableView.reloadData()
             LoginViewController.dbOjbect.triggerDatabase(method: "insertContacts/\(SprialViewController.eventId!)/\(0)/\(dbString)")
        }
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
        return (tableViewData?.count)!
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GuestListTableCell", for: indexPath)
         do {
            let record = tableViewData?[indexPath.row] as! NSDictionary
            let id = (record["identifier"] as! String)
            let invited = Int(record["invited"] as! String)
        let appContact = try self.store?.unifiedContact(withIdentifier: (id), keysToFetch: [CNContactViewController.descriptorForRequiredKeys()] )
            cell.textLabel?.text =  appContact?.givenName
            if (appContact?.emailAddresses.count)! > 0 {
                print(appContact?.emailAddresses[0])
                cell.detailTextLabel?.text = appContact?.emailAddresses[0].value as! String
            }else {
                cell.detailTextLabel?.text = ""
            }
            if invited! > 0{
                tableView.cellForRow(at: indexPath)?.backgroundColor = UIColor.green
                tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            }
            
         } catch {
            print("error")
        }
        return cell
    }
    
    override func tableView(_: UITableView, accessoryButtonTappedForRowWith: IndexPath) {
        let record = tableViewData?[accessoryButtonTappedForRowWith.row] as! NSDictionary
        let id = (record["identifier"] as! String)
        fetchDetails(id: id)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let record = tableViewData?[indexPath.row] as! NSDictionary
            let id = (record["identifier"] as! String)
            tableViewData?.removeObject(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            LoginViewController.dbOjbect.triggerDatabase(method: "deleteContact/\(SprialViewController.eventId!)/\(id)")
         
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
 /*
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var record = tableViewData?[indexPath.row] as! NSDictionary
        var invited = Int(record["invited"] as! String)
        if invited == 0 {
        record["invited"]  = "1"
        tableView.cellForRow(at: indexPath)?.backgroundColor = UIColor.green
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        else{
            record["invited"] = "0"
            tableView.cellForRow(at: indexPath)?.backgroundColor = UIColor.white
            tableView.cellForRow(at: indexPath)?.accessoryType = .detailButton
        }
    }*/
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

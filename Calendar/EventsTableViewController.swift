//
//  EventsTableViewController.swift
//  Calendar
//
//  Created by TIMMARAJU SAI V on 11/13/16.
//  Copyright © 2016 TIMMARAJU SAI V. All rights reserved.
//

import UIKit

class EventsTableViewController: UITableViewController {
   
  
    var tableViewData:NSMutableArray? = []
    
    func retriveData() {
        tableViewData = LoginViewController.dbOjbect.triggerDatabase(method: "retriveEvents/\(LoginViewController.uname!)")
        
        print(tableViewData)
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        retriveData()
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath)

        let y = tableViewData?[indexPath.row] as! NSDictionary
        let name = (y["name"] as! String)
        let date = y["date"] as! String
        cell.textLabel?.text =  name
        cell.detailTextLabel?.text = date

        return cell
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
            // Delete the row from the data source
            let retrivedRow = tableViewData?[indexPath.row] as! NSDictionary
            let id = (retrivedRow["eventId"] as! String)
            LoginViewController.dbOjbect.triggerDatabase(method: "deleteEvent/\(id)")
            tableViewData?.removeObject(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       
        
    }

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

    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.destination is SprialViewController {
            let retrivedRow  = tableViewData?[(self.tableView.indexPathForSelectedRow!.row)] as! NSDictionary
            let id = (retrivedRow["eventId"] as! String)
            SprialViewController.event = retrivedRow
            SprialViewController.eventId = Int(id)
        }
        
    }
 

}

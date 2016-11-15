//
//  LoginViewController.swift
//  Calendar
//
//  Created by TIMMARAJU SAI V on 11/4/16.
//  Copyright © 2016 TIMMARAJU SAI V. All rights reserved.
//

import UIKit
extension String {
    var stringByRemovingWhitespaces: String {
        return components(separatedBy: .whitespaces).joined(separator: "")
    }
}
class LoginViewController: UIViewController {
    
    static let dbOjbect = DatabaseManagement()
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    static var uname:String?
    @IBAction func logIn(_ sender: UIButton) {
        let un = username?.text?.stringByRemovingWhitespaces
        let pd = password?.text?.stringByRemovingWhitespaces
        
        if un?.characters.count != 0 && pd?.characters.count != 0 {
            let x = LoginViewController.dbOjbect.triggerDatabase(method: "checkCredentials/\(un!)/\(pd!)")
            let y = x[0] as! NSDictionary
            let z = Int(y["count(1)"]! as! String)
            if  z != 0 {
                print("Login Segue")
                performSegue(withIdentifier: "LogInSegue", sender: nil)
            }
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.destination is EventsTableViewController {
            LoginViewController.uname = username?.text?.stringByRemovingWhitespaces
        }
        
    }
 

}

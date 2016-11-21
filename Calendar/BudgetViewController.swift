//
//  ViewController.swift
//  Budget
//
//  Created by Zato on 11/13/16.
//  Copyright © 2016 Yellow Team. All rights reserved.
//

import UIKit

class BudgetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    public static var budget: Budget!
    public static var categories: [Category] = []
    public static var items: [String: [Item]] = [:]
    
    @IBOutlet weak var categoriesTable: UITableView!
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var spentLabel: UILabel!
    @IBOutlet weak var remainingLabel: UILabel!
    
    @IBAction func addCategory(_ sender: UIButton) {
        setCategory()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Line 29 - EventKeys: \(SprialViewController.event?.allKeys)")
        
        let _amount = Float(SprialViewController.event?["budget"]! as! String)!
        BudgetViewController.budget = Budget(_amount)
        
        //navigationItem.rightBarButtonItem = editButtonItem
        //navigationItem.rightBarButtonItem?.action = #selector(editCategoryTable)
        
        self.budgetLabel.text = "$" + String(format: "%.2f", BudgetViewController.budget.amount)
        self.spentLabel.text = "$" + String(format: "%.2f", BudgetViewController.budget.spent)
        self.remainingLabel.text = "$" + String(format: "%.2f", BudgetViewController.budget.remaining)        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        fetchCategories(SprialViewController.eventId!)
        fetchItems(id: SprialViewController.eventId!)
        
        print("Line 46 - EventID: \(SprialViewController.eventId!)")
        
        self.budgetLabel.text = "$" + String(format: "%.2f", BudgetViewController.budget.amount)
        self.spentLabel.text = "$" + String(format: "%.2f", BudgetViewController.budget.spent)
        self.remainingLabel.text = "$" + String(format: "%.2f", BudgetViewController.budget.remaining)
        
        if BudgetViewController.budget.spent > BudgetViewController.budget.amount {
            self.remainingLabel.textColor = UIColor.red
        }
    }
    
    
    
    func setCategory() {
        let alertController = UIAlertController(title: "Create category", message: "", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
            
            let whitespaces = NSCharacterSet.whitespaces
            
            // Grab form values
            let name: String = (alertController.textFields?[0].text)!
            //let budget: Float = Float((alertController.textFields?[1].text)!)!
            
            // Create temp category variable
            //let category = Category(name, budget)
            //BudgetViewController.categories.append(category)
            //self.categoriesTable.reloadData()
            //self.addCategory(category)
            
            
            // Check if a field is empty
            if alertController.textFields?[0].text?.trimmingCharacters(in: whitespaces) == "" || alertController.textFields?[1].text == "" {
                
                let alert = UIAlertController(title: "Cannot Save", message: "One of the fields were empty", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                
            }
            else {
                
                // Name does not need to be checked
                let name: String = (alertController.textFields?[0].text)!
                
                // Make sure Budget text field is a float.
                if let budget: Float = Float((alertController.textFields?[1].text)!) {
                    let category = Category(name, budget)
                    self.addCategory(category)
                    BudgetViewController.categories.append(category)
                    self.categoriesTable.reloadData()
                }
                else {
                    let alert = UIAlertController(title: "Cannot Save", message: "Budget field not a valid entry", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
        })
        
        
        
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Category name"
        }
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Budget Amount: $0.00"
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    func editCategoryTable() {
        if self.categoriesTable.isEditing == false {
            self.categoriesTable.setEditing(true, animated: true)
            navigationItem.rightBarButtonItem?.title = "Done"
        } else {
            self.categoriesTable.setEditing(false, animated: true)
            navigationItem.rightBarButtonItem?.title = "Edit"
        }
    }
    

    // Mark: TableView Management
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BudgetViewController.categories.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ruid", for: indexPath)
        
        cell.textLabel?.text = BudgetViewController.categories[indexPath.row].name
        cell.detailTextLabel?.text = "detail >"
        
        return cell
    }
    
    
    /*
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            BudgetViewController.categories.remove(at: indexPath.row)
            categoriesTable.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    */
    
    
    // Mark: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! CategoryViewController
        
        let selectedRow = self.categoriesTable.indexPathForSelectedRow
        let category = BudgetViewController.categories[(selectedRow?[1])!]
        print("Line 141 - CATEGORIES: \(category)")
        vc.category = category
        
        if BudgetViewController.items[category.name]?.isEmpty == false {
            print("Line 145 - Category Name: \(BudgetViewController.items[category.name])")
            vc.items = BudgetViewController.items[category.name]!
        }
    }
    
    
    
    
    
    func fetchItems(id: Int) {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let baseURL = "https://cs.okstate.edu/~raymocf/fetchItems.php/raymocf/shelty5clatch3pinion/"
        let url = URL(string: "\(baseURL)\(id)/")
        
        let task = session.dataTask(with: url!) { (data, response, error) -> Void in
            if error != nil {
                print("Error fetching json")
            }
            else {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [[String: Any]] {
                        
                        if json.isEmpty {
                            return
                        }
                        
                        BudgetViewController.budget.spent = 0.00
                        
                        for d in json {
                            print("Line 167 - JSON: \(d)")
                            BudgetViewController.items[d["category_name"]! as! String] = []
                        }
                        
                        for i in json {
                            var item = Item(i["item_name"]! as! String)
                            item.id = Int(i["main_id"]! as! String)!
                            item.category_name = i["category_name"]! as! String
                            item.cost = Float(i["cost"]! as! String)!
                            
                            BudgetViewController.budget.spent = BudgetViewController.budget.spent + item.cost
                            
                            item.deposit = Float(i["deposit"]! as! String)!
                            item.balance_due_date = i["balance_due_date"]! as! String
                            item.paid_by = i["paid_by"]! as! String
                            BudgetViewController.items[i["category_name"]! as! String]!.append(item)
                        }
                        
                        print("Line 180 - items: \(BudgetViewController.items)")
                        DispatchQueue.main.async {
                            self.categoriesTable.reloadData()
                            self.spentLabel.text = "$" + String(format: "%.2f", BudgetViewController.budget.spent)
                            self.remainingLabel.text = "$" + String(format: "%.2f", BudgetViewController.budget.amount - BudgetViewController.budget.spent)
                        }
                        
                    }
                } catch {
                    print("Error parsing json")
                }
                
            }
        }
        
        task.resume()
    }
    
    
    
    
    
    func addCategory(_ category: Category) {
        let base = "https://cs.okstate.edu/~raymocf/addCategory.php/raymocf/shelty5clatch3pinion/"
        let rest = "\(base)\(category.id)/\(category.name)/\(category.budget)/"
        let encodedUrl = rest.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let url = URL(string: encodedUrl!)
        
        let task = session.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
        }
        
        task.resume()
    }
    
    
    
    func fetchCategories(_ id: Int) {
        BudgetViewController.categories = []
        let base = "https://cs.okstate.edu/~raymocf/fetchCategories.php/raymocf/shelty5clatch3pinion/"
        let rest = "\(base)\(id)/"
        let encodedUrl = rest.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let url = URL(string: encodedUrl!)
        
        let task = session.dataTask(with: url!) { (data, response, error) -> Void in
            if error != nil {
                print("Error fetching json")
            }
            else {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [[String: Any]] {
                        
                        if json.isEmpty == true {
                            return
                        }
                        
                        for d in json {
                            let temp = Category(d["name"]! as! String, Float(d["budget"]! as! String)!)
                            BudgetViewController.categories.append(temp)
                        }
                        
                        DispatchQueue.main.async {
                            self.categoriesTable.reloadData()
                            print("Line 299 - MainID: \(BudgetViewController.categories[0].id)")
                        }
                    }
                } catch {
                    print("Error parsing json")
                }
            }
        }
        
        task.resume()
    }
    

}


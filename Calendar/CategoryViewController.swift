//
//  CategoryViewController.swift
//  Budget
//
//  Created by Zato on 11/13/16.
//  Copyright © 2016 Yellow Team. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var items: [Item] = []      // items for this category
    var budget: Float!          // budget amount for this category
    var spent: Float!           // amount spent for this category
    var category: Category!     // type of category
    
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var spentLabel: UILabel!
    @IBOutlet weak var remainingLabel: UILabel!
    @IBOutlet weak var itemsTable: UITableView!
    
    @IBAction func addItem(_ sender: UIButton) {
        setItem()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    
    
    
    func updateView() {
        print("Line 36 - Category: \(self.category!)")
        
        let _category = self.category.name
        
        for d in BudgetViewController.categories {
            if d.name == _category {
                budgetLabel.text = "$" + String(format: "%.2f", d.budget)
                self.budget = d.budget
            }
        }
        
        if self.items.isEmpty == false {
            spentLabel.text = setSpent()
            remainingLabel.text = setRemaining()
        }
    }
    
    
    
    
    

    func setSpent() -> String {
        var n: Float = 0.00
        
        print("Line 63 - ITEMS: \(self.items)")
        
        for d in self.items {
            n = n + d.cost
        }
        
        self.spent = n
        
        return "$" + String(format: "%.2f", n)
    }
    
    
    
    
    func setRemaining() -> String {
        if self.spent > self.budget {
            self.remainingLabel.textColor = UIColor.red
        }
        return "$" + String(format: "%.2f", self.budget - self.spent!)
    }
    
    
    
    
    
    
    func setItem() {
        let alertController = UIAlertController(title: "Create Item", message: "", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
            
            // Grab form values
            let name: String = (alertController.textFields?[0].text)!
            let cost: Float = Float(alertController.textFields![1].text!)!
            let deposit: Float = Float(alertController.textFields![2].text!)!
            let balance_due_date = alertController.textFields![3].text!
            let paid_by = alertController.textFields![4].text!
            
            // create temp variable
            var item = Item(name)
            item.category_name = self.category.name
            item.cost = cost
            item.deposit = deposit
            item.balance_due_date = balance_due_date
            item.paid_by = paid_by
            
            self.items.append(item)
            print("Line 105 - ITEMS: \(self.items)")
            self.addItem(item)
            
            self.itemsTable.reloadData()
            self.updateView()
            
            BudgetViewController.budget.spent = BudgetViewController.budget.spent + item.cost
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Item name"
        }
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Amount: $0.00"
        }
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Deposit: $0.00"
        }
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Balance Due Date: yyyy-mm-dd"
        }
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Paid By"
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    // Mark: TableView Management
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ruid", for: indexPath)
        
        cell.textLabel?.text = self.items[indexPath.row].item_name
        cell.detailTextLabel?.text = "$" + String(format: "%.2f", (self.items[indexPath.row].cost))
        
        return cell
    }
    
    
    
    
    func addItem(_ item: Item) {
        let base = "https://cs.okstate.edu/~raymocf/addItem.php/raymocf/shelty5clatch3pinion/"
        let rest = "\(base)\(item.id)/\(item.category_name)/\(item.item_name)/\(item.cost)/\(item.deposit)/\(item.balance_due_date)/\(item.paid_by)"
        print("Line 178 - URL: \(rest)")
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




}

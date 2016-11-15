//
//  ViewController.swift
//  Budget
//
//  Created by Zato on 11/13/16.
//  Copyright © 2016 Yellow Team. All rights reserved.
//

import UIKit
import CoreData

class BudgetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var budget = { () -> Budget in 
        var b = Budget()
        b.categories = [
            BudgetCategory("Food"),
            BudgetCategory("Beverages"),
            BudgetCategory("Venue"),
            BudgetCategory("Stationery"),
            BudgetCategory("Decor")
        ]
        return b
    }()
    
    
    @IBOutlet weak var categoriesTable: UITableView!
    
    @IBAction func addCategory(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
            var category: BudgetCategory?
            category = BudgetCategory(alertController.textFields![0].text!)
            self.budget.categories.append(category!)
            self.categoriesTable.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alertController.addTextField { (textField : UITextField!) -> Void in }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Items", in: managedContext)
        let item = NSManagedObject(entity: entity!, insertInto: managedContext)
        item.setValue("wedding cake", forKey: "name")
        
        do {
            try managedContext.save()
            print("data saved!")
        } catch let error as NSError {
            print("Error saving: \(error.userInfo)")
        }
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Items")
        
        do {
            let people = try managedContext.fetch(fetchRequest)
            print(people[0].value(forKey: "name"))
        } catch let error as NSError {
            print("Error fetching: \(error.userInfo)")
        }
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return budget.categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ruid", for: indexPath)
        cell.textLabel?.text = budget.categories[indexPath[1]].name
        cell.detailTextLabel?.text = "$0.00"
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! CategoryViewController
        let index = categoriesTable.indexPathForSelectedRow
        let data = budget.categories[(index?[1])!]
        vc.segueData = (budget, data)
    }
}


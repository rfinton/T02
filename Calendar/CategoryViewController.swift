//
//  CategoryViewController.swift
//  Budget
//
//  Created by Zato on 11/13/16.
//  Copyright © 2016 Yellow Team. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var segueData: (Budget, BudgetCategory?)!
    var items: [CategoryItem] = [
        CategoryItem("Beer"), CategoryItem("Wine"), CategoryItem("Spirits")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print((segueData.1)!.name)
        print((segueData.0).amount)
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ruid", for: indexPath)
        cell.textLabel?.text = items[indexPath[1]].title
        cell.detailTextLabel?.text = "$0.00"
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  CategoriesViewController.swift
//  BBtrebek
//
//  Created by Dean Silfen on 11/10/16.
//  Copyright © 2016 Dean Silfen. All rights reserved.
//

import UIKit

class CategoriesViewController: UITableViewController {
    
    var categories = [
        Category(title: "Random", id: -1)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "categoryCell")

        self.tableView.backgroundColor = BBColor.white
        // self.clearsSelectionOnViewWillAppear = false
        
        self.makeRefreshControl()
        self.fetchCategories()

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Categories"
    }

    public func makeRefreshControl() -> Void {
        if #available(iOS 10.0, *) {
            let control = UIRefreshControl()
            control.attributedTitle = NSAttributedString(string: "Pull to load Categories")
            refreshControl = control
            refreshControl?.addTarget(self, action: #selector(CategoriesViewController.refreshCategories), for: UIControlEvents.valueChanged)
        } else {
            // Fallback on earlier versions
        }
    }
    
    public func refreshCategories(sender: Any?) -> Void {
        self.fetchCategories(refresh: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        let category = categories[indexPath.row]
        cell.textLabel?.text = category.title.titleize()
        cell.textLabel?.textColor = BBColor.tcGreenyBlueforText
        cell.backgroundColor = BBColor.white
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow //optional, to get from any UIButton for example
        let category = self.categories[(indexPath?.row)!]
        let cardViewController = createCardViewController(category: category)
        self.navigationItem.title = ""
        self.navigationController?.navigationBar.tintColor = BBColor.tcSeafoamBlue
        self.navigationController?.pushViewController(cardViewController, animated: true);
    }
    
    
    private func createCardViewController(category: Category) -> CardViewController {
        let cardViewController = CardViewController(nibName: "CardViewController", bundle: Bundle.main)
        cardViewController.setCategory(category)
        return cardViewController
    }
    
    private func fetchCategories(refresh: Bool = false) -> Void {
        let client = FetchCategoriesService(count: 1000)
        client.fetch(
            success: { (newCategories) in
            self.categories += newCategories
            self.tableView.reloadData()
            if refresh {
                self.refreshControl?.endRefreshing()
            }
        }, failure: { (data, response, error) in
            // handle this condition responsibly
            NSLog("Error Fetching Data!")
            if refresh {
                self.refreshControl?.endRefreshing()
            }
        })
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

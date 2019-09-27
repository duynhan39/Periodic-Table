//
//  MasterViewController.swift
//  Periodic Table
//
//  Created by Nhan Cao on 9/18/19.
//  Copyright © 2019 Nhan Cao. All rights reserved.
//

import UIKit
import Foundation

class MasterViewController: UITableViewController {
    
    private let jsonFileName = "periodicTable"
    private var data = [String: Any]()
    var elements = [[String: Any]]()
    
    var sortKeyIndex = 0
    let sortKeys = ["number", "symbol", "name"]
    
    @IBAction func sortButton(_ sender: Any) {
        sortKeyIndex = (sortKeyIndex + 1) % sortKeys.count
        let key = sortKeys[sortKeyIndex]
        print("\(key) -- \(sortKeyIndex)")
        sortElements(by: key)
        
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navigationBGColor = UIColor.white
        
        self.navigationController!.navigationBar.isOpaque = true
        self.navigationController!.navigationBar.barTintColor = navigationBGColor
        self.navigationController!.navigationBar.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        self.tableView.backgroundColor = navigationBGColor

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        let jsonData = readJson(from: jsonFileName)
        if jsonData != nil {
            data = jsonData!
        } else {
            print("Failed to load json")
        }
        
        if let rawValue = data["elements"] {
            elements = (rawValue as? [[String: Any]]) ?? [[String: Any]]()
        }
        
        sortElements(by: "number")
    }
    
    private func sortElements(by key: String) {
        if elements.first?[key] is Double {
            elements.sort(by: { lhs, rhs in return (lhs[key] as? Double) ?? 0 < (rhs[key] as? Double) ?? 0 })
        } else {
            elements.sort(by: { lhs, rhs in return (lhs[key] as? String) ?? "N/A" < (rhs[key] as? String) ?? "N/A" })
        }
    }

    // MARK: - Table view data source
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 10
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return elements.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomeTableViewCell
        
        let element = elements[indexPath.row]
        let symbol = element["symbol"] as? String
        let name = (element["name"] as? String) ?? String(indexPath.row)
        let number = element["number"] as? Int
        
        cell.previewView.display(symbol: symbol, number: number)
        cell.elementNameLabel.text = name

        return cell
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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let selectedElement = elements[indexPath.row]
                
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.elementInfo = selectedElement
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
 
    
    
}

extension MasterViewController {
    private func readJson(from file: String) -> [String: Any]? {
        do {
            if let file = Bundle.main.url(forResource: file, withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [String: Any] {
                    return object
                    //                } else if let object = json as? [Any] {
                    //                    // json is an array
                    //                    print(object)
                } else {
                    print("JSON is invalid")
                }
            } else {
                print("No file")
            }
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
}


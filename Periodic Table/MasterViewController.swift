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
    private var elements = [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = false
        
        let jsonData = readJson(from: jsonFileName)
        if jsonData != nil {
            data = jsonData!
        } else {
            print("Failed to load json")
        }
        
//        print((data["elements"] as? [Any])!.count )
        
        if let rawValue = data["elements"] {
            elements = (rawValue as? [[String: Any]]) ?? [[String: Any]]()
        }
        
        sortElements(by: "name")
    }
    
    private func sortElements(by key: String) {
        elements.sort(by: { lhs, rhs in return (lhs[key] as? String) ?? "N/A" < (rhs[key] as? String) ?? "N/A" })
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
//        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
//        if cell == nil {
//            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
//            //(style: UITableViewCellStyle.value2, reuseIdentifier: cellIdentifier)
//        }
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        
        let element = elements[indexPath.row]
        let symbol = (element["symbol"] as? String) ?? "N/A"
        let name = (element["name"] as? String) ?? "N/A"
        
        let formattedString = NSMutableAttributedString()
        formattedString
            .bold(symbol)
            .normal(" - ")
            .normal(name)
        
        
        cell.textLabel?.attributedText = formattedString
        
        if let number = element["number"] as? Int {
            cell.detailTextLabel?.text = String(number)
        }
        

        return cell
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
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

extension NSMutableAttributedString {
    @discardableResult func bold(_ text: String) -> NSMutableAttributedString {
        let fontName = "HelveticaNeue-Bold"
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont(name: fontName, size: 17)!]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)
        
        return self
    }
    
    @discardableResult func normal(_ text: String) -> NSMutableAttributedString {
        let normal = NSAttributedString(string: text)
        append(normal)
        
        return self
    }
}


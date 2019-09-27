//
//  DetailViewController.swift
//  Periodic Table
//
//  Created by Nhan Cao on 9/18/19.
//  Copyright © 2019 Nhan Cao. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var elementNameLabel: UILabel!
    @IBOutlet weak var elementSymbolView: ElementGridView!
    @IBOutlet weak var elementDetailTable: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        elementDetailTable.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshUI()
    }
    
    
    var elementInfo: [String: Any]? = [String: Any]() {
        didSet {
            if self.elementInfo != nil {
                detailKeys = Array(self.elementInfo!.keys)
                detailKeys.removeAll { (k) -> Bool in
                    ["name", "number", "symbol", "xpos", "ypos", "summary", "spectral_img"].contains(k)
                }
                detailKeys.sort()
            } else {
                self.elementInfo = [String: Any]()
            }
            refreshUI()
        }
    }
    
    var detailKeys = [String]()
    
    private func refreshUI() {
        self.loadViewIfNeeded()
        
        if let details = elementInfo {
            elementNameLabel.text = (details["name"] as? String) ?? "N/A"
            elementSymbolView.display(symbol: details["symbol"] as? String, number: details["number"] as? Int)
            self.elementDetailTable.reloadData()
        }
        
        let indexPath = IndexPath(row: 0, section: 0)
        if elementDetailTable.numberOfRows(inSection: elementDetailTable.numberOfSections-1) > 0 {
            elementDetailTable.scrollToRow(at: indexPath, at: .top, animated: false)
        }
    
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailKeys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath)
        
        var detailName: String = detailKeys[indexPath.row]
        var detailInfo = convertToString(from: elementInfo![detailName])
        detailInfo = detailInfo.prefix(1).capitalized + detailInfo.dropFirst()
        if detailInfo == "---" {
            cell.textLabel?.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            cell.detailTextLabel?.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        } else {
            cell.textLabel?.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            cell.detailTextLabel?.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        cell.detailTextLabel?.text = detailInfo
        
        detailName = detailName.replacingOccurrences(of: "-", with: " ")
        detailName = detailName.replacingOccurrences(of: "_", with: " ")
        detailName = detailName.prefix(1).capitalized + detailName.dropFirst()
        cell.textLabel?.text = detailName
        
        return cell
    }
    
    

}

extension DetailViewController {
    func convertToString(from object: Any?) -> String {
        if object == nil {
            return "---"
        }
        
        switch object {
        case let s as String:
            return s
        case let i as Int:
            return String(i)
        case let d as Double:
            return String(d)
        case let a as [Any]:
            var str = ""
            for e in a {
                str += "\(convertToString(from: e))\n"
            }
            return String(str.dropLast())
        default:
            return "---"
        }
    }
    
//    static let Section = [
//        "General" : ["appearance", "color", "phase" ]
//    ]

}

extension DetailViewController: ElementSelectionDelegate {
    func elementSelected(_ element: [String : Any]) {
        elementInfo = element
    }
}

//extension UITableView {
//
////    public func reloadData(_ completion: @escaping ()->()) {
////        UIView.animate(withDuration: 0, animations: {
////            self.reloadData()
////        }, completion:{ _ in
////            completion()
////        })
////    }
//
//    func scroll(to: scrollsTo, animated: Bool) {
//        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
//            let numberOfSections = self.numberOfSections
//            let numberOfRows = self.numberOfRows(inSection: numberOfSections-1)
//            switch to{
//            case .top:
//                if numberOfRows > 0 {
//                    let indexPath = IndexPath(row: 0, section: 0)
//                    self.scrollToRow(at: indexPath, at: .top, animated: animated)
//                }
//                break
//            case .bottom:
//                if numberOfRows > 0 {
//                    let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections-1))
//                    self.scrollToRow(at: indexPath, at: .bottom, animated: animated)
//                }
//                break
//            }
//        }
//    }
//
//    enum scrollsTo {
//        case top,bottom
//    }
//}

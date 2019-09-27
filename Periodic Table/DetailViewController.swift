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
    
    var SectionHeaderHeight: CGFloat = 25
    
    private var sectionsHeader = ["Summary", "General", "Properties", "Source"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        elementDetailTable.dataSource = self
        refreshUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshUI()
    }
    
    var elementInfo: [String: Any]? = [String: Any]() {
        didSet {
            if self.elementInfo == nil {
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
//            print("\(details["symbol"] as? String) -- \(details["number"] as? Int)" )
            elementSymbolView.display(symbol: details["symbol"] as? String, number: details["number"] as? Int)
            self.elementDetailTable.reloadData()
        }
        
        let indexPath = IndexPath(row: 0, section: 0)
        if elementDetailTable.numberOfRows(inSection: elementDetailTable.numberOfSections-1) > 0 {
            elementDetailTable.scrollToRow(at: indexPath, at: .top, animated: false)
        }
    
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsHeader.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionName = sectionsHeader[section]
        let section = DetailViewController.Sections[sectionName] ?? [String]()
        return section.count
    }
    
    private func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return SectionHeaderHeight
    }
    
    private func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: SectionHeaderHeight))
        view.backgroundColor = UIColor.black
        
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: tableView.bounds.width - 30, height: SectionHeaderHeight))
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor.white
        
        label.text = sectionsHeader[section]
        view.addSubview(label)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath)
        
        let sectionName = sectionsHeader[indexPath.section]
        let section = DetailViewController.Sections[sectionName] ?? [String]()
        
        var detailName: String = section[indexPath.row]
        var detailInfo = DetailViewController.convertToString(from: elementInfo![detailName])
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
    static func convertToString(from object: Any?) -> String {
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
                str += "\(DetailViewController.convertToString(from: e))\n"
            }
            return String(str.dropLast())
        default:
            return "---"
        }
    }
    
    static let Sections = [
        "Summary" : ["summary"],
        "General" : ["appearance", "color", "phase", "category"],
        "Properties" : ["atomic_mass", "density", "boil", "melt", "molar_heat"],
        "Source" : ["source"]
    ]

}

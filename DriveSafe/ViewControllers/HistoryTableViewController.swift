//
//  HistoryTableViewController.swift
//  DriveSafe
//
//  Created by Chandler Glowicki on 4/9/22.
//

//THIS CLASS IS NOT BEING USED AND COULD BE USED IN FUTURE VERSIONS

import UIKit
import HealthKit

class HistoryTableViewController: UITableViewController{
    
    let BACKGROUND_COLOR = UIColor.init(red: 0.0863, green: 0, blue: 0.4471, alpha: 1)
    let FOREGROUND_COLOR = UIColor.init(red: 0, green: 0.9098, blue: 0.6667, alpha: 1)
    //let healthStore = HKHealthStore()

    
    var entries: [Drink] = []
    
    var sections = [Drink]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addToHistory(drink: Drink(numDrinks: 2, date: Date.distantPast))
        addToHistory(drink: Drink(numDrinks: 5, date: Date.now))
        addToHistory(drink: Drink(numDrinks: 5, date: Date.now))
        addToHistory(drink: Drink(numDrinks: 7, date: Date.distantFuture))
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.sortIntoSections(entries: self.entries)
        
        //healthStore.numberOfAlcoholicBeverages
    }
    
    func addToHistory(drink: Drink){
        for var drinks in entries{
            if drinks.date.short == drink.date.short{
                drinks.numDrinks = drinks.numDrinks + 1
                return
            }
        }
        entries.append(drink)
    }
    
    // MARK: - UITableViewDelegate
       override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) ->
           String? {
               return self.tableViewData?[section].sectionHeader
       }
     
       override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) ->
           CGFloat {
               return 80.0
       }

      override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection
           section: Int) {
           let header = view as! UITableViewHeaderFooterView
           header.textLabel?.textColor = BACKGROUND_COLOR
           header.contentView.backgroundColor = FOREGROUND_COLOR
       }
       
       
       override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView,
                               forSection section: Int) {
           let header = view as! UITableViewHeaderFooterView
           header.textLabel?.textColor = BACKGROUND_COLOR
           header.contentView.backgroundColor = FOREGROUND_COLOR
       }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if let data = self.tableViewData {
            return data.count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if let sectionInfo = self.tableViewData?[section] {
                return sectionInfo.entries.count
            } else {
                return 0
            }
        }

        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DrinkCell", for: indexPath)

            let entry = entries[indexPath.section]
            
            //Text to be displayed
            cell.textLabel?.text = "\(entry.numDrinks) Drinks"

            return cell
        }
    
    var tableViewData: [(sectionHeader: String, entries: [Drink])]? {
            didSet {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    
    
    func sortIntoSections(entries: [Drink]) {
        
        var tmpEntries : Dictionary<String,[Drink]> = [:]
        var tmpData: [(sectionHeader: String, entries: [Drink])] = []
        
        // partition into sections
        for entry in entries {
            let shortDate = entry.date.short
            if var bucket = tmpEntries[shortDate] {
                bucket.append(entry)
                tmpEntries[shortDate] = bucket
            } else {
                tmpEntries[shortDate] = [entry]
            }
        }
        
        // breakout into our preferred array format
        let keys = tmpEntries.keys
        for key in keys {
            if let val = tmpEntries[key] {
                tmpData.append((sectionHeader: key, entries: val))
            }
        }

        // sort by increasing date.
        tmpData.sort { (v1, v2) -> Bool in
            if v1.sectionHeader < v2.sectionHeader {
                return true
            } else {
                return false
            }
        }
        
        self.tableViewData = tmpData
    }
    
    
    
}

extension Date {
    struct Formatter {
        static let iso8601: DateFormatter = {
            let formatter = DateFormatter()
            formatter.calendar = Calendar(identifier: .iso8601)
            //formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSxxx"
            formatter.dateFormat = "MMM dd yyyy'T'HH:mm:ss.SSSxxx"
            return formatter
        }()
        
        static let short: DateFormatter = {
            let formatter = DateFormatter()
            //formatter.dateFormat = "yyyy-MM-dd"
            formatter.dateFormat = "MMM dd, yyyy"
            return formatter
        }()
    }
    
    var short: String {
        return Formatter.short.string(from: self)
    }
    
    var iso8601: String {
        return Formatter.iso8601.string(from: self)
    }
}

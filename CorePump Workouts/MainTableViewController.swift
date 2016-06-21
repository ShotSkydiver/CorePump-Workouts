//
//  MainTableViewController.swift
//  Example
//
//  Created by Mathias Carignani on 5/19/15.
//  Copyright (c) 2015 Mathias Carignani. All rights reserved.
//

import UIKit
import MCMHeaderAnimated

class MainTableViewController: UITableViewController {
    
    private let transitionManager = MCMHeaderAnimated()
    
    private var elements: NSArray! = []
    private var lastSelected: IndexPath! = nil
    
    let dates = ["21", "26", "5", "14"]
    let months = ["JUN", "JUN", "JUL", "JUL"]
    let descriptions = ["The premiere of UX conference at Kalyana no. 23", "The premiere of UX conference at Kalyana no. 23", "The premiere of UX conference at Kalyana no. 23", "The premiere of UX conference at Kalyana no. 23"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.elements = [
            ["color": UIColor(red: 25/255.0, green: 181/255.0, blue: 254/255.0, alpha: 1.0)],
            ["color": UIColor(red: 25/255.0, green: 181/255.0, blue: 254/255.0, alpha: 1.0)],
            ["color": UIColor(red: 25/255.0, green: 181/255.0, blue: 254/255.0, alpha: 1.0)],
            ["color": UIColor(red: 25/255.0, green: 181/255.0, blue: 254/255.0, alpha: 1.0)]
        ]
        
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.elements.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath) as! MainTableViewCell
        cell.background.layer.cornerRadius = 5
        cell.background.clipsToBounds = true

        cell.header.backgroundColor = self.elements.object(at: (indexPath as NSIndexPath).row).object(forKey: "color") as? UIColor
        cell.eventDate.text = dates[(indexPath as NSIndexPath).row]
        cell.eventMonth.text = months[(indexPath as NSIndexPath).row]
        cell.eventDescription.text = descriptions[(indexPath as NSIndexPath).row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140.0 //180.0
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "viewDetail" {
            self.lastSelected = self.tableView.indexPathForSelectedRow
            let element = self.elements.object(at: (self.tableView.indexPathForSelectedRow! as NSIndexPath).row)
            
            let destination = segue.destinationViewController as! DetailViewController
            destination.element = element as! NSDictionary
            destination.transitioningDelegate = self.transitionManager
            
            self.transitionManager.destinationViewController = destination
        }
    }
    
}

extension MainTableViewController: MCMHeaderAnimatedDelegate {
    
    func headerView() -> UIView {
        // Selected cell
        let cell = self.tableView.cellForRow(at: self.lastSelected) as! MainTableViewCell
        return cell.header
    }
    
    func headerCopy(_ subview: UIView) -> UIView {
        let cell = tableView.cellForRow(at: self.lastSelected) as! MainTableViewCell
        let header = UIView(frame: cell.header.frame)
        header.backgroundColor = self.elements.object(at: self.lastSelected.row).object(forKey: "color") as? UIColor
        
        return header
    }
    
}

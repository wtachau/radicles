//
//  RADAllPlantsTableViewController.swift
//  Radicles
//
//  Created by William Tachau on 9/18/14.
//  Copyright (c) 2014 Radicles. All rights reserved.
//

import Foundation

class RADAllPlantsTableViewController : UITableViewController {
    
    var plants:NSMutableArray = []
    
    override func viewDidLoad() {
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addPlant")
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let plant = self.plants.objectAtIndex(indexPath.row) as RADPlant
        let plantView = RADPlantViewController(plant: plant)
        self.navigationController!.pushViewController(plantView, animated: true)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.plants.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let plantIdentifier = "plantCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(plantIdentifier) as? UITableViewCell
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: plantIdentifier)
        }
        
        let plant = self.plants.objectAtIndex(indexPath.row) as RADPlant
        cell!.textLabel!.text = plant.name
        
        return cell!
    }
    
    func addPlant() {
        let plant = RADPlant(name: "plant\(self.plants.count)")
        self.plants.addObject(plant)
        let plantView = RADPlantViewController(plant: plant)
        self.navigationController!.pushViewController(plantView, animated: true)
        self.tableView.reloadData()
    }
    
}

//
//  SetsViewController.swift
//  myFitProgress
//
//  Created by Justin Vincelette on 2/27/16.
//  Copyright © 2016 Justin Vincelette. All rights reserved.
//

import UIKit

class SetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var workoutExercise: String = ""
    var sets: [[Int]] = []
    @IBOutlet weak var setsTableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        self.navigationItem.title = workoutExercise;
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let setsData = defaults.objectForKey(workoutExercise) as? [[Int]] {
             sets = setsData
        }
        
        self.navigationItem.setRightBarButtonItem(UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addSet:"), animated: true);
        setsTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sets.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = setsTableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
        var weight = String(sets[indexPath.row][0])
        var reps = String(sets[indexPath.row][1])
        reps.appendContentsOf(" reps");
        weight.appendContentsOf(" lbs for ");
        weight.appendContentsOf(reps);
        cell.textLabel?.text = weight;
        
        return cell
    }
    
    func addSet(sender: AnyObject) {
        var weightTextField: UITextField?
        var repsTextField: UITextField?
        let alertController = UIAlertController(title: "Add Set", message: nil, preferredStyle: .Alert)
        let add = UIAlertAction(title: "Add", style: .Default, handler:{(action) -> Void in
            let weight = Int(alertController.textFields![0].text!)!;
            let reps = Int(alertController.textFields![1].text!)!;
            let newSet = [weight, reps]
            self.sets.append(newSet)
            self.setsTableView.reloadData()
            self.save()
        });
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler:nil)
        alertController.addAction(add)
        alertController.addAction(cancel)
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            // Enter the textfiled customization code here.
            weightTextField = textField
            weightTextField?.placeholder = "Enter weight"
        }
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            // Enter the textfiled customization code here.
            repsTextField = textField
            repsTextField?.placeholder = "Enter number of reps"
        }
        presentViewController(alertController, animated: true, completion: nil);
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        _ = tableView.indexPathForSelectedRow!
        var weightTextField: UITextField?
        var repsTextField: UITextField?
        let alertController = UIAlertController(title: "Edit Set", message: nil, preferredStyle: .Alert)
        let add = UIAlertAction(title: "Confirm", style: .Default, handler:{(action) -> Void in
            let weight = (alertController.textFields![0].text)!;
            let reps = (alertController.textFields![1].text)!;
            self.sets[indexPath.row][0] = Int(weight)!
            self.sets[indexPath.row][1] = Int(reps)!
            self.setsTableView.reloadData()
            self.save()
        });
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler:nil)
        alertController.addAction(add)
        alertController.addAction(cancel)
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            // Enter the textfiled customization code here.
            weightTextField = textField
            weightTextField?.placeholder = "Enter weight"
        }
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            // Enter the textfiled customization code here.
            repsTextField = textField
            repsTextField?.placeholder = "Enter number of reps"
        }
        presentViewController(alertController, animated: true, completion: nil);
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            confirmDelete(indexPath.row);
        }
    }
    
    func confirmDelete(index:Int) {
        let alert = UIAlertController(title: "Delete Set", message: "Are you sure you want to permanently delete this set?", preferredStyle: .ActionSheet)
        
        let DeleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: {(action) -> Void in
            self.sets.removeAtIndex(index);
            self.setsTableView.reloadData();
            self.save()
        });
        let CancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func save() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(sets, forKey: workoutExercise)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

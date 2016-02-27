//
//  ViewController.swift
//  myFitProgress
//
//  Created by Justin Vincelette on 2/25/16.
//  Copyright © 2016 Justin Vincelette. All rights reserved.
//

import UIKit
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    var workouts: [String] = []
    @IBOutlet weak var workoutTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationItem.title = "Fit Progress"
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let savedData = defaults.objectForKey("SavedData") as? [String] {
            workouts = savedData
        }
        
        workoutTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workouts.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = workoutTableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
        cell.textLabel?.text = workouts[indexPath.row]
        
        return cell
    }

    @IBAction func addWorkout(sender: AnyObject) {
        var loginTextField: UITextField?
        let alertController = UIAlertController(title: "Add a Workout", message: nil, preferredStyle: .Alert)
        let add = UIAlertAction(title: "Add", style: .Default, handler:{(action) -> Void in
            self.workouts.append((alertController.textFields?.first?.text)!);
            self.workoutTableView.reloadData()
            self.save()
        });
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler:nil)
        alertController.addAction(add)
        alertController.addAction(cancel)
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            // Enter the textfiled customization code here.
            loginTextField = textField
            loginTextField?.placeholder = "Enter new workout name"
        }
        presentViewController(alertController, animated: true, completion: nil);
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        _ = tableView.indexPathForSelectedRow!
        if let _ = tableView.cellForRowAtIndexPath(indexPath) {
            self.performSegueWithIdentifier("exerciseSegue", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "exerciseSegue" {
            if let destination = segue.destinationViewController as? ExercisesViewController {
                let path = workoutTableView.indexPathForSelectedRow
                let cell = workoutTableView.cellForRowAtIndexPath(path!)
                let label = cell!.textLabel?.text
                destination.workout = label!
            }
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            confirmDelete(indexPath.row);
        }
    }
    
    func confirmDelete(index:Int) {
        let workoutName = workouts[index]
        
        let alert = UIAlertController(title: "Delete Workout", message: "Are you sure you want to permanently delete the \(workoutName) workout?", preferredStyle: .ActionSheet)
        
        let DeleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: {(action) -> Void in
            self.workouts.removeAtIndex(index);
            self.workoutTableView.reloadData();
            self.save()
        });
        let CancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }

    func save() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(workouts, forKey: "SavedData")
    }
    
    func getIndex(a: [String], word: String) -> Int {
        var workoutName: String
        for (var i = 0; i < a.capacity; i++) {
            workoutName = workouts[i]
            if (workoutName == word) {
                return i;
            }
        }
        return -1;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


//
//  ExercisesViewController.swift
//  myFitProgress
//
//  Created by Justin Vincelette on 2/25/16.
//  Copyright © 2016 Justin Vincelette. All rights reserved.
//

import UIKit

class ExercisesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var workoutName: String = ""
    var workout: Dictionary<String, AnyObject> = [:]
    var exercises: [Dictionary<String, AnyObject>] = []
    @IBOutlet weak var exerciseTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        workoutName = workout["Name"] as? String ?? String()
        self.navigationItem.title = workoutName;
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let exerciseData = defaults.objectForKey(workoutName) as? [Dictionary<String, AnyObject>] {
            exercises = exerciseData
        }
//        exercises = workout["Exercises"] as? [Dictionary<String, AnyObject>] ?? [Dictionary<String, AnyObject>]()
        
        self.navigationItem.setRightBarButtonItem(UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addExercise:"), animated: true);
        exerciseTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = exerciseTableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
        cell.textLabel?.text = getExerciseName(indexPath.row);
        
        return cell
    }
    
    func addExercise(sender: AnyObject) {
        var loginTextField: UITextField?
        let alertController = UIAlertController(title: "Add an Exercise", message: nil, preferredStyle: .Alert)
        let add = UIAlertAction(title: "Add", style: .Default, handler:{(action) -> Void in
            var sets: [Dictionary<Int, Int>] = []
            var newExercise: Dictionary<String, AnyObject> = ["Name": (alertController.textFields?.first?.text)!,
            "Sets": sets]
            self.exercises.append(newExercise);
            self.exerciseTableView.reloadData()
            self.save()
        });
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler:nil)
        alertController.addAction(add)
        alertController.addAction(cancel)
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            // Enter the textfiled customization code here.
            loginTextField = textField
            loginTextField?.placeholder = "Enter new exercise name"
        }
        presentViewController(alertController, animated: true, completion: nil);
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            confirmDelete(indexPath.row);
        }
    }
    
    func confirmDelete(index:Int) {
        let exerciseName = getExerciseName(index)
        
        let alert = UIAlertController(title: "Delete Exericise", message: "Are you sure you want to permanently delete the \(exerciseName) exercise?", preferredStyle: .ActionSheet)
        
        let DeleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: {(action) -> Void in
            self.exercises.removeAtIndex(index);
            self.exerciseTableView.reloadData();
            self.save()
        });
        let CancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func save() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(exercises, forKey: workoutName)
    }
    
    func getExerciseName(index: Int) -> String {
        let exerciseName: String
        let currDict: Dictionary<String, AnyObject>
        currDict = exercises[index]
        exerciseName = currDict["Name"] as? String ?? String()
        return exerciseName
    }
    
}

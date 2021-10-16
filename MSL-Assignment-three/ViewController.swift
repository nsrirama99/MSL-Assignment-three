//
//  ViewController.swift
//  MSL-Assignment-three
//
//  Created by UbiComp on 10/13/21.
//

import UIKit
import CoreMotion

protocol ModalDelegate {
    func setStepGoal(value: Int)
}

class ViewController: UIViewController, ModalDelegate {

    let defaults = UserDefaults.standard
    
    let activityManager = CMMotionActivityManager()
    let pedometer = CMPedometer()
    
    
    @IBOutlet weak var YesterdayLabel: UILabel!
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var currActivityLabel: UILabel!
    @IBOutlet weak var stepsToGoalLabel: UILabel!
    
    @IBOutlet weak var setGoalButton: UIButton!
    
    
    lazy var currSteps = 0 {
        didSet {
            if(stepGoal > 0) {
                stepsToGoal = stepGoal - currSteps
                stepsToGoalLabel.text = "Steps to Reach Goal: \(stepsToGoal)"
            }
        }
    }
    
    lazy var yesterdaySteps = 0 {
        didSet {
            if(stepGoal > 0) {
                stepsToPrevGoal = stepGoal - yesterdaySteps
            }
        }
    }
    
    lazy var stepGoal = -999
    lazy var stepsToGoal = -999
    lazy var stepsToPrevGoal = -999
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getYesterdaySteps()
        startPedometerMonitoring()
        
        let goal = defaults.integer(forKey: "stepGoalKey")
        if(goal != 0) {
            stepGoal = goal
        } else {
            stepsToGoalLabel.text = "No Goal has been Set"
        }

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //put stepGoal in User Defaults
        if(stepGoal > 0) {
            defaults.set(stepGoal, forKey: "stepGoalKey")
        }
        
        
        if(CMMotionActivityManager.isActivityAvailable()) {
            self.activityManager.stopActivityUpdates()
        }
        super.viewWillDisappear(animated)
    }

    func getYesterdaySteps() {
        if(CMPedometer.isStepCountingAvailable()) {
            let calendar = Calendar.current
            let x = calendar.startOfDay(for: Date())
            let y = calendar.date(byAdding: .day, value: -1, to: x)

            pedometer.queryPedometerData(from: y!, to: x) { (data, error) in
                // set yesterday label here
                DispatchQueue.main.async {
                    self.YesterdayLabel.text = "Steps Taken Yesterday: \(data!.numberOfSteps)"
                }
            }

        }
    } //end of getYesterdaySteps
    
    func startPedometerMonitoring(){
        if CMPedometer.isStepCountingAvailable(){
            pedometer.startUpdates(from: Date())
            {(pedData:CMPedometerData?, error:Error?)->Void in
                if let data = pedData {
                    self.currSteps = data.numberOfSteps.intValue
                    DispatchQueue.main.async {
                        self.todayLabel.text = data.numberOfSteps.description
                    }
                    
                }
            }
        }
    } //end of start PedometerMonitoring
    
    func startActivityMonitoring() {
        if CMMotionActivityManager.isActivityAvailable() {
            self.activityManager.startActivityUpdates(to: OperationQueue.main) { (activity:CMMotionActivity?)->Void in
                //{unknown, still, walking, running, cycling, driving}
                if let unwrappedActivity = activity {
                    if(unwrappedActivity.stationary) {
                        self.currActivityLabel.text = "Not moving, conf: \(unwrappedActivity.confidence.rawValue)"
                    } else if(unwrappedActivity.walking) {
                        self.currActivityLabel.text = "Walking, conf: \(unwrappedActivity.confidence.rawValue)"
                    } else if(unwrappedActivity.running) {
                        self.currActivityLabel.text = "Running, conf: \(unwrappedActivity.confidence.rawValue)"
                    } else if(unwrappedActivity.cycling) {
                        self.currActivityLabel.text = "Cycling, conf: \(unwrappedActivity.confidence.rawValue)"
                    } else if(unwrappedActivity.automotive) {
                        self.currActivityLabel.text = "Driving, conf: \(unwrappedActivity.confidence.rawValue)"
                    } else {
                        self.currActivityLabel.text = "Unknown activity: \(unwrappedActivity.confidence.rawValue)"
                    }
                }
            }
        }
    } //end startActivityMonitoring
    
    
    @IBAction func setNewGoal(_ sender: Any) {
        let modalController = ModalViewController()
        modalController.delegate = self
        self.present(modalController, animated: true, completion: nil)
    }
    
    func setStepGoal(value: Int) {
        stepGoal = value
    }
    
} //end of class


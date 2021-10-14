//
//  ViewController.swift
//  MSL-Assignment-three
//
//  Created by UbiComp on 10/13/21.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {

    let defaults = UserDefaults.standard
    
    let activityManager = CMMotionActivityManager()
    let pedometer = CMPedometer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}


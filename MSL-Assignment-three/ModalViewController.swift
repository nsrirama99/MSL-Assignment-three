//
//  ModalViewController.swift
//  MSL-Assignment-three
//
//  Created by UbiComp on 10/15/21.
//

import UIKit

class ModalViewController: UIViewController, UITextFieldDelegate {

    var delegate:ModalDelegate?
    
    @IBOutlet weak var stepGoalTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //stepGoalTextField.delegate = self
        // Do any additional setup after loading the view.
        
        //stepGoalTextField.text = "0"
        
        //stepGoalTextField.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    
    @IBAction func dismissView(_ sender: Any) {
        let x = Int(stepGoalTextField.text!) ?? -999
        
        stepGoalTextField.resignFirstResponder()
        
        if let delegate = self.delegate {
            delegate.setStepGoal(value: x)
        }
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

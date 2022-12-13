//
//  HistoryUpdateController.swift
//  MAPD714_FinalTest_BMI_Brijen
//
//  Created by Brijen Shah on 2022-12-13.
//  Student id: 301271637
//

import UIKit
import Firebase
import FirebaseDatabase

class HistoryUpdateController: UIViewController {
    
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var weightLabel: UILabel!
    var currentItem: Any?
    var userName: String?
    var userAge: String?
    var userHeight: String?
    var scaleMode: String?
    
    var ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateUnitLabel()
    }
    
    func updateUnitLabel(){
        if(scaleMode == "Metric") {
            weightLabel.text = "(in kg)"
        } else {
            weightLabel.text = "(in lbs)"
            
        }
    }
    /*
     OnClick function to add new record
     */

    @IBAction func saveNewRecord(_ sender: Any) {
        
        if(!weightTextField.text!.isEmpty && Double(weightTextField.text!) != nil) {
            let calcResult = calculateBMI(weight: Double(weightTextField.text!)!, height: Double(userHeight!)!, scaleMode: scaleMode!)
            let bmi = calcResult.bmi
            let userName = userName
            let userAge = userAge
            let userHeight = userHeight
            let userWeight = weightTextField.text
            let selectedCategory = calcResult.category
            let datePicker = datePicker.date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let dateString = dateFormatter.string(from: datePicker)
            self.ref.child(dateString).setValue([
                "name": userName!,
                "age": userAge ?? "20",
                "height": userHeight!,
                "weight": userWeight!,
                "bmi": bmi,
                "category": selectedCategory,
                "scaleMode": scaleMode!,
                "date": dateString
            ])
            navigationController?.popViewController(animated: true)
        }
    }
}


//
//  UserDataController.swift
//  MAPD714_FinalTest_BMI_Brijen
//
//  Created by Brijen Shah on 2022-12-13.
//  Student id: 301271637
//

import UIKit
import Firebase
import FirebaseDatabase

class UserDatacontroller : UIViewController {
    
    
    private var bmiCalculationTotal: [BMIModel] = []
    var scaleMode = "Metric"
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var modeSwitch: UISwitch!
    @IBOutlet weak var genderSwitch: UISwitch!
    @IBOutlet weak var bmiScoreLabel: UILabel!
    @IBOutlet weak var bmiCategorylabel: UILabel!
    @IBOutlet weak var resultView: UIView!
    
    var ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bmiScoreLabel.text = ""
        bmiCategorylabel.text = ""
        updateResultLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
/*
 Selection of Scale Mode
 */
    @IBAction func scaleModesSwitch(_ sender: UISwitch) {
        if(sender.isOn) {
            scaleMode = "Metric"
        } else {
            scaleMode = "Imperial"
        }
        self.heightTextField.text = ""
        self.weightTextField.text = ""
        updateResultLabel()
    }
    /*
     Selection of Gender
     */

    @IBAction func genderSwitch(_ sender: UISwitch) {
        if(sender.isOn){
            genderTextField.text = "Female"
        }
        else{
            genderTextField.text = "Male"
        }
    }
    
    /*
        
     Calculation Function On calculate Event Handler
     
     */
    
    @IBAction func calculateButton(_ sender: Any) {
        if(!heightTextField.text!.isEmpty && !weightTextField.text!.isEmpty) {
            if(Double(heightTextField.text!) != nil && Double(weightTextField.text!) != nil) {
                // calculate BMI
                let totalResult = calculateBMI(weight: Double(weightTextField.text!)!,
                                          height: Double(heightTextField.text!)!,
                                          scaleMode: scaleMode)
                let bmiResult = totalResult.bmi
                bmiScoreLabel.text = String(format: "%.1f", bmiResult)
                bmiCategorylabel.text = totalResult.category
                let date = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let dateString = dateFormatter.string(from: date)
                let userName = nameTextField.text
                let userAge = ageTextField.text
               // var gender = genderTextField.text
                let userHeight = heightTextField.text
                let userWeight = weightTextField.text
                let selectedCategory = bmiCategorylabel.text
                resultView.backgroundColor = totalResult.color
                self.ref.child(dateString).setValue([
                    "name": userName!,
                    "age": userAge!,
                    "height": userHeight!,
                    "weight": userWeight!,
                    //"gender" : Gender!,
                    "bmi": bmiResult,
                    "category": selectedCategory!,
                    "scaleMode": scaleMode,
                    "date": dateString ])}
        } else {
            bmiScoreLabel.text = ""
            bmiCategorylabel.text = ""
        }
    }
    
  /*
   Button "Done" navigates to TableView Screen
   */

    @IBAction func DoneButton(_ sender: Any) {
        tabBarController?.selectedIndex = 1
    }
    
    
    
    /*
     Function Load data to show last Calculation
     */
    func loadData()
    {
        ref.queryLimited(toLast: 1).observeSingleEvent(of: .childAdded, with: { [self] (child) in
            if
                let dataSnapshot = child as? DataSnapshot,
                let bmiDataChange = dataSnapshot.value as? [String:AnyObject],
                let userName = bmiDataChange["name"] as? String?,
                let userAge = bmiDataChange["age"] as? String?,
                let userHeight = bmiDataChange["height"] as? String?,
                let userWeight = bmiDataChange["weight"] as? String?,
                //var gender = bmiDataChange["Male"] as? String?,
                let scaleMode = bmiDataChange["scaleMode"] as? String?,
                let bmi = bmiDataChange["bmi"] as? Double?,
                let selectedCategory = bmiDataChange["category"] as? String
            {
                self.nameTextField.text = userName
                self.ageTextField.text = userAge
                self.heightTextField.text = userHeight
                self.weightTextField.text = userWeight
               // self.genderTextField.text = gender
                self.bmiScoreLabel.text = String(format: "%.1f", bmi!)
                self.bmiCategorylabel.text = selectedCategory
                self.scaleMode = scaleMode!
                resultView.backgroundColor = getColor(bmiResultColor: bmi!)
                self.updateResultLabel()
            }
        });
    }
    
    
    /*
     Function to update scale Label
     */
    
    func updateResultLabel(){
        if(scaleMode == "Metric") {
            heightLabel.text = "(in CM)"
            weightLabel.text = "(in KG)"
        } else {
            heightLabel.text = "(in Inch)"
            weightLabel.text = "(in LBS)"
            
        }
    }
}

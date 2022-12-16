//
//  Utils.swift
//  MAPD714_FinalTest_BMI_Brijen
//
//  Created by Brijen Shah on 2022-12-13.
//  Student id: 301271637
//

import Foundation
import UIKit

/*
 function to get BMI Results
 */

func calculateBMI(weight: Double = 0, height: Double = 0, scaleMode: String = "") ->
(bmi: Double, category: String, color: UIColor)
{
    var bmi = 0.0
    var heightM = 0.0
    if(scaleMode == "Metric") {
        heightM = (height / 100) * (height / 100)
        bmi =  weight / heightM
    } else if(scaleMode == "Imperial") {
        
        heightM = height * height
        bmi = (weight / heightM)  * 703
    }
    let category = getCategory(bmi: bmi)
    let color = getColor(bmiResultColor: bmi)
    return (bmi, category, color)
}


/*
 function to get color as per BMI results
 */
func getColor(bmiResultColor: Double) -> UIColor
{
    var color: UIColor
    switch bmiResultColor {
    case let x where x < 16:
        color = UIColor(red: 255/255, green: 201/255, blue: 40/255, alpha: 1.0)
    case 16...17:
       color = UIColor(red: 255/255, green: 215/255, blue: 100/255, alpha: 1.0)
    case 17...18.5:
        color = UIColor(red: 255/255, green: 221/255, blue: 122/255, alpha: 1.0)
    case 18.5...25:
        color = UIColor(red: 148/255, green: 239/255, blue: 2/255, alpha: 1.0)
    case 25...30:
        color = UIColor(red: 255/255, green: 168/255, blue: 56/255, alpha: 1.0)
    case 30...35:
        color = UIColor(red: 0/255, green: 156/255, blue: 191/255, alpha: 1.0)
        
    case 35...40:
        color = UIColor(red: 0/255, green: 127/255, blue: 191/255, alpha: 1.0)
    default:
        color = UIColor(red: 0/255, green: 79/255, blue: 191/255, alpha: 1.0)
    }
    
    return color
}


/*
 function to get BMI Categories
 */
func getCategory(bmi: Double) -> String {
    var category = ""
    switch bmi {
    case let x where x < 16:
        category = "You have Severe Thinness !!"
    case 16...17:
        category = "You have Moderate Thinness !!"
    case 17...18.5:
        category = "You have Mild Thinness !!"
    case 18.5...25:
        category = "You have Normal Body Mass !!"
    case 25...30:
        category = "You are Overweight !!"
    case 30...35:
        category = "You are Obese Class I !!"
    case 35...40:
        category = "You are Obese Class II !!"
    default:
        category = "You are Obese Class III !!"
    }
    
    return category
}

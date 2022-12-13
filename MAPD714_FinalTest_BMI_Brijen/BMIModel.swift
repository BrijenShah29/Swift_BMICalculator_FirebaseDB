//
//  BMIModel.swift
//  MAPD714_FinalTest_BMI_Brijen
//
//  Created by Brijen Shah on 2022-12-13.
//  Student id: 301271637
//

import Foundation

class BMIModel {
    
     var userName: String
     var userAge: Int
     var userHeight: Double
     var userWeight: Double
     //var gender : String
     var bmi: Double
     var selectedCategory: String
     var scaleMode: String
     var date: String
    
    init( userName: String,
          userAge:Int = 1,
          userHeight: Double = 0.0,
          userWeight: Double = 0.0,
          bmi: Double = 0.0,
          selectedCategory: String = "",
          scaleMode: String = "",
          date: String = ""
    )
    {
        self.userName = userName
        self.userAge = userAge
        self.userHeight = userHeight
        self.userWeight = userWeight
       // self.gender = gender
        self.bmi = bmi
        self.selectedCategory = selectedCategory
        self.scaleMode = scaleMode
        self.date = date
    }
    
}

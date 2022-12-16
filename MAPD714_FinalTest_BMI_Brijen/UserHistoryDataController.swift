//
//  UserHistoryDataController.swift
//  MAPD714_FinalTest_BMI_Brijen
//
//  Created by Brijen Shah on 2022-12-13.
//  Student id: 301271637
//

import UIKit
import Firebase
import FirebaseDatabase

class UserHistoryDataController : UITableViewController {
    
    private var bmiCalcList: [BMIModel] = []
    var cellIdentifier = "historyDataCell"
    var heightInPrevious: String?
    var modeInPrevious: String?
    var nameInPrevious: String?
    var ageInPrevious: String?
    
    var ref = Database.database().reference()
    var refObservers: [DatabaseHandle] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(HistoryTableViewCell.self,
                               forCellReuseIdentifier: cellIdentifier)
        tableView.rowHeight = 100
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getLastEntry()
        loadData()
    }
    
    /*
     function to get Last Result
     */
    func getLastEntry()
    {
        ref.queryLimited(toLast: 1).observeSingleEvent(of: .childAdded, with: { [self] (child) in
            if
                let dataSnapshot = child as? DataSnapshot,
                let dataChange = dataSnapshot.value as? [String:AnyObject],
                let userName = dataChange["name"] as? String?,
                let userAge = dataChange["age"] as? String?,
                let userHeight = dataChange["height"] as? String?,
                let scaleMode = dataChange["scaleMode"] as? String?
            {
                self.nameInPrevious = userName!
                self.ageInPrevious = userAge!
                self.heightInPrevious = userHeight!
                self.modeInPrevious = scaleMode!
            }
        });
    }

    /*
     function to show all records in tableView
     */
    func loadData()
    {
        bmiCalcList.removeAll()
        ref.observeSingleEvent(of: .value) {
            snapshot  in
            var bmiArray: [BMIModel] = []
        
            for child in snapshot.children {
                    if
                        let dataSnapshot = child as? DataSnapshot,
                        let datachange = dataSnapshot.value as? [String:AnyObject],
                        let userName = datachange["name"] as? String?,
                        let userAge = datachange["age"] as? String?,
                        let userHeight = datachange["height"] as? String?,
                        let userWeight = datachange["weight"] as? String?,
                        let bmi = datachange["bmi"] as? Double,
                        let scaleMode = datachange["scaleMode"] as? String?,
                        let date = datachange["date"] as? String?,
                        let selectedCategory = datachange["category"] as? String {

                        bmiArray.append(BMIModel(userName: userName ?? "Name1", userAge: Int(userAge ?? "22") ?? 22, userHeight: Double(userHeight!)!, userWeight: Double(userWeight!)!, bmi: bmi, selectedCategory: selectedCategory, scaleMode: scaleMode ?? "Metric", date: date!))
                }
            }
            self.bmiCalcList.append(contentsOf: bmiArray)
            self.tableView.reloadData()
            self.ref.removeAllObservers()
        }
    }
    
    /*
     Fetching Records
     */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if bmiCalcList.count < 1 {
            self.tableView.setEmptyMessage("Please enter your first record !!")
        } else {
            self.tableView.restore()
        }
        return bmiCalcList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! HistoryTableViewCell
        let tableRow = bmiCalcList[indexPath.row]
        
        if(tableRow.scaleMode == "Metric") {
            tableCell.WeightLabel.text = "Weight: " + String(format: "%.1f", tableRow.userWeight) + " kg"
        } else {
            tableCell.WeightLabel.text = "Weight: " + String(format: "%.1f", tableRow.userWeight) + " lbs"
        }
        tableCell.BMILabel.text = "BMI: " + String(format: "%.1f", tableRow.bmi)
        tableCell.CategoryLabel.text = tableRow.selectedCategory
        tableCell.backgroundColor = getColor(bmiResultColor: tableRow.bmi)
        tableCell.DateLabel.text = tableRow.date
        return tableCell
    }
    
    /*
     Adding New Record
     */
    @IBAction func historyPlus(_ sender: Any) {
        if(heightInPrevious == nil){
            let dialogMessage = UIAlertController(title: "Alert", message: "Please Input Your Personal information", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                
             })
            
            dialogMessage.addAction(ok)
            self.present(dialogMessage, animated: true, completion: nil)
            return
        }
        let senderData: [String: Any?] = ["name": self.nameInPrevious, "height": self.heightInPrevious , "scaleMode": self.modeInPrevious, "age": self.ageInPrevious]
        self.performSegue(withIdentifier: "showHistoryModifier", sender: senderData)
    }
    /*
     TableView Swipe Edit
     */
    
    override func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal,
                                        title: "Edit") { [weak self] (action, view, completionHandler) in
                                            self?.amendHistory(index: indexPath.row)
                                            completionHandler(true)
        }
        action.backgroundColor = .systemMint
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    /*
     Editing History Record
     */
    
    func amendHistory(index: Int)
    {
        let alert = UIAlertController(title: "Update Weight", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true)
    }
    
    /*
     TableView Swipe Delete
     */
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteSwipeAction = UIContextualAction(style: .normal, title: "Delete") {
            (contextualAction, view, actionPerformed: (Bool) -> ()) in
            let Data = self.bmiCalcList[indexPath.row]
            self.bmiCalcList.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.removeFromDB(child: Data.date)
        }
        deleteSwipeAction.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [deleteSwipeAction])
        return configuration
    }
    
    func removeFromDB(child: String) {
        let reference = self.ref.child(child)
        reference.removeValue { error, _ in
            print(error ?? "Error!!")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: (Any)?) {
        let history = segue.destination as! HistoryUpdateController
        let object = sender as! [String: Any?]
        history.userName = object["name"] as? String
        history.userAge = object["age"] as? String
        history.userHeight = object["height"] as? String
        history.scaleMode = object["scaleMode"] as? String
    }
}
extension UITableView {
    func setEmptyMessage(_ message: String) {
        let messageText = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageText.text = message
        messageText.textColor = .black
        messageText.font = UIFont(name: "Damascus", size: 16)
        messageText.sizeToFit()
      
    }

    func restore() {

        self.separatorStyle = .singleLine
    }
}

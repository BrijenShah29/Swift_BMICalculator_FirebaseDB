//
//  HistoryTableViewCell.swift
//  MAPD714_FinalTest_BMI_Brijen
//
//  Created by Brijen Shah on 2022-12-13.
//  Student id: 301271637
//

import UIKit

class HistoryTableViewCell : UITableViewCell {
    var WeightLabel : UILabel!
    var BMILabel : UILabel!
    var CategoryLabel : UILabel!
    var DateLabel : UILabel!
    var CellView : UIView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let bmiCategoryRect = CGRect(x:20, y:0, width: 200, height: 40)
        let bmiValueRect = CGRect(x:20, y:20, width: 200, height: 40)
        let weightValueRect = CGRect(x:20, y:40, width: 200, height: 40)
        let dateValueRect = CGRect(x:20, y:60, width: 200, height: 40)
        
        WeightLabel = UILabel(frame: weightValueRect)
        BMILabel = UILabel(frame: bmiValueRect)
        CategoryLabel = UILabel(frame: bmiCategoryRect)
        DateLabel = UILabel(frame: dateValueRect)
        
        CategoryLabel.textColor = UIColor.white
        BMILabel.textColor = UIColor.white
        WeightLabel.textColor = UIColor.white
        DateLabel.textColor = UIColor.white
        
        WeightLabel.font = UIFont(name: WeightLabel.font.fontName, size: 15)
        contentView.addSubview(WeightLabel)
        BMILabel.font = UIFont(name: BMILabel.font.fontName, size: 15)
        contentView.addSubview(BMILabel)
        CategoryLabel.font = UIFont(name: CategoryLabel.font.fontName, size: 15)
        contentView.addSubview(CategoryLabel)
        DateLabel.font = UIFont(name: DateLabel.font.fontName, size: 14)
        contentView.addSubview(DateLabel)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews()
    {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20))
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

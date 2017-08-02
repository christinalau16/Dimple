//
//  CalendarTableViewCell.swift
//  Tabbar App example
//
//  Created by Christina Lau on 7/28/17.
//  Copyright © 2017 Christina Lau. All rights reserved.
//

import UIKit

class CalendarTableViewCell: UITableViewCell {

    @IBOutlet weak var pageNameLabel: UILabel!
    @IBOutlet weak var starImage: UIImageView!
    
    public func setBackgroundView(index: Int, rowCount: Int)
    {
        let val = (CGFloat(index) / CGFloat(rowCount)) * 0.4 + 0.4
        let color = UIColor(red: val, green: 153.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        self.contentView.backgroundColor = color
    }
}

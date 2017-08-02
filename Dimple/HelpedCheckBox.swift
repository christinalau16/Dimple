//
//  HelpedCheckBox.swift
//  Tabbar App example
//
//  Created by Christina Lau on 7/10/17.
//  Copyright © 2017 Christina Lau. All rights reserved.
//

import UIKit

class HelpedCheckBox: UIButton {

    let checkedImage = UIImage(named: "ic_check_box")! as UIImage
    let uncheckedImage = UIImage(named: "ic_check_box_outline_blank")! as UIImage
    
    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                self.setImage(checkedImage, for: UIControlState.normal)
            } else {
                self.setImage(uncheckedImage, for: UIControlState.normal)
            }
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControlEvents.touchUpInside)
        self.isChecked = false
    }
    
    func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
            setCalendarDictionary(starred: isChecked)
        }
    }
    
    func setCalendarDictionary(starred: Bool)
    {
        let userDefaults = UserDefaults.standard
        var savedDictionary = NSKeyedUnarchiver.unarchiveObject(with: userDefaults.object(forKey: "calendarData") as! Data) as! [String: [DatePage]]
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        let userDate = formatter.string(from: Date())
        
        if let dayArray = savedDictionary[userDate]{
            dayArray.last?.starred = starred
            savedDictionary.updateValue(dayArray, forKey: userDate)
        }
        
        userDefaults.setValue(NSKeyedArchiver.archivedData(withRootObject: savedDictionary), forKey: "calendarData")
        userDefaults.synchronize()
    }
}

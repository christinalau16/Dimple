//
//  RootPageViewController.swift
//  Tabbar App example
//
//  Created by Christina Lau on 7/5/17.
//  Copyright © 2017 Christina Lau. All rights reserved.
//

import UIKit

class RootPageViewController: UIPageViewController, UIPageViewControllerDelegate {
    
    let formatter = DateFormatter()
    var nextPageIndex = 0
    let vcPageNames = ["Massage your temples", "Have a joke", "Breathe deeply", "Calming scenes", "Stand tall", "Drink hot water", "Body clench", "Dance","Let your feelings out", "Craft", "Eat a banana", "Chew some gum", "Buy a houseplant", "Eat a snack", "Take a nap", "Listen to music", "Do nothing for 1 minute", "Write", "Watch some comedy", "Make tea", "Ten minute walk", "Run", "Play a sport", "Take a warm bath", "Naam yoga hand trick"]

    lazy var viewControllerList:[UIViewController] = {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        var instantiatedVC: [UIViewController] = []
        let vcNames = ["templesVC", "jokeVC", "breatheVC", "imagineVC", "standVC", "waterVC", "bodyVC", "danceVC", "feelingsVC", "craftVC", "bananaVC", "gumVC", "plantVC", "eatVC", "sleepVC", "musicVC", "doNothingVC", "writeVC", "comedyVC", "teaVC", "walkVC", "runVC", "sportVC", "bathVC", "handVC"]
        for vcName in vcNames
        {
            let vc = sb.instantiateViewController(withIdentifier: vcName)
            instantiatedVC.append(vc)
        }
        return instantiatedVC
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        if let firstViewController = viewControllerList.first{
            self.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
        self.view.backgroundColor = UIColor.white
        
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        setCalendarDictionary()
    }

    func nextPageWithIndex () {
        let nextIndex = Int(arc4random_uniform(UInt32(viewControllerList.count)))
        guard viewControllerList.count != nextIndex else {return}
        guard viewControllerList.count > nextIndex else {return}
        setViewControllers([viewControllerList[nextIndex]], direction: .forward, animated: true, completion: nil)
        nextPageIndex = nextIndex
        setCalendarDictionary()
    }
    
    func setCalendarDictionary()
    {

        let currentPageName = vcPageNames[nextPageIndex]
        let currentPage = DatePage(pageName: currentPageName, starred: false)
        
        let userDefaults = UserDefaults.standard
        var savedDictionary: [String: [DatePage]]
        if userDefaults.object(forKey: "calendarData") != nil
        {
            savedDictionary = NSKeyedUnarchiver.unarchiveObject(with: userDefaults.object(forKey: "calendarData") as! Data) as! [String: [DatePage]]
        } else {
            savedDictionary = [:]
        }
        let userDate = formatter.string(from: Date())
        if let dayArray = savedDictionary[userDate]{
            var copyDayArray = dayArray
            copyDayArray.append(currentPage)
            savedDictionary.updateValue(copyDayArray, forKey: userDate)
        } else {
            savedDictionary.updateValue([currentPage], forKey: userDate)
        }
        
        userDefaults.setValue(NSKeyedArchiver.archivedData(withRootObject: savedDictionary), forKey: "calendarData")
        userDefaults.synchronize()
    }
}

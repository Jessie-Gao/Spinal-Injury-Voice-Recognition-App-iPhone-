//
//  CalendarViewController.swift
//  SpeechRec
//
//  Created by gj on 2016/10/12.
//  Copyright © 2016年 SpeechRec. All rights reserved.
//

import UIKit
import RealmSwift

struct Color {
    static let selectedText = UIColor.whiteColor()
    static let text = UIColor.blackColor()
    static let textDisabled = UIColor.grayColor()
    static let selectionBackground = UIColor(red: 0.2, green: 0.2, blue: 1.0, alpha: 1.0)
    static let sundayText = UIColor(red: 1.0, green: 0.2, blue: 0.2, alpha: 1.0)
    static let sundayTextDisabled = UIColor(red: 1.0, green: 0.6, blue: 0.6, alpha: 1.0)
    static let sundaySelectionBackground = sundayText
}
class CalendarViewController: BaseViewController {
    var resultData: Results<Answer>?
    
    @IBOutlet weak var calendar: CVCalendarView!
    
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var realNameLabel: UILabel!
    var animationFinished = true
    var monthLabel: UILabel!
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        calendar.contentController.refreshPresentedMonth()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        calendar.commitCalendarViewUpdate()
        menuView.commitMenuViewUpdate()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        monthLabel = addcenterBarItem("UNICORN")
        addNavigationBarRightButton(self, action: #selector(CalendarViewController.loginOut), image: UIImage(named: "loginout")!)
        realNameLabel.text = "Hi," + User.loginRealName
        
        let realm = try! Realm()
        let results = realm.objects(Answer.self).filter(NSPredicate(format:"userName = '\(User.loginUserName)'"))
        print(results)
        resultData = results
    }
    
    // logout
    func loginOut()  {
        User.loginOut()
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogOutNotification, object: nil)
    }
    
    // jump to the question interface
    func pushSpeech()  {
        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    // jump to the result interface
    func pushList(data: Results<Answer>)  {
        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("ListViewController") as! ListViewController
        vc.data = data
        self.navigationController?.pushViewController(vc, animated: true)
    }
}




// MARK: - CVCalendarViewDelegate & CVCalendarMenuViewDelegate

extension CalendarViewController: CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    
    /// Required method to implement!
    func presentationMode() -> CalendarMode {
        return .MonthView
    }
    
    /// Required method to implement!
    func firstWeekday() -> Weekday {
        return .Sunday
    }
    
    // MARK: Optional methods
    
    func dayOfWeekTextColor(by weekday: Weekday) -> UIColor {
        //return weekday == .Sunday ? UIColor(red: 1.0, green: 0.5, blue: 0.5, alpha: 1.0) : UIColor.whiteColor()
        return UIColor.whiteColor()
    }
    
    func shouldShowWeekdaysOut() -> Bool {
        return true
    }
    
    func shouldAnimateResizing() -> Bool {
        return true // Default value is true
    }
    func shouldAutoSelectDayOnMonthChange() -> Bool {
        return false
    }
    func shouldSelectDayView(dayView: DayView) -> Bool {
        let isEarly = dayView.date.convertedDate()!.compare(NSDate()) == .OrderedDescending
        return !isEarly
//        return true
    }
    
    func didSelectDayView(dayView: CVCalendarDayView, animationDidFinish: Bool) {
        print("\(dayView.date.commonDescription) is selected!")
        if let date =  dayView.date.convertedDate() {
            let haveCheck = resultData?.filter(NSPredicate(format:"date = '\(date.convertToShortString())'"))
            if dayView.isCurrentDay {
                if haveCheck?.count == 0 {
                    pushSpeech()
                } else {
                    pushList(haveCheck!)
                }
            } else {
                if haveCheck?.count > 0 {
                    pushList(haveCheck!)
                }
            }
        }
    }
    func presentedDateUpdated(date: CVDate) {
        if monthLabel.text != date.globalDescription && self.animationFinished {
            let updatedMonthLabel = UILabel()
            updatedMonthLabel.textColor = monthLabel.textColor
            updatedMonthLabel.font = monthLabel.font
            updatedMonthLabel.textAlignment = .Center
            updatedMonthLabel.text = date.globalDescription
            updatedMonthLabel.sizeToFit()
            updatedMonthLabel.alpha = 0
            updatedMonthLabel.center = self.monthLabel.center
            
            let offset = CGFloat(48)
            updatedMonthLabel.transform = CGAffineTransformMakeTranslation(0, offset)
            updatedMonthLabel.transform = CGAffineTransformMakeScale(1, 0.1)
            
            UIView.animateWithDuration(0.35, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                self.animationFinished = false
                self.monthLabel.transform = CGAffineTransformMakeTranslation(0, -offset)
                self.monthLabel.transform = CGAffineTransformMakeScale(1, 0.1)
                self.monthLabel.alpha = 0
                
                updatedMonthLabel.alpha = 1
                updatedMonthLabel.transform = CGAffineTransformIdentity
                
            }) { _ in
                
                self.animationFinished = true
                self.monthLabel.frame = updatedMonthLabel.frame
                self.monthLabel.text = updatedMonthLabel.text
                self.monthLabel.transform = CGAffineTransformIdentity
                self.monthLabel.alpha = 1
                updatedMonthLabel.removeFromSuperview()
            }
            
            self.view.insertSubview(updatedMonthLabel, aboveSubview: self.monthLabel)
        }
    }
    
    func topMarker(shouldDisplayOnDayView dayView: CVCalendarDayView) -> Bool {
        return false
    }
    
    func dotMarker(shouldShowOnDayView dayView: CVCalendarDayView) -> Bool {
        if let date =  dayView.date.convertedDate() {
            let haveCheck = resultData?.filter(NSPredicate(format:"date = '\(date.convertToShortString())'"))
            if haveCheck?.count > 0 {
                return true
            }
        }
        return false
    }
    
    func dotMarker(colorOnDayView dayView: CVCalendarDayView) -> [UIColor] {    //color
        return [yijiOrange] // return 1 dot
    }
    
    func dotMarker(shouldMoveOnHighlightingOnDayView dayView: CVCalendarDayView) -> Bool {
        return true
    }
    func dotMarker(moveOffsetOnDayView dayView: DayView) -> CGFloat {   //position
        return 13
    }
    func dotMarker(sizeOnDayView dayView: DayView) -> CGFloat { //size
        return 20
    }
    
    
    func weekdaySymbolType() -> WeekdaySymbolType {
        return .Short
    }
    
    func selectionViewPath() -> ((CGRect) -> (UIBezierPath)) {
        return { UIBezierPath(rect: CGRectMake(0, 0, $0.width, $0.height)) }
    }
    
    func shouldShowCustomSingleSelection() -> Bool {
        return false
    }
    
    func preliminaryView(viewOnDayView dayView: DayView) -> UIView {
        let circleView = CVAuxiliaryView(dayView: dayView, rect: dayView.bounds, shape: CVShape.Circle)
        circleView.fillColor = .colorFromCode(0xCCCCCC)
        return circleView
    }
    
    func preliminaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
        if (dayView.isCurrentDay) {
            return true
        }
        return false
    }
    
    func supplementaryView(viewOnDayView dayView: DayView) -> UIView {
        let π = M_PI
        
        let ringSpacing: CGFloat = 3.0
        let ringInsetWidth: CGFloat = 1.0
        let ringVerticalOffset: CGFloat = 1.0
        var ringLayer: CAShapeLayer!
        let ringLineWidth: CGFloat = 4.0
        let ringLineColour: UIColor = .blueColor()
        
        let newView = UIView(frame: dayView.bounds)
        
        let diameter: CGFloat = (newView.bounds.width) - ringSpacing
        let radius: CGFloat = diameter / 2.0
        
        let rect = CGRectMake(newView.frame.midX-radius, newView.frame.midY-radius-ringVerticalOffset, diameter, diameter)
        
        ringLayer = CAShapeLayer()
        newView.layer.addSublayer(ringLayer)
        
        ringLayer.fillColor = nil
        ringLayer.lineWidth = ringLineWidth
        ringLayer.strokeColor = ringLineColour.CGColor
        
        let ringLineWidthInset: CGFloat = CGFloat(ringLineWidth/2.0) + ringInsetWidth
        let ringRect: CGRect = CGRectInset(rect, ringLineWidthInset, ringLineWidthInset)
        let centrePoint: CGPoint = CGPointMake(ringRect.midX, ringRect.midY)
        let startAngle: CGFloat = CGFloat(-π/2.0)
        let endAngle: CGFloat = CGFloat(π * 2.0) + startAngle
        let ringPath: UIBezierPath = UIBezierPath(arcCenter: centrePoint, radius: ringRect.width/2.0, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        ringLayer.path = ringPath.CGPath
        ringLayer.frame = newView.layer.bounds
        
        return newView
    }
    
    func supplementaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
//        if (Int(arc4random_uniform(3)) == 1) {
//            return true
//        }
        
        return false
    }
    
    func dayOfWeekTextColor() -> UIColor {
        return UIColor.whiteColor()
    }
    
    func dayOfWeekBackGroundColor() -> UIColor {
        return UIColor.orangeColor()
    }
}

// MARK: - CVCalendarViewAppearanceDelegate

extension ViewController: CVCalendarViewAppearanceDelegate {
    func dayLabelPresentWeekdayInitallyBold() -> Bool {
        return false
    }
    
    func spaceBetweenDayViews() -> CGFloat {
        return 2
    }
    
    func dayLabelFont(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> UIFont { return UIFont.systemFontOfSize(14) }
    
    func dayLabelColor(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> UIColor? {
        switch (weekDay, status, present) {
        case (_, .Selected, _), (_, .Highlighted, _): return Color.selectedText
        case (.Sunday, .In, _): return Color.sundayText
        case (.Sunday, _, _): return Color.sundayTextDisabled
        case (_, .In, _): return Color.text
        default: return Color.textDisabled
        }
    }
    
    func dayLabelBackgroundColor(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> UIColor? {
        switch (weekDay, status, present) {
        case (.Sunday, .Selected, _), (.Sunday, .Highlighted, _): return Color.sundaySelectionBackground
        case (_, .Selected, _), (_, .Highlighted, _): return Color.selectionBackground
        default: return nil
        }
    }
}

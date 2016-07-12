//
//  FajrWake.swift
//  Fajr Wake
//
//  Created by Abidi on 5/13/16.
//  Copyright © 2016 FajrWake. All rights reserved.
//

import UIKit

// local GMT
class LocalGMT {
    class func getLocalGMT() -> Double {
        let localTimeZone = NSTimeZone.localTimeZone().abbreviation!
        let notCorrectedGMTFormat = localTimeZone.componentsSeparatedByString("GMT")
        let correctedGMTFormat: String = notCorrectedGMTFormat[1]
        let gmtArr = correctedGMTFormat.characters.split { $0 == ":" } .map {
            (x) -> Int in return Int(String(x))!
        }
        var gmt: Double = Double(gmtArr[0])
        
        if gmtArr[0] > 0 && gmtArr[1] == 30 {
            gmt += 0.5
        }
        if gmtArr[0] < 0 && gmtArr[1] == 30 {
            gmt -= 0.5
        }
        return gmt
    }
}

class DaysToRepeatLabel {
    class func getTextToRepeatDaysLabel(days: [Days]) -> String {
        var daysInString: [String] = []
        var daysForLabel: String = ""
        
        let weekends = [Days.Saturday, Days.Sunday]
        let weekdays = [Days.Monday, Days.Tuesday, Days.Wednesday, Days.Thursday, Days.Friday]
        
        let daysSet = Set(days)
        let findWeekendsListSet = Set(weekends)
        let findWeekdaysListSet = Set(weekdays)
        
        let containsWeekends = findWeekendsListSet.isSubsetOf(daysSet)
        let containsWeekdays = findWeekdaysListSet.isSubsetOf(daysSet)
        
        if days.count == 7 {
            daysForLabel += "Everyday"
            return daysForLabel
        }
        
        if days.count == 1 {
            daysForLabel += "\(days[0].getString)"
            return daysForLabel
        }
        
        // storing enum raw values in array to check if array contains (for array.contains method)
        for day in days {
            daysInString.append(day.getString)
        }
        
        if days.count == 2 {
            if containsWeekends {
                daysForLabel += "Weekends"
                return daysForLabel
            }
        }
        
        if days.count == 5 {
            if containsWeekdays {
                daysForLabel += "Weekdays"
                return daysForLabel
            }
        }
        
        for day in days {
            let str = day.getString
            daysForLabel += str[str.startIndex.advancedBy(0)...str.startIndex.advancedBy(2)] + " "
        }
        
        return daysForLabel
    }
}

// MARK: - Concrete Types

enum SalatsAndQadhas: Int {
    case Fajr
    case Sunrise
    case Dhuhr
    case Asr
    case Sunset
    case Maghrib
    case Isha
    
    var getString: String {
        return String(self)
    }
}

enum WakeOptions: Int {
    case OnTime
    case Before
    case After
    
    var getString: String {
        switch self {
        case OnTime:
            return "On Time"
        case Before:
            return "Before"
        case After:
            return "After"
        }
    }
}

enum AlarmType: Int {
    case FajrWakeAlarm
    case CustomAlarm
    
    var getString: String {
        switch self {
        case .FajrWakeAlarm: return "Fajr Wake Alarm"
        case .CustomAlarm: return "Custom Alarm"
        }
    }
}

enum Days: Int  {
    case Sunday
    case Monday
    case Tuesday
    case Wednesday
    case Thursday
    case Friday
    case Saturday
    
    var getString: String {
        return String(self)
    }
}

enum CalculationMethods: Int {
    
    case Jafari = 0
    case Karachi
    case Isna
    case Mwl
    case Makkah
    case Egypt
    case Tehran = 7
    
    func getString() -> String {
        switch self {
        case .Jafari: return "Shia Ithna Ashari, Leva Research Institute, Qum"
        case .Karachi: return "University of Islamic Sciences, Karachi"
        case .Isna: return "Islamic Society of North America"
        case .Mwl: return "Muslim World League"
        case .Makkah: return "Umm al-Qura University, Makkah"
        case .Egypt: return "Egyptian General Authority of Survey"
        case .Tehran: return "Institute of Geophysics, Tehran University"
        }
    }
}

enum PrayerTimeSettingsReference: String {
    case CalculationMethod, AsrJuristic, AdjustHighLats, TimeFormat
}

enum AlarmSounds: String {
    case AdhanMozenZadeh = "Moazen Zadeh", AdhanSyria = "Adhan Syria", AdhanAbatherAlHalawaji = "Abather Al-Halawaji", AdhanAbdulBasit = "Abdul Basit", AdhanRoohullahKazimzadeh = "Roohullah Kazimzadeh", AdhanMisharyRashidAlafasy = "Minshary Rashid Alafasy"
    case DuaKumayl = "Dua Kumayl", DuaJaushanKabeer = "Dua Jaushan Kabeer", DuaMujeer = "Dua Mujeer", MunajatImamAli = "Munajat Imam Ali", MunajatMuhibeen = "Munajat Muhibbeen"
    case SurahAleImran = "Surah Ale Imran", SurahAlHamd = "Surah Al-Hamd", SurahAlAnbia = "Surah Anbiya", SurahYaSin = "Surah Yasin"
    case Alarm, Radar, Apex, Chimes, Crickets, Presto, Timba, Pinball, Harp
    case None = "None"
    
    var URL: NSURL? {
        switch self {
        case .None:
            return nil
        case .Alarm, .Radar, .Apex, .Chimes, .Crickets, .Presto, .Timba, .Pinball, .Harp:
            return NSURL(fileURLWithPath: "/Library/Ringtones/\(self).m4r")
        default:
            let path = NSBundle.mainBundle().pathForResource("\(self)", ofType: "mp3", inDirectory: "Sounds")
            let url = NSURL(fileURLWithPath: path!)
            return url
        }
    }
}

enum AlarmSoundsSectionTitles: String {
    case Adhan
    case DuasMunajat = "Duas/Munajat"
    case Quran = "Quran"
    case SystemRingtones = "System Ringtones"
    case None = ""
}

struct AlarmSound {
    var alarmSound: AlarmSounds
    var alarmSectionTitle: AlarmSoundsSectionTitles
}

class UserSettingsPrayertimes {
    let calculationMethod: Int = NSUserDefaults.standardUserDefaults().integerForKey(PrayerTimeSettingsReference.CalculationMethod.rawValue)
    let asrJuristic: Int = NSUserDefaults.standardUserDefaults().integerForKey(PrayerTimeSettingsReference.AsrJuristic.rawValue)
    let adjustHighLats: Int = NSUserDefaults.standardUserDefaults().integerForKey(PrayerTimeSettingsReference.AdjustHighLats.rawValue)
    let timeFormat: Int = NSUserDefaults.standardUserDefaults().integerForKey(PrayerTimeSettingsReference.TimeFormat.rawValue)
    
    func getUserSettings() -> PrayerTimes {
        let userSettings = PrayerTimes(caculationmethod: PrayerTimes.CalculationMethods(rawValue: self.calculationMethod)!, asrJuristic: PrayerTimes.AsrJuristicMethods(rawValue: self.asrJuristic)!, adjustHighLats: PrayerTimes.AdjustingMethods(rawValue: self.adjustHighLats)!, timeFormat: PrayerTimes.TimeForamts(rawValue: self.timeFormat)!)
        return userSettings
    }
}

// MARK: - Protocols
protocol AlarmClockType {
    var alarmLabel: String { get set }
    var daysToRepeat: [Days]? { get set }
    var sound: AlarmSound { get set }
    var snooze: Bool { get set }
    var alarmType: AlarmType { get set }
    var alarmOnOff: Bool { get set }
    func timeToAlarm(prayerTimes: [String: String]?) -> NSDate?
    
    var attributedTitle: NSMutableAttributedString { get }
}

extension AlarmClockType {
    
    var repeatDaysDisplayString: String? {
        var repeatDaysString: String?
        if let days = daysToRepeat {
            repeatDaysString = DaysToRepeatLabel.getTextToRepeatDaysLabel(days)
        }
        return repeatDaysString
    }
    
    var attributedSubtitle: NSMutableAttributedString {
        var label = self.alarmLabel
        let alarmSubtitle: String
        let alarmSubtitleAttributedString: NSMutableAttributedString
        if var days = repeatDaysDisplayString {
            label += ","
            days = " \(days)"
            alarmSubtitle = label + days
            let rangeOfAlarmLabel = (alarmSubtitle as NSString).rangeOfString(label)
            let rangeOfDays = (alarmSubtitle as NSString).rangeOfString(days)
            alarmSubtitleAttributedString = NSMutableAttributedString(string: alarmSubtitle)
            alarmSubtitleAttributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Medium", size: 15)!, range: rangeOfAlarmLabel)
            alarmSubtitleAttributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue", size: 15)!, range: rangeOfDays)
        } else {
            alarmSubtitle = label
            let rangeOfAlarmLabel = (alarmSubtitle as NSString).rangeOfString(label)
            alarmSubtitleAttributedString = NSMutableAttributedString(string: alarmSubtitle)
            alarmSubtitleAttributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Medium", size: 15)!, range: rangeOfAlarmLabel)
        }
        return alarmSubtitleAttributedString
    }
}

struct CustomAlarm: AlarmClockType {
    var alarmLabel: String
    var daysToRepeat: [Days]?
    var sound: AlarmSound
    var snooze: Bool
    var time: NSDate
    var alarmType: AlarmType
    var alarmOnOff: Bool
    
    func timeToAlarm(prayerTimes: [String: String]?) -> NSDate? {
        let currentDate = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let currentDateComponents = calendar.components([.Month, .Year, .Day], fromDate: currentDate)
        let pickerTimeComponents = calendar.components([.Hour, .Minute], fromDate: time)
        let timeToAlarmComponents = NSDateComponents()
        timeToAlarmComponents.year = currentDateComponents.year
        timeToAlarmComponents.month = currentDateComponents.month
        timeToAlarmComponents.day = currentDateComponents.day
        timeToAlarmComponents.hour = pickerTimeComponents.hour
        timeToAlarmComponents.minute = pickerTimeComponents.minute
        timeToAlarmComponents.second = 0
        let timeToAlarm = calendar.dateFromComponents(timeToAlarmComponents)
        
        return timeToAlarm
    }
    
    var timeToString: String {
        let outputFormatter = NSDateFormatter()
        outputFormatter.dateFormat = "h:mm a"
        let stringFromDate = outputFormatter.stringFromDate(time)
        return stringFromDate
    }
    
    var attributedTitle: NSMutableAttributedString {
        let alarmAttributedTitle = NSMutableAttributedString(string: timeToString)
        let amOrPm: String
        if timeToString.rangeOfString("AM") != nil {
            amOrPm = "AM"
        } else {
            amOrPm = "PM"
        }
        let amPMRange = (timeToString as NSString).rangeOfString(" \(amOrPm)")
        timeToString.characters.count
        let alarmTimeRange: NSRange = NSMakeRange(0, amPMRange.location)
        alarmAttributedTitle.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Thin", size: 40)!, range: alarmTimeRange)
        alarmAttributedTitle.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Light", size: 15)!, range: amPMRange)
        return alarmAttributedTitle
    }
}

struct FajrWakeAlarm: AlarmClockType {
    var alarmLabel: String
    var daysToRepeat: [Days]?
    var sound: AlarmSound
    var snooze: Bool
    var minsToAdjust: Int
    var whenToWake: WakeOptions
    var whatSalatToWake: SalatsAndQadhas
    var alarmType: AlarmType
    var alarmOnOff: Bool
    
    func timeToAlarm(prayerTimes: [String: String]?) -> NSDate? {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        let salatOrQadhaTime = dateFormatter.dateFromString(prayerTimes![whatSalatToWake.getString]!)
        
        let calendar = NSCalendar.currentCalendar()
        var adjustedTime: NSDate?
        
        if whenToWake == .OnTime {
           adjustedTime = salatOrQadhaTime
        } else if whenToWake == .Before {
            adjustedTime = calendar.dateByAddingUnit(.Minute, value: -minsToAdjust, toDate: salatOrQadhaTime!, options: [])
        } else if whenToWake == .After {
            adjustedTime = calendar.dateByAddingUnit(.Minute, value: minsToAdjust, toDate: salatOrQadhaTime!, options: [])
        }
        
        let currentDate = NSDate()
        let currentDateComponents = calendar.components([.Month, .Year, .Day], fromDate: currentDate)
        let adjustedTimeComponents = calendar.components([.Hour, .Minute], fromDate: adjustedTime!)
        let timeToAlarmComponents = NSDateComponents()
        timeToAlarmComponents.year = currentDateComponents.year
        timeToAlarmComponents.month = currentDateComponents.month
        timeToAlarmComponents.day = currentDateComponents.day
        timeToAlarmComponents.hour = adjustedTimeComponents.hour
        timeToAlarmComponents.minute = adjustedTimeComponents.minute
        timeToAlarmComponents.second = 0
        let timeToAlarm = calendar.dateFromComponents(timeToAlarmComponents)
        
        return timeToAlarm
    }
    
    var title: String {
        if whenToWake == .OnTime {
            return "\(whatSalatToWake.getString)"
        } else {
            return "\(minsToAdjust) MIN \(whenToWake.getString) \(whatSalatToWake.getString)"
        }
    }
    
    var attributedTitle: NSMutableAttributedString {
        let alarmAttributedTitle = NSMutableAttributedString(string: title)
        let rangeOfMinutesToAdjust = (title as NSString).rangeOfString(String(minsToAdjust))
        let rangeOfMinText = (title as NSString).rangeOfString(" MIN")
        var rangeOfRestOfText: NSRange
        if whenToWake == .OnTime {
            rangeOfRestOfText = (title as NSString).rangeOfString("\(whatSalatToWake.getString)")
        } else {
            rangeOfRestOfText = (title as NSString).rangeOfString("\(whenToWake.getString) \(whatSalatToWake.getString)")
        }
        
        alarmAttributedTitle.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Light", size: 10)!, range: rangeOfMinText)
        alarmAttributedTitle.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Light", size: 25)!, range: rangeOfMinutesToAdjust)
        alarmAttributedTitle.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Light", size: 25)!, range: rangeOfRestOfText)

        return alarmAttributedTitle
    }
}
















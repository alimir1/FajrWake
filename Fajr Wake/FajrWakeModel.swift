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
    case MozenZadeh = "Moazen Zadeh", AbatharAlHalawaji = "Abathar Al-Halawaji", AbdulBasit = "Abdul Basit", KazemZadeh = "Roohullah Kazimzadeh", Rozayghi, TasviehChi = "Tasvieh Chi"
    case DuaKumayl = "Dua Kumayl", DuaJaushanKabeer = "Dua Jaushan Kabeer", DuaMujeer = "Dua Mujeer", MunajatImamAli = "Munajat Imam Ali", MunajatMuhibeen = "Munajat Muhibbeen"
    case Anbia, AleImran, Hamd, Fajr, Isra, Qaf
    case BirdsChirping2 = "Birds Chirping 2", BirdsChirping = "Birds Chirping", Crickets, Ocean
    case None = "None"
    
    var URL: NSURL? {
        switch self {
        case .None:
            return nil
        default:
            let path = NSBundle.mainBundle().pathForResource("\(self)", ofType: "caf", inDirectory: "Sounds")
            let url = NSURL(fileURLWithPath: path!)
            return url
        }
    }
    
    var pathForLocalNotification: String? {
        switch self {
        case .None:
            return nil
        default:
            return "Sounds/\(self).caf"
        }
    }
}

enum AlarmSoundsSectionTitles: String {
    case Adhan
    case DuasMunajat = "Duas and Munajat"
    case Quran
    case Nature
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

// MARK: - Protocol
protocol AlarmClockType {
    var alarmLabel: String { get set }
    var sound: AlarmSound { get set }
    var snooze: Bool { get set }
    var alarmType: AlarmType { get set }
    var alarmOn: Bool { get set }
    var alarm: NSTimer { get set }
    var savedAlarmDate: NSDate? { get set }
    var attributedTitle: NSMutableAttributedString { get }
    var localNotification: UILocalNotification { get }
    
    static var DocumentsDirectory: NSURL { get }
    static var ArchiveURL: NSURL { get }
    
    func timeToAlarm(prayerTimes: [String: String]?) -> NSDate
}

extension AlarmClockType {
    var attributedSubtitle: NSMutableAttributedString {
        let label = self.alarmLabel
        let alarmSubtitle: String
        let alarmSubtitleAttributedString: NSMutableAttributedString
        alarmSubtitle = label
        let rangeOfAlarmLabel = (alarmSubtitle as NSString).rangeOfString(label)
        alarmSubtitleAttributedString = NSMutableAttributedString(string: alarmSubtitle)
        alarmSubtitleAttributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Medium", size: 15)!, range: rangeOfAlarmLabel)

        return alarmSubtitleAttributedString
    }
    
    mutating func startAlarm(target: AnyObject, selector: Selector, date: NSDate, userInfo: AnyObject?) {
        alarm.invalidate()

        alarm = NSTimer.scheduledTimerWithTimeInterval(date.timeIntervalSinceNow, target: target, selector: selector, userInfo: userInfo, repeats: false)
        NSRunLoop.currentRunLoop().addTimer(alarm, forMode: NSDefaultRunLoopMode)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm a"
        let dateString = dateFormatter.stringFromDate(date)
        print("NSTimer scheduled for: \(dateString)")
    }
    
    mutating func stopAlarm() {
        if alarm.valid {
            alarm.invalidate()
            print("NSTimer Invalidated")
        }
    }
    
    func scheduleLocalNotification(date: NSDate, noSound: Bool? = false) {
        localNotification.fireDate = date
        localNotification.alertBody = "\(self.attributedTitle.string)\n\(self.alarmLabel)"
        if self.sound.alarmSound.URL != nil {
            if noSound == false {
                localNotification.soundName = sound.alarmSound.pathForLocalNotification
            } else {
                localNotification.soundName = nil
            }
        }
        
        // Schedule a notification
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm a"
        let dateString = dateFormatter.stringFromDate(date)
        print("Local Notification scheduled for: \(dateString)")
    }
}

class CustomAlarm: NSObject, AlarmClockType, NSCoding {
    var alarmLabel: String
    var sound: AlarmSound
    var snooze: Bool
    var time: NSDate
    var alarmType: AlarmType
    var alarmOn: Bool
    var alarm: NSTimer = NSTimer()
    var savedAlarmDate: NSDate?
    var localNotification = UILocalNotification()
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("customAlarmAlarms")
    
    init(alarmLabel: String, sound: AlarmSound, snooze: Bool, time: NSDate, alarmType: AlarmType, alarmOn: Bool, savedAlarmDate: NSDate? = nil) {
        self.alarmLabel = alarmLabel
        self.sound = sound
        self.snooze = snooze
        self.time = time
        self.alarmType = alarmType
        self.alarmOn = alarmOn
        self.savedAlarmDate = savedAlarmDate
        
        super.init()
    }

    func timeToAlarm(prayerTimes: [String: String]?) -> NSDate {
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
        
        return calendar.dateFromComponents(timeToAlarmComponents)!
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
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(alarmLabel, forKey: CustomAlarmPropertyKey.alarmLabelKey)
        aCoder.encodeObject(sound.alarmSound.rawValue, forKey: CustomAlarmPropertyKey.alarmSoundKey)
        aCoder.encodeObject(sound.alarmSectionTitle.rawValue, forKey: CustomAlarmPropertyKey.alarmSoundSectionKey)
        aCoder.encodeObject(snooze, forKey: CustomAlarmPropertyKey.snoozeKey)
        aCoder.encodeObject(time, forKey: CustomAlarmPropertyKey.timeKey)
        aCoder.encodeObject(alarmType.rawValue, forKey: CustomAlarmPropertyKey.alarmTypeKey)
        aCoder.encodeObject(alarmOn, forKey: CustomAlarmPropertyKey.alarmOnKey)
        aCoder.encodeObject(savedAlarmDate, forKey: CustomAlarmPropertyKey.savedAlarmDateKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let alarmLabel = aDecoder.decodeObjectForKey(CustomAlarmPropertyKey.alarmLabelKey) as! String
        let alarmSound = aDecoder.decodeObjectForKey(CustomAlarmPropertyKey.alarmSoundKey) as! String
        let alarmSoundSection = aDecoder.decodeObjectForKey(CustomAlarmPropertyKey.alarmSoundSectionKey) as! String
        let sound = AlarmSound(alarmSound: AlarmSounds(rawValue: alarmSound)!, alarmSectionTitle: AlarmSoundsSectionTitles(rawValue: alarmSoundSection)!)
        let snooze = aDecoder.decodeObjectForKey(CustomAlarmPropertyKey.snoozeKey) as! Bool
        let time = aDecoder.decodeObjectForKey(CustomAlarmPropertyKey.timeKey) as! NSDate
        let alarmType = AlarmType(rawValue: aDecoder.decodeObjectForKey(CustomAlarmPropertyKey.alarmTypeKey) as! Int)!
        let alarmOn = aDecoder.decodeObjectForKey(CustomAlarmPropertyKey.alarmOnKey) as! Bool
        let savedAlarmDate = aDecoder.decodeObjectForKey(CustomAlarmPropertyKey.savedAlarmDateKey) as? NSDate
        
        self.init(alarmLabel: alarmLabel, sound: sound, snooze: snooze, time: time, alarmType: alarmType, alarmOn: alarmOn, savedAlarmDate: savedAlarmDate)
    }

}

class FajrWakeAlarm: NSObject, AlarmClockType, NSCoding {
    var alarmLabel: String
    var sound: AlarmSound
    var snooze: Bool
    var minsToAdjust: Int
    var whenToWake: WakeOptions
    var whatSalatToWake: SalatsAndQadhas
    var alarmType: AlarmType
    var alarmOn: Bool
    var alarm: NSTimer = NSTimer()
    var savedAlarmDate: NSDate?
    var localNotification = UILocalNotification()
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("fajrWakeAlarms")
    
    init(alarmLabel: String, sound: AlarmSound, snooze: Bool, minsToAdjust: Int, whenToWake: WakeOptions, whatSalatToWake: SalatsAndQadhas, alarmType: AlarmType, alarmOn: Bool, dateTesting: NSDate? = nil) {
        self.alarmLabel = alarmLabel
        self.sound = sound
        self.snooze = snooze
        self.minsToAdjust = minsToAdjust
        self.whenToWake = whenToWake
        self.whatSalatToWake = whatSalatToWake
        self.alarmType = alarmType
        self.alarmOn = alarmOn
        self.savedAlarmDate = dateTesting
        
        super.init()
    }
        
    func timeToAlarm(prayerTimes: [String: String]?) -> NSDate {
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
        
        return timeToAlarm!
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
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(alarmLabel, forKey: FajrAlarmPropetKey.alarmLabelKey)
        aCoder.encodeObject(sound.alarmSound.rawValue, forKey: FajrAlarmPropetKey.alarmSoundKey)
        aCoder.encodeObject(sound.alarmSectionTitle.rawValue, forKey: FajrAlarmPropetKey.alarmSoundSectionKey)
        aCoder.encodeObject(snooze, forKey: FajrAlarmPropetKey.snoozeKey)
        aCoder.encodeObject(alarmType.rawValue, forKey: FajrAlarmPropetKey.alarmTypeKey)
        aCoder.encodeObject(minsToAdjust, forKey: FajrAlarmPropetKey.minsToAdjustKey)
        aCoder.encodeObject(whenToWake.rawValue, forKey: FajrAlarmPropetKey.whenToWakeKey)
        aCoder.encodeObject(whatSalatToWake.rawValue, forKey: FajrAlarmPropetKey.whatSalatToWakeKey)
        aCoder.encodeObject(alarmOn, forKey: FajrAlarmPropetKey.alarmOnKey)
        aCoder.encodeObject(savedAlarmDate, forKey: FajrAlarmPropetKey.savedAlarmDateKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let alarmLabel = aDecoder.decodeObjectForKey(FajrAlarmPropetKey.alarmLabelKey) as! String
        let alarmSound = aDecoder.decodeObjectForKey(FajrAlarmPropetKey.alarmSoundKey) as! String
        let alarmSoundSection = aDecoder.decodeObjectForKey(FajrAlarmPropetKey.alarmSoundSectionKey) as! String
        let sound = AlarmSound(alarmSound: AlarmSounds(rawValue: alarmSound)!, alarmSectionTitle: AlarmSoundsSectionTitles(rawValue: alarmSoundSection)!)
        let snooze = aDecoder.decodeObjectForKey(CustomAlarmPropertyKey.snoozeKey) as! Bool
        let alarmType = AlarmType(rawValue: aDecoder.decodeObjectForKey(FajrAlarmPropetKey.alarmTypeKey) as! Int)!
        let alarmOn = aDecoder.decodeObjectForKey(FajrAlarmPropetKey.alarmOnKey) as! Bool
        let minsToAdjust = aDecoder.decodeObjectForKey(FajrAlarmPropetKey.minsToAdjustKey) as! Int
        let whenToWake: WakeOptions = WakeOptions(rawValue: aDecoder.decodeObjectForKey(FajrAlarmPropetKey.whenToWakeKey) as! Int)!
        let whatSalatToWake: SalatsAndQadhas = SalatsAndQadhas(rawValue: aDecoder.decodeObjectForKey(FajrAlarmPropetKey.whatSalatToWakeKey) as! Int)!
        let savedAlarmDate = aDecoder.decodeObjectForKey(FajrAlarmPropetKey.savedAlarmDateKey) as? NSDate
        
        self.init(alarmLabel: alarmLabel, sound: sound, snooze: snooze, minsToAdjust: minsToAdjust, whenToWake: whenToWake, whatSalatToWake: whatSalatToWake, alarmType: alarmType, alarmOn: alarmOn, dateTesting: savedAlarmDate)
    }
}

struct CustomAlarmPropertyKey {
    static let alarmLabelKey = "alarmLabel"
    static let alarmSoundKey = "sound"
    static let alarmSoundSectionKey = "alarmSoundSection"
    static let snoozeKey = "snooze"
    static let timeKey = "time"
    static let alarmTypeKey = "alarmType"
    static let alarmOnKey = "alarmOn"
    static let savedAlarmDateKey = "savedAlarmDate"
}

struct FajrAlarmPropetKey {
    static let alarmLabelKey = "alarmLabel"
    static let alarmSoundKey = "sound"
    static let alarmSoundSectionKey = "alarmSoundSection"
    static let snoozeKey = "snooze"
    static let minsToAdjustKey = "minsToAdjust"
    static let whenToWakeKey = "whenToWake"
    static let whatSalatToWakeKey = "whatSalatToWake"
    static let alarmTypeKey = "alarmType"
    static let alarmOnKey = "alarmOn"
    static let savedAlarmDateKey = "savedAlarmDate"
}


















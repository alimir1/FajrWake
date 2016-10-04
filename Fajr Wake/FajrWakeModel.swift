//
//  FajrWake.swift
//  Fajr Wake
//
//  Created by Ali Mir on 5/13/16.
//  Copyright © 2016 FajrWake. All rights reserved.
//

import UIKit

// local GMT
class LocalGMT {
    class func getLocalGMT() -> Double {
        let localTimeZone = NSTimeZone.local.abbreviation()!
        let notCorrectedGMTFormat = localTimeZone.components(separatedBy: "GMT")
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
    class func getTextToRepeatDaysLabel(_ days: [Days]) -> String {
        var daysInString: [String] = []
        var daysForLabel: String = ""
        
        let weekends = [Days.saturday, Days.sunday]
        let weekdays = [Days.monday, Days.tuesday, Days.wednesday, Days.thursday, Days.friday]
        
        let daysSet = Set(days)
        let findWeekendsListSet = Set(weekends)
        let findWeekdaysListSet = Set(weekdays)
        
        let containsWeekends = findWeekendsListSet.isSubset(of: daysSet)
        let containsWeekdays = findWeekdaysListSet.isSubset(of: daysSet)
        
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
            daysForLabel += str[str.characters.index(str.startIndex, offsetBy: 0)...str.characters.index(str.startIndex, offsetBy: 2)] + " "
        }
        
        return daysForLabel
    }
}

// MARK: - Concrete Types

enum SalatsAndQadhas: Int {
    case fajr
    case sunrise
    case dhuhr
    case asr
    case sunset
    case maghrib
    case isha
    
    var getString: String {
        return String(describing: self)
    }
}

enum WakeOptions: Int {
    case onTime
    case before
    case after
    
    var getString: String {
        switch self {
        case .onTime:
            return "On Time"
        case .before:
            return "Before"
        case .after:
            return "After"
        }
    }
}

enum AlarmType: Int {
    case fajrWakeAlarm
    case customAlarm
    
    var getString: String {
        switch self {
        case .fajrWakeAlarm: return "Fajr Wake Alarm"
        case .customAlarm: return "Custom Alarm"
        }
    }
}

enum Days: Int  {
    case sunday
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    
    var getString: String {
        return String(describing: self)
    }
}

enum CalculationMethods: Int {
    case jafari = 0
    case karachi
    case isna
    case mwl
    case makkah
    case egypt
    case tehran = 7
    
    func getString() -> String {
        switch self {
        case .jafari: return "Shia Ithna Ashari, Leva Research Institute, Qum"
        case .karachi: return "University of Islamic Sciences, Karachi"
        case .isna: return "Islamic Society of North America"
        case .mwl: return "Muslim World League"
        case .makkah: return "Umm al-Qura University, Makkah"
        case .egypt: return "Egyptian General Authority of Survey"
        case .tehran: return "Institute of Geophysics, Tehran University"
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
    
    var URL: Foundation.URL? {
        switch self {
        case .None:
            return nil
        default:
            let path = Bundle.main.path(forResource: "\(self)", ofType: "caf", inDirectory: "Sounds")
            let url = Foundation.URL(fileURLWithPath: path!)
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
    let calculationMethod: Int = UserDefaults.standard.integer(forKey: PrayerTimeSettingsReference.CalculationMethod.rawValue)
    let asrJuristic: Int = UserDefaults.standard.integer(forKey: PrayerTimeSettingsReference.AsrJuristic.rawValue)
    let adjustHighLats: Int = UserDefaults.standard.integer(forKey: PrayerTimeSettingsReference.AdjustHighLats.rawValue)
    let timeFormat: Int = UserDefaults.standard.integer(forKey: PrayerTimeSettingsReference.TimeFormat.rawValue)
    
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
    var alarm: Timer { get set }
    var savedAlarmDate: Date? { get set }
    var localNotifications: [UILocalNotification] { get set }
    var attributedTitle: NSMutableAttributedString { get }
    
    static var DocumentsDirectory: URL { get }
    static var ArchiveURL: URL { get }
    
    func timeToAlarm(_ withPrayerTimes: [String : String]?) -> Date
}

extension AlarmClockType {
    var attributedSubtitle: NSMutableAttributedString {
        let label = self.alarmLabel
        let alarmSubtitle: String
        let alarmSubtitleAttributedString: NSMutableAttributedString
        alarmSubtitle = label
        let rangeOfAlarmLabel = (alarmSubtitle as NSString).range(of: label)
        alarmSubtitleAttributedString = NSMutableAttributedString(string: alarmSubtitle)
        alarmSubtitleAttributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Medium", size: 15)!, range: rangeOfAlarmLabel)

        return alarmSubtitleAttributedString
    }
    
    mutating func startAlarm(_ target: AnyObject, selector: Selector, date: Date, userInfo: Any?) {
        alarm.invalidate()
        stopAlarm()
        alarm = Timer.scheduledTimer(timeInterval: date.timeIntervalSinceNow, target: target, selector: selector, userInfo: userInfo, repeats: false)
        RunLoop.current.add(alarm, forMode: RunLoopMode.defaultRunLoopMode)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm a"
        let dateString = dateFormatter.string(from: date)
        print("NSTimer scheduled for: \(dateString)")
    }
    
    mutating func stopAlarm() {
        if alarm.isValid {
            alarm.invalidate()
            print("NSTimer Invalidated")
        }
    }
    
    mutating func scheduleLocalNotification(noSound: Bool? = false) {
        let settings = UserDefaults.standard
        let lon = settings.double(forKey: "longitude")
        let lat = settings.double(forKey: "latitude")
        let gmt = settings.double(forKey: "gmt")
        let userPrayerTime = UserSettingsPrayertimes()
        var prayerTimes: [String : String]
        var dateToAlarm: Date
        
        localNotifications = []
        
        for i in 0 ..< 4 {
            if self.alarmType == .fajrWakeAlarm {
                prayerTimes = userPrayerTime.getUserSettings().getPrayerTimes(Calendar.current, date: Date().addingTimeInterval((60 * 60 * 24) * Double(i)), latitude: lat, longitude: lon, tZone: gmt)
                dateToAlarm = self.timeToAlarm(prayerTimes).addingTimeInterval((60 * 60 * 24) * Double(i))
            } else {
                dateToAlarm = self.timeToAlarm(nil).addingTimeInterval((60 * 60 * 24) * Double(i))
            }
            for n in 1 ..< 4 {
                localNotifications.append(getLocalNotification(dateToAlarm.addingTimeInterval(30*Double(n)), noSound: noSound))
            }
            localNotifications.append(getLocalNotification(dateToAlarm, noSound: noSound))
        }
        
        // schedule local notifications
        if let systemNotifications = UIApplication.shared.scheduledLocalNotifications {
            UIApplication.shared.scheduledLocalNotifications = systemNotifications + localNotifications
        }
        
        for notification in localNotifications {
            if let date = notification.fireDate {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM-dd-yyyy HH:mm a"
                let dateString = dateFormatter.string(from: date)
                print("Set Notifications: \(dateString)")
            }
        }
        print("--------------------------------------------------------")
    }
    
    func getLocalNotification(_ date: Date, noSound: Bool? = false) -> UILocalNotification {
        let localNotification = UILocalNotification()
        localNotification.fireDate = date
        localNotification.alertBody = "\(self.attributedTitle.string)\n\"\(self.alarmLabel)\" - (Open the app to stop)"
        if self.sound.alarmSound.URL != nil {
            if noSound == false {
                localNotification.soundName = sound.alarmSound.pathForLocalNotification
            } else {
                localNotification.soundName = nil
            }
        }
        return localNotification
    }
    
    func deleteLocalNotifications() {
        if localNotifications.count > 0 {
            for notification in localNotifications {
                UIApplication.shared.cancelLocalNotification(notification)
            }
            print("notifications canceled successfully")
        }
    }
}

class CustomAlarm: NSObject, AlarmClockType, NSCoding {
    var alarmLabel: String
    var sound: AlarmSound
    var snooze: Bool
    var time: Date
    var alarmType: AlarmType
    var alarmOn: Bool
    var alarm: Timer = Timer()
    var savedAlarmDate: Date?
    var localNotifications: [UILocalNotification] = []
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("customAlarmAlarms")
    
    init(alarmLabel: String, sound: AlarmSound, snooze: Bool, time: Date, alarmType: AlarmType, alarmOn: Bool, savedAlarmDate: Date? = nil) {
        self.alarmLabel = alarmLabel
        self.sound = sound
        self.snooze = snooze
        self.time = time
        self.alarmType = alarmType
        self.alarmOn = alarmOn
        self.savedAlarmDate = savedAlarmDate
        
        super.init()
    }

    func timeToAlarm(_ withPrayerTimes: [String : String]?) -> Date {
        let currentDate = Date()
        let calendar = Calendar.current
        let currentDateComponents = (calendar as NSCalendar).components([.month, .year, .day], from: currentDate)
        let pickerTimeComponents = (calendar as NSCalendar).components([.hour, .minute], from: time)
        var timeToAlarmComponents = DateComponents()
        
        timeToAlarmComponents.year = currentDateComponents.year
        timeToAlarmComponents.month = currentDateComponents.month
        timeToAlarmComponents.day = currentDateComponents.day
        timeToAlarmComponents.hour = pickerTimeComponents.hour
        timeToAlarmComponents.minute = pickerTimeComponents.minute
        timeToAlarmComponents.second = 0
        
        var timeToAlarm = calendar.date(from: timeToAlarmComponents)!
        
        if timeToAlarm.timeIntervalSinceNow < 0 {
            timeToAlarm = timeToAlarm.addingTimeInterval(60 * 60 * 24)
        }
        
        if let savedAlarm = self.savedAlarmDate {
            if savedAlarm.timeIntervalSinceNow == 0 || savedAlarm.timeIntervalSinceNow > 0 {
                timeToAlarm = savedAlarm
            }
        }
        
        self.savedAlarmDate = timeToAlarm

        return timeToAlarm
    }
    
    var timeToString: String {
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "h:mm a"
        let stringFromDate = outputFormatter.string(from: time)
        return stringFromDate
    }
    
    var attributedTitle: NSMutableAttributedString {
        let alarmAttributedTitle = NSMutableAttributedString(string: timeToString)
        let amOrPm: String
        if timeToString.range(of: "AM") != nil {
            amOrPm = "AM"
        } else {
            amOrPm = "PM"
        }
        let amPMRange = (timeToString as NSString).range(of: " \(amOrPm)")
        let alarmTimeRange: NSRange = NSMakeRange(0, amPMRange.location)
        alarmAttributedTitle.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Light", size: 25)!, range: alarmTimeRange)
        alarmAttributedTitle.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Light", size: 10)!, range: amPMRange)
        return alarmAttributedTitle
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(alarmLabel, forKey: CustomAlarmPropertyKey.alarmLabelKey)
        aCoder.encode(sound.alarmSound.rawValue, forKey: CustomAlarmPropertyKey.alarmSoundKey)
        aCoder.encode(sound.alarmSectionTitle.rawValue, forKey: CustomAlarmPropertyKey.alarmSoundSectionKey)
        aCoder.encode(snooze, forKey: CustomAlarmPropertyKey.snoozeKey)
        aCoder.encode(time, forKey: CustomAlarmPropertyKey.timeKey)
        aCoder.encode(alarmType.rawValue, forKey: CustomAlarmPropertyKey.alarmTypeKey)
        aCoder.encode(alarmOn, forKey: CustomAlarmPropertyKey.alarmOnKey)
        aCoder.encode(savedAlarmDate, forKey: CustomAlarmPropertyKey.savedAlarmDateKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let alarmLabel = aDecoder.decodeObject(forKey: CustomAlarmPropertyKey.alarmLabelKey) as! String
        let alarmSound = aDecoder.decodeObject(forKey: CustomAlarmPropertyKey.alarmSoundKey) as! String
        let alarmSoundSection = aDecoder.decodeObject(forKey: CustomAlarmPropertyKey.alarmSoundSectionKey) as! String
        let sound = AlarmSound(alarmSound: AlarmSounds(rawValue: alarmSound)!, alarmSectionTitle: AlarmSoundsSectionTitles(rawValue: alarmSoundSection)!)
        let snooze = aDecoder.decodeBool(forKey: CustomAlarmPropertyKey.snoozeKey)
        let time = aDecoder.decodeObject(forKey: CustomAlarmPropertyKey.timeKey) as! Date
        let alarmType = AlarmType(rawValue: aDecoder.decodeInteger(forKey: CustomAlarmPropertyKey.alarmTypeKey))!
        let alarmOn = aDecoder.decodeBool(forKey: CustomAlarmPropertyKey.alarmOnKey)
        let savedAlarmDate = aDecoder.decodeObject(forKey: CustomAlarmPropertyKey.savedAlarmDateKey) as? Date
        
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
    var alarm: Timer = Timer()
    var savedAlarmDate: Date?
    var localNotifications: [UILocalNotification] = []
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("fajrWakeAlarms")
    
    init(alarmLabel: String, sound: AlarmSound, snooze: Bool, minsToAdjust: Int, whenToWake: WakeOptions, whatSalatToWake: SalatsAndQadhas, alarmType: AlarmType, alarmOn: Bool, dateTesting: Date? = nil) {
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

    func timeToAlarm(_ withPrayerTimes: [String : String]?) -> Date {
        let settings = UserDefaults.standard
        let lon = settings.double(forKey: "longitude")
        let lat = settings.double(forKey: "latitude")
        let gmt = settings.double(forKey: "gmt")
        let userPrayerTime = UserSettingsPrayertimes()
        var prayerTimes: [String : String]
        
        if let pTimes = withPrayerTimes {
            prayerTimes = pTimes
        } else {
            prayerTimes = userPrayerTime.getUserSettings().getPrayerTimes(Calendar.current, date: Date(), latitude: lat, longitude: lon, tZone: gmt)
        }
        
        var timeToAlarm = initialAlarmTime(prayerTimes)

        if timeToAlarm.timeIntervalSinceNow < 0 {
            // based on next day's prayer times
            prayerTimes = userPrayerTime.getUserSettings().getPrayerTimes(Calendar.current, date: Date().addingTimeInterval(60 * 60 * 24), latitude: lat, longitude: lon, tZone: gmt)
            timeToAlarm = initialAlarmTime(prayerTimes).addingTimeInterval(60 * 60 * 24)
        }
        
        if let savedAlarm = self.savedAlarmDate {
            if savedAlarm.timeIntervalSinceNow == 0 || savedAlarm.timeIntervalSinceNow > 0 {
                timeToAlarm = savedAlarm
            }
        }
        
        self.savedAlarmDate = timeToAlarm
        
        return timeToAlarm
    }
    
    func initialAlarmTime(_ prayerTimes: [String : String]) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        let salatOrQadhaTime = dateFormatter.date(from: prayerTimes[whatSalatToWake.getString]!)
        
        let calendar = Calendar.current
        var adjustedTime: Date?
        
        if whenToWake == .onTime {
            adjustedTime = salatOrQadhaTime
        } else if whenToWake == .before {
            adjustedTime = (calendar as NSCalendar).date(byAdding: .minute, value: -minsToAdjust, to: salatOrQadhaTime!, options: [])
        } else if whenToWake == .after {
            adjustedTime = (calendar as NSCalendar).date(byAdding: .minute, value: minsToAdjust, to: salatOrQadhaTime!, options: [])
        }
        
        let currentDate = Date()
        let currentDateComponents = (calendar as NSCalendar).components([.month, .year, .day], from: currentDate)
        let adjustedTimeComponents = (calendar as NSCalendar).components([.hour, .minute], from: adjustedTime!)
        var timeToAlarmComponents = DateComponents()
        timeToAlarmComponents.year = currentDateComponents.year
        timeToAlarmComponents.month = currentDateComponents.month
        timeToAlarmComponents.day = currentDateComponents.day
        timeToAlarmComponents.hour = adjustedTimeComponents.hour
        timeToAlarmComponents.minute = adjustedTimeComponents.minute
        timeToAlarmComponents.second = 0
        
        return calendar.date(from: timeToAlarmComponents)!
    }
    
    var title: String {
        if whenToWake == .onTime {
            return "\(whatSalatToWake.getString.capitalized)"
        } else {
            return "\(minsToAdjust) MIN \(whenToWake.getString) \(whatSalatToWake.getString.capitalized)"
        }
    }
    
    var attributedTitle: NSMutableAttributedString {
        let alarmAttributedTitle = NSMutableAttributedString(string: title)
        let rangeOfMinutesToAdjust = (title as NSString).range(of: String(minsToAdjust))
        let rangeOfMinText = (title as NSString).range(of: " MIN")
        var rangeOfRestOfText: NSRange
        if whenToWake == .onTime {
            rangeOfRestOfText = (title as NSString).range(of: "\(whatSalatToWake.getString.capitalized)")
        } else {
            rangeOfRestOfText = (title as NSString).range(of: "\(whenToWake.getString) \(whatSalatToWake.getString.capitalized)")
        }
        
        alarmAttributedTitle.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Light", size: 10)!, range: rangeOfMinText)
        alarmAttributedTitle.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Light", size: 25)!, range: rangeOfMinutesToAdjust)
        alarmAttributedTitle.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Light", size: 25)!, range: rangeOfRestOfText)
        
        return alarmAttributedTitle
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(alarmLabel, forKey: FajrAlarmPropetKey.alarmLabelKey)
        aCoder.encode(sound.alarmSound.rawValue, forKey: FajrAlarmPropetKey.alarmSoundKey)
        aCoder.encode(sound.alarmSectionTitle.rawValue, forKey: FajrAlarmPropetKey.alarmSoundSectionKey)
        aCoder.encode(snooze, forKey: FajrAlarmPropetKey.snoozeKey)
        aCoder.encode(alarmType.rawValue, forKey: FajrAlarmPropetKey.alarmTypeKey)
        aCoder.encode(minsToAdjust, forKey: FajrAlarmPropetKey.minsToAdjustKey)
        aCoder.encode(whenToWake.rawValue, forKey: FajrAlarmPropetKey.whenToWakeKey)
        aCoder.encode(whatSalatToWake.rawValue, forKey: FajrAlarmPropetKey.whatSalatToWakeKey)
        aCoder.encode(alarmOn, forKey: FajrAlarmPropetKey.alarmOnKey)
        aCoder.encode(savedAlarmDate, forKey: FajrAlarmPropetKey.savedAlarmDateKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let alarmLabel = aDecoder.decodeObject(forKey: FajrAlarmPropetKey.alarmLabelKey) as! String
        let alarmSound = aDecoder.decodeObject(forKey: FajrAlarmPropetKey.alarmSoundKey) as! String
        let alarmSoundSection = aDecoder.decodeObject(forKey: FajrAlarmPropetKey.alarmSoundSectionKey) as! String
        let sound = AlarmSound(alarmSound: AlarmSounds(rawValue: alarmSound)!, alarmSectionTitle: AlarmSoundsSectionTitles(rawValue: alarmSoundSection)!)
        let snooze = aDecoder.decodeBool(forKey: FajrAlarmPropetKey.snoozeKey)
        let alarmType = AlarmType(rawValue: aDecoder.decodeInteger(forKey: FajrAlarmPropetKey.alarmTypeKey))!
        let alarmOn = aDecoder.decodeBool(forKey: FajrAlarmPropetKey.alarmOnKey)
        let minsToAdjust = aDecoder.decodeInteger(forKey: FajrAlarmPropetKey.minsToAdjustKey)
        let whenToWake: WakeOptions = WakeOptions(rawValue: aDecoder.decodeInteger(forKey: FajrAlarmPropetKey.whenToWakeKey))!
        let whatSalatToWake: SalatsAndQadhas = SalatsAndQadhas(rawValue: aDecoder.decodeInteger(forKey: FajrAlarmPropetKey.whatSalatToWakeKey))!
        let savedAlarmDate = aDecoder.decodeObject(forKey: FajrAlarmPropetKey.savedAlarmDateKey) as? Date
        
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


















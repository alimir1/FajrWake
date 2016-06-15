//
//  FajrWake.swift
//  Fajr Wake
//
//  Created by Abidi on 5/13/16.
//  Copyright © 2016 FajrWake. All rights reserved.
//

import Foundation

// MARK: - Protocols

protocol PrayerAlarmType {
    var whenToAlarm: WakeOptions { get set }
    var minsToAdjust: Int { get set }
    var alarmLabel: String { get set }
    var finalPrayTimes: [SalatsAndQadhas : String] { get }
    
    func setDaysToRepeat(days: [Days]) -> [Days]
    func setLabel()
    func alarmOnOff(alarmOn: Bool)
}

// MARK: - Error Types


// MARK: - Helper Methods

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

//class PrayTimes {
//    class func getPrayerTimesString(userSettings: Settings) -> [SalatsAndQadhas : String] {
//        let myPrayerTimes = PrayerTimes(caculationmethod: userSettings.calculationMethod, asrJuristic: userSettings.asrJuristic, adjustHighLats: userSettings.adjustHighLats, timeFormat: userSettings.timeFormat)
//        let prayerTimes = myPrayerTimes.getPrayerTimes(NSCalendar.currentCalendar(), latitude: userSettings.latitude, longitude: userSettings.longitude, tZone: userSettings.localGMT())
//        let finalPrayTimes = [SalatsAndQadhas.Fajr : prayerTimes.sort()[0], SalatsAndQadhas.Sunrise : prayerTimes.sort()[1]]
//        
//        return finalPrayTimes
//    }
//    class func getPrayerTimesInt(userSettings: Settings) -> [SalatsAndQadhas : [Int]] {
//        let myPrayerTimes = PrayerTimes(caculationmethod: userSettings.calculationMethod, asrJuristic: userSettings.asrJuristic, adjustHighLats: userSettings.adjustHighLats, timeFormat: userSettings.timeFormat)
//        let prayerTimes = myPrayerTimes.getPrayerTimes(NSCalendar.currentCalendar(), latitude: userSettings.latitude, longitude: userSettings.longitude, tZone: userSettings.localGMT())
//        let finalPrayTimes = [SalatsAndQadhas.Fajr : prayerTimes.sort()[0], SalatsAndQadhas.Sunrise : prayerTimes.sort()[1]]
//        
//        // For Fajr
//        let fajrTime = finalPrayTimes[SalatsAndQadhas.Fajr]
//        let componentsFajrTime = fajrTime!.characters.split { $0 == ":" } .map {
//            (x) -> Int in return Int(String(x))!
//        }
//        let fajrTimeInt = [componentsFajrTime[0], componentsFajrTime[1]]
//        
//        // For Sunrise
//        let sunriseTime = finalPrayTimes[SalatsAndQadhas.Sunrise]
//        let componentsSunriseTime = sunriseTime!.characters.split { $0 == ":" } .map {
//            (x) -> Int in return Int(String(x))!
//        }
//        let sunriseTimeInt = [componentsSunriseTime[0], componentsSunriseTime[1]]
//        
//        let finalPrayTimesInt = [SalatsAndQadhas.Fajr : fajrTimeInt, SalatsAndQadhas.Sunrise : sunriseTimeInt]
//        
//        return finalPrayTimesInt
//    }
//}

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
            daysForLabel += "\(days[0].rawValue)"
            return daysForLabel
        }
        
        // storing enum raw values in array to check if array contains (for array.contains method)
        for day in days {
            daysInString.append(day.rawValue)
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
            let str = day.rawValue
            daysForLabel += str[str.startIndex.advancedBy(0)...str.startIndex.advancedBy(2)] + " "
        }
        
        return daysForLabel
    }
}

// MARK: - Concrete Types

enum Months: Int {
    case January
    case February
    case March
    case April
    case May
    case June
    case July
    case August
    case September
    case October
    case November
    case December
}

//enum SalatsAndQadhas: String {
//    case Fajr
//    case Sunrise
//    case Dhuhr
//    case Asr
//    case Sunset
//    case Maghrib
//    case Isha
//}

enum SalatsAndQadhas: Int {
    case Fajr
    case Sunrise
    case Dhuhr
    case Asr
    case Sunset
    case Maghrib
    case Isha
    
    var getString: String {
        switch self {
        case Fajr: return "Fajr"
        case Sunrise: return "Sunrise"
        case Dhuhr: return "Dhuhr"
        case Asr: return "Asr"
        case Sunset: return "Sunset"
        case Maghrib: return "Maghrib"
        case Isha: return "Isha"
        }
    }
}

enum WakeOptions: String {
    case AtFajr = "At Fajr"
    case BeforeFajr = "Before Fajr"
    case BeforeSunrise = "Before Sunrise"
}

enum Days: String  {
    case Monday
    case Tuesday
    case Wednesday
    case Thursday
    case Friday
    case Saturday
    case Sunday
}

struct Settings {
    var calculationMethod: PrayerTimes.CalculationMethods = .Jafari
    var asrJuristic: PrayerTimes.AsrJuristicMethods = .Shafii
    var adjustHighLats: PrayerTimes.AdjustingMethods = .None
    var timeFormat: PrayerTimes.TimeForamts = .Time24
    var todayDate = NSCalendar.currentCalendar()
    var localGMT = LocalGMT.getLocalGMT
    var latitude: Double
    var longitude: Double
    
    init (latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

class FajrWake {
    var whenToAlarm: WakeOptions
    var minsToChange: Int
    var daysToRepeat: [Days]
    var snooze: Bool
    var alarmOn: Bool
    var alarmLabel: String
    var daysToRepeatLabel: String
    
    init(whenToAlarm: WakeOptions = .AtFajr, minsToChange: Int = 0, daysToRepeat: [Days] = [.Monday, .Tuesday, .Wednesday, .Thursday, .Friday, .Saturday, .Sunday], snooze: Bool = true, alarmOn: Bool = true, alarmLabelLabel: String = "Alarm") {
        self.whenToAlarm = whenToAlarm
        self.minsToChange = minsToChange
        self.daysToRepeat = daysToRepeat
        self.snooze = snooze
        self.alarmOn = alarmOn
        self.alarmLabel = alarmLabelLabel
        daysToRepeatLabel = DaysToRepeatLabel.getTextToRepeatDaysLabel(daysToRepeat)
    }
    func setAlarm() {
        
    }
}


struct UserSettingsPrayerOptions {
    static func getUserSettings() -> PrayerTimes {
        return PrayerTimes(caculationmethod: .Tehran, asrJuristic: .Shafii, adjustHighLats: .None, timeFormat: .Time12)
    }
//    let something = NSUserDefaults.standardUserDefaults().doubleForKey("works")

}








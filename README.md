# Fajr Wake

By: [Ali Mir](http://alimir.io)

Github: https://github.com/alimir1/FajrWake

___

Build information:

* Version: 1.0
* Xcode version: 8.0
* Swift: 3.0
* iPhone: 4s or later
* iPad: N/A

---

## Introduction

Islam requires that Muslims pray 5 times a day. These prayers (i.e. Salah) cannot be prayed just at any times. They are to be prayed on specific times. The following are the 5 obligatory daily prayers along with corresponding time that a Muslims can start the prayer:

* **Fajr**: When the sky begins to lighten (dawn).
* **Dhuhr**: When the Sun begins to decline after reaching its highest point in the sky.
* **Asr**: The time when the length of any object's shadow reaches a factor (usually 1 or 2) of the length of the object itself plus the length of that object's shadow at noon.
* **Maghreb**: Soon after sunset.
* **Isha**: The time at which darkness falls and there is no scattered light in the sky.

Fajr prayer begins at as per the above timing but it is permissible to pray anytime BEFORE sunrise. Dhuhr and Asr should to be prayed before sunset. Maghreb and Isha must be prayed before midnight. (**Note: I'm simplifiying prayer time rulings here for non-Muslims to better understand. There are different opinions amongst Islamic scholars!**).

You can learn more about Islamic prayer times on the following website: http://praytimes.org/wiki/Prayer_Times_Calculation

My main focus was to build an app that makes it easy for Muslims to wake up for Fajr time. The reason being that Muslims typically use an alarm clock to wake up for Fajr prayer.

There are many great Islamic prayer time alarm clock apps out there. This app is different in that:

1. It not only can alarm at Fajr time but also any time between Fajr and sunrise (which is important since many Muslims perfer to pray Fajr for example 20 mins before sunrise).
2. You can have multiple alarms around the Fajr and sunrise timing. Some Muslims wake up to pray [night prayers](https://www.al-islam.org/salatul-layl-h-t-kassamali/salatul-layl) some time before Fajr and then pray on Fajr on time.
3. Alarm sounds have more variety.
4. Alarm times are autmocally updated daily.
... and more

## Creation of the app

This is my first fully functional iPhone app that I created. Before creating this app, I was taking courses on [iOS Develompent with Swift]((https://teamtreehouse.com/tracks/ios-development-with-swift-20)) through [Treehouse](https://teamtreehouse.com/). As I was taking the Treehouse courses, this idea just came to my mind and thus Fajr Wake was created.
I acknowledge much of the code could have been written differently for more efficiency and that best practices were not always implemented. However, to my defence, this is the first darn app that I made OK! When I do have time I plan on making changes. 

## Acknowledgment

[This](prayertimes.org) website was very helpful to me on so many levels. I used [this repo](https://github.com/alhazmy13/PrayerTimesSwift) for calculating prayer times.

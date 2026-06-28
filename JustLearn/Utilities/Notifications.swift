//
//  Notifications.swift
//  JustLearn
//
//  Created by Illya Donchenko on 14.06.2026.
//

import Foundation
import UserNotifications


func requestPermission() {
    UNUserNotificationCenter.current().requestAuthorization(
        options: [.alert, .sound, .badge])
    {granted, error in
        if granted{
            print("Allowed")
        }else{
            print("Not Allowed")
        }
    }
}



func scheduleNotification(at date:Date){
    let center = UNUserNotificationCenter.current()
    center.removePendingNotificationRequests(withIdentifiers: ["dailyReminder"])
    
    let content = UNMutableNotificationContent()
    content.title = "JustLearn"
    content.body = "Don't forget to practice your vocabulary!"
    content.sound = .default
    
    let comps = Calendar.current.dateComponents([.hour, .minute], from: date)
    let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: true)
    
    
    let request = UNNotificationRequest(
        identifier: "dailyReminer",
        content: content,
        trigger: trigger
    )
    center.add(request){error in
        if let error{print(error)}
    }
    
    
    
    
}

func cancelNotification(){
    UNUserNotificationCenter.current()
        .removePendingNotificationRequests(withIdentifiers: ["dailyReminder"])
}

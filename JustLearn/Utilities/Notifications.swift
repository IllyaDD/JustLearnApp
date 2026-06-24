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



func scheduleNotification(){
    let content = UNMutableNotificationContent()
    content.title = "Reminder"
    content.body = "Right time to learn some words ;)"
    
    var dateComponents = DateComponents()
    dateComponents.hour = 23
    dateComponents.minute = 23
    
    
    let trigger = UNCalendarNotificationTrigger(
        dateMatching: dateComponents,
        repeats: true
    )
    
    let request = UNNotificationRequest(
        identifier: "hello",
        content: content,
        trigger: trigger
    )
    
    UNUserNotificationCenter.current().add(request){error in
        if let error{
            print(error)
        }
    }
}

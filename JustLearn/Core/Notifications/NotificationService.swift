//
//  NotificationService.swift
//  JustLearn/Services
//

import Foundation
import UserNotifications

final class NotificationService {
    private let dailyReminderID = "dailyReminder"

    func requestPermission() async -> Bool {
        let granted = try? await UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge])
        return granted ?? false
    }

    func scheduleDailyReminder(at date: Date) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [dailyReminderID])

        let content = UNMutableNotificationContent()
        content.title = "JustLearn"
        content.body = "Don't forget to practice your vocabulary!"
        content.sound = .default

        let comps = Calendar.current.dateComponents([.hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: true)

        let request = UNNotificationRequest(
            identifier: dailyReminderID,
            content: content,
            trigger: trigger
        )
        center.add(request) { error in
            if let error { print(error) }
        }
    }

    func cancelDailyReminder() {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: [dailyReminderID])
    }
}

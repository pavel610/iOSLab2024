//
//  NotificationFactory.swift
//  HW_2.3
//
//  Created by Павел Калинин on 11.06.2025.
//
import UserNotifications

final class NotificationFactory {
    func makeNotification(from reminder: Reminder) -> UNNotificationRequest {
        let content = UNMutableNotificationContent()
        content.title = reminder.title
        content.body = reminder.type.rawValue
        content.sound = .default
        content.userInfo = ["screenLink": "healthreminder://openScreen?screen=detail&id=\(reminder.id)"]

        let trigger: UNNotificationTrigger
        
        switch reminder.repeatMode {
        case .once:
            let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: reminder.date)
            trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            
        case .interval:
            let interval = TimeInterval((reminder.intervalMinutes ?? 5) * 60)
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: true)
        }
        
        return UNNotificationRequest(
            identifier: reminder.id.uuidString,
            content: content,
            trigger: trigger
        )
    }
}

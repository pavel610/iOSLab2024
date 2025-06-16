//
//  ReminderBuilder.swift
//  HW_2.3
//
//  Created by Павел Калинин on 11.06.2025.
//
import Foundation

final class ReminderBuilder {
    private var id = UUID()
    private var title: String = ""
    private var date: Date = Date()
    private var type: ReminderType = .other
    private var repeatMode: RepeatMode = .once
    private var intervalMinutes: Int? = nil

    func setId(_ id: UUID) -> Self {
        self.id = id
        return self
    }

    func setTitle(_ title: String) -> Self {
        self.title = title
        return self
    }

    func setDate(_ date: Date) -> Self {
        self.date = date
        return self
    }

    func setType(_ type: ReminderType) -> Self {
        self.type = type
        return self
    }

    func setRepeatMode(_ mode: RepeatMode) -> Self {
        self.repeatMode = mode
        return self
    }

    func setIntervalMinutes(_ minutes: Int?) -> Self {
        self.intervalMinutes = minutes
        return self
    }
 
    func build() -> Reminder {
        Reminder(id: id,
                 title: title,
                 date: date,
                 type: type,
                 repeatMode: repeatMode,
                 intervalMinutes: intervalMinutes)
    }
}

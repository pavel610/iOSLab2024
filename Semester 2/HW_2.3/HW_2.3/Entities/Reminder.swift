//
//  Reminder.swift
//  HW_2.3
//
//  Created by Павел Калинин on 11.06.2025.
//
import Foundation

struct Reminder: Identifiable {
    let id: UUID
    let title: String
    let date: Date
    let type: ReminderType
    let repeatMode: RepeatMode
    let intervalMinutes: Int?
}

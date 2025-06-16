//
//  AddReminderView.swift
//  HW_2.3
//
//  Created by Павел Калинин on 11.06.2025.
//

import SwiftUI

struct AddReminderView: View {
    @Environment(\.dismiss) var dismiss
    @State private var title: String = ""
    @State private var date: Date = Date()
    @State private var selectedType: ReminderType = .water
    @State private var repeatMode: RepeatMode = .once
    @State private var intervalMinutes: Int = 5

    let notificationService: NotificationServiceProtocol
    let reminderService: ReminderServiceProtocol
    
    init(notificationService: NotificationServiceProtocol = ServiceLocator.shared.notificationService,
         reminderService: ReminderServiceProtocol = ServiceLocator.shared.remindersService) {
        self.notificationService = notificationService
        self.reminderService = reminderService
    }

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                Form {
                    Section {
                        TextField("Название", text: $title)
                        Picker("Повтор", selection: $repeatMode) {
                            ForEach(RepeatMode.allCases, id: \.self) {
                                Text($0.rawValue)
                            }
                        }

                        if repeatMode == .once {
                            DatePicker("Когда", selection: $date)
                        } else {
                            Stepper(value: $intervalMinutes, in: 5...60, step: 5) {
                                Text("Интервал: \(intervalMinutes) мин")
                            }

                        }

                        Picker("Тип", selection: $selectedType) {
                            ForEach(ReminderType.allCases, id: \.self) {
                                Text($0.rawValue)
                            }
                        }
                    }
                }
                .navigationTitle("Новое напоминание")
                
                VStack {
                    Button(action: saveReminder) {
                        Text("Сохранить")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                    .padding(.bottom)
                }
            }
        }
    }
    
    private func saveReminder() {
        let reminder = ReminderBuilder()
            .setTitle(title)
            .setDate(date)
            .setType(selectedType)
            .setRepeatMode(repeatMode)
            .setIntervalMinutes(repeatMode == .interval ? intervalMinutes : nil)
            .build()
        reminderService.add(reminder)
        
        notificationService.requestAuthorizationIfNeeded()
        let request = NotificationFactory().makeNotification(from: reminder)
        notificationService.scheduleNotification(request)
        
        dismiss()
    }
}

#Preview {
    AddReminderView()
}

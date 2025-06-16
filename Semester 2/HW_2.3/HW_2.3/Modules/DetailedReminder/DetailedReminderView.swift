//
//  DetailedReminderView.swift
//  HW_2.3
//
//  Created by Павел Калинин on 11.06.2025.
//

import SwiftUI

struct DetailedReminderView: View {
    var reminder: Reminder

    var body: some View {
        VStack(spacing: 16) {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(reminder.title)
                        .font(.title)
                        .bold()

                    Text(reminder.type.rawValue)
                        .font(.callout)
                        .foregroundStyle(.gray)
                }

                Spacer()

                if reminder.repeatMode == .once {
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(reminder.date.formatted(date: .omitted, time: .shortened))
                            .bold()
                        Text(reminder.date.formatted(date: .numeric, time: .omitted))
                            .foregroundStyle(.gray)
                    }
                } else if let interval = reminder.intervalMinutes {
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Каждые \(interval) мин")
                            .bold()
                        Text("Повтор")
                            .foregroundStyle(.gray)
                    }
                }
            }

            Spacer()
        }
        .padding()
    }
}

#Preview {
    DetailedReminderView(reminder: Reminder(id: UUID(), title: "Иди пей", date: Date(), type: .water, repeatMode: .once, intervalMinutes: nil))
}

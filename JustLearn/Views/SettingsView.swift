//
//  SettingsView.swift
//  JustLearn
//
//  Created by Illya Donchenko on 26.06.2026.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("appTheme") private var themeRaw: String = appTheme.system.rawValue
    @AppStorage("appIcon") private var currentIconSelection: CustomAppIcon = .DefaultIcon
    @AppStorage("notificationsEnabled") private var notificationsEnabled: Bool = false
    @AppStorage("notificationTime") private var notificationTimeRaw: Double =
        Calendar.current.date(bySettingHour: 19, minute: 0, second: 0, of: Date())?
            .timeIntervalSince1970 ?? 0
    @AppStorage("practiseDirection") private var practiseDirection: learningDestination = .TranslateToOriginal
    
    private var notificationTime: Binding<Date> {
        Binding(
            get: { Date(timeIntervalSince1970: notificationTimeRaw) },
            set: { notificationTimeRaw = $0.timeIntervalSince1970 }
        )
    }
    
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("App theme", selection: $themeRaw) {
                        ForEach(appTheme.allCases) { theme in
                            Image(systemName: theme.iconName).tag(theme.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text("App Theme")
                        .font(.title3.weight(.bold))
                        .foregroundStyle(.black)
                        .textCase(nil)
                        .padding(.vertical, 4)
                }
                Section {
                    Picker("", selection: $currentIconSelection){
                        ForEach(CustomAppIcon.allCases, id: \.rawValue){icon in
                            Text(icon.displayName)
                                .tag(icon)  

                        }
                    }
                } header: {
                    Text("App Icon")
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(.black)
                        .textCase(nil)
                        .padding(.vertical, 4)
                }
                .pickerStyle(.segmented)
                .onChange(of: currentIconSelection) { oldValue, newValue in
                    UIApplication.shared.setAlternateIconName(newValue.bundleValue)
                }
                Section {
                    Picker("", selection: $practiseDirection) {
                        ForEach(learningDestination.allCases) { direction in
                            Text(direction.displayName).tag(direction)
                        }
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text("Practice direction")
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(.black)
                        .textCase(nil)
                        .padding(.vertical, 4)
                }


                Section {
                    Toggle("Daily reminder", isOn: $notificationsEnabled)
                    if notificationsEnabled {
                        DatePicker(
                            "Time",
                            selection: notificationTime,
                            displayedComponents: .hourAndMinute
                        )
                    }
                } header: {
                    Text("Notifications")
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(.black)
                        .textCase(nil)
                        .padding(.vertical, 4)
                }
                .onChange(of: notificationsEnabled) { _, isOn in
                    if isOn {
                        requestPermission()
                        scheduleNotification(at: notificationTime.wrappedValue)
                    } else {
                        cancelNotification()
                    }
                }
                .onChange(of: notificationTimeRaw) { _, _ in
                    guard notificationsEnabled else { return }
                    scheduleNotification(at: notificationTime.wrappedValue)
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color(.systemBackground))
            .padding()
            .navigationTitle(Text("Settings"))
        }
        
    }
}

#Preview {
    SettingsView()
}

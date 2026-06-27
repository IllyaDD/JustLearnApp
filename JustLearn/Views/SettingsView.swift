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

//
//  SettingsView.swift
//  JustLearn
//
//  Created by Illya Donchenko on 26.06.2026.
//

import SwiftUI
import SwiftData

struct SettingsView: View {

    @Environment(\.colorScheme) private var scheme
    @Query private var words:[Word]
    @Query(sort: \Tag.createdAt) private var allTags: [Tag]
    @State private var viewModel: SettingsViewModel

    @AppStorage("appTheme") private var themeRaw: String = appTheme.system.rawValue
    @AppStorage("appIcon") private var currentIconSelection: CustomAppIcon = .DefaultIcon
    @AppStorage("notificationsEnabled") private var notificationsEnabled: Bool = false
    @AppStorage("notificationTime") private var notificationTimeRaw: Double =
        Calendar.current.date(bySettingHour: 19, minute: 0, second: 0, of: Date())?
            .timeIntervalSince1970 ?? 0
    @AppStorage("practiseDirection") private var practiseDirection: learningDestination = .TranslateToOriginal

    init(wordService: WordService) {
        _viewModel = State(initialValue: SettingsViewModel(wordService: wordService))
    }

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
                    NavigationLink {
                        TagsManagementView()
                    } label: {
                        Label("Manage tags", systemImage: "tag")
                    }
                } header: {
                    Text("Tags")
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(.primary)
                        .textCase(nil)
                        .padding(.vertical, 4)
                }
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
                        .foregroundStyle(.primary)
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
                        .foregroundStyle(.primary)
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
                        .foregroundStyle(.primary)
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
                        .foregroundStyle(.primary)
                        .textCase(nil)
                        .padding(.vertical, 4)
                }
                .onChange(of: notificationsEnabled) { _, isOn in
                    viewModel.notificationsToggled(isOn: isOn, time: notificationTime.wrappedValue)
                }
                .onChange(of: notificationTimeRaw) { _, _ in
                    viewModel.notificationTimeChanged(
                        to: notificationTime.wrappedValue,
                        notificationsEnabled: notificationsEnabled
                    )
                }
                Section{
                    Button(role: .destructive){
                        viewModel.showResetTagPicker = true
                    }label: {
                        Text("Reset progress by tag")
                    }
                }header: {
                    Text("Progress")
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(.primary)
                        .textCase(nil)
                        .padding(.vertical, 4)

            }
        }
            .scrollContentBackground(.hidden)
            .background(Color(.systemBackground))
            .padding()
            .navigationTitle(Text("Settings"))
            .sheet(isPresented: $viewModel.showResetTagPicker) {
                resetTagPickerSheet
            }
        }
    }

    private var resetTagPickerSheet: some View {
        NavigationStack {
            Group {
                if allTags.isEmpty {
                    ContentUnavailableView(
                        "No tags yet",
                        systemImage: "tag",
                        description: Text("Create tags in Settings → Tags")
                    )
                } else {
                    List {
                        ForEach(allTags) { tag in
                            Button {
                                viewModel.tagPendingReset = tag
                            } label: {
                                HStack(spacing: 12) {
                                    Circle()
                                        .fill(tag.color.color)
                                        .frame(width: 12, height: 12)
                                    Text(tag.name)
                                        .foregroundStyle(.primary)
                                    Spacer()
                                    Text("\(viewModel.wordCount(for: tag, in: words))")
                                        .foregroundStyle(.secondary)
                                }
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .navigationTitle("Reset by tag")
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { viewModel.showResetTagPicker = false }
                }
            }
            .confirmationDialog(
                viewModel.tagPendingReset.map { "Reset progress for words tagged \"\($0.name)\"?" } ?? "",
                isPresented: Binding(
                    get: { viewModel.tagPendingReset != nil },
                    set: { if !$0 { viewModel.tagPendingReset = nil } }
                ),
                titleVisibility: .visible
            ) {
                Button("Reset", role: .destructive) {
                    viewModel.confirmPendingReset(in: words)
                }
                Button("Cancel", role: .cancel) { viewModel.tagPendingReset = nil }
            }
        }
    }
}

#Preview {  
    let container = try! ModelContainer(
        for: Word.self, Tag.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    SettingsView(wordService: WordService(modelContext: container.mainContext))
        .modelContainer(container)
}

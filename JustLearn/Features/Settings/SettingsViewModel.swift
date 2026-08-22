//
//  SettingsViewModel.swift
//  JustLearn/ViewModels
//

import Foundation

@MainActor
@Observable
final class SettingsViewModel {
    var showResetTagPicker: Bool = false
    var tagPendingReset: Tag?

    private let wordService: WordService
    private let notificationService: NotificationService

    init(wordService: WordService, notificationService: NotificationService? = nil) {
        self.wordService = wordService
        self.notificationService = notificationService ?? NotificationService()
    }

    // MARK: - Прогрес

    func wordCount(for tag: Tag, in words: [Word]) -> Int {
        words.filter { $0.tags?.contains(where: { $0.id == tag.id }) ?? false }.count
    }

    func resetProgress(for tag: Tag, in words: [Word]) {
        for word in words where word.tags?.contains(where: { $0.id == tag.id }) ?? false {
            wordService.resetProgress(word)
        }
    }

    func confirmPendingReset(in words: [Word]) {
        if let tag = tagPendingReset {
            resetProgress(for: tag, in: words)
        }
        tagPendingReset = nil
        showResetTagPicker = false
    }

    // MARK: - Нотифікації

    func notificationsToggled(isOn: Bool, time: Date) {
        if isOn {
            Task {
                let granted = await notificationService.requestPermission()
                if granted {
                    notificationService.scheduleDailyReminder(at: time)
                }
            }
        } else {
            notificationService.cancelDailyReminder()
        }
    }

    func notificationTimeChanged(to time: Date, notificationsEnabled: Bool) {
        guard notificationsEnabled else { return }
        notificationService.scheduleDailyReminder(at: time)
    }
}

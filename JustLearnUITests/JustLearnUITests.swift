//
//  JustLearnUITests.swift
//  JustLearnUITests
//
//  Created by Illya Donchenko on 07.07.2026.
//

import XCTest

final class JustLearnUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments += ["-hasSeenOnboarding", "YES", "-uitest-reset"]
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    // MARK: - Helpers

    private func type(_ text: String, into field: XCUIElement) {
        XCTAssertTrue(field.waitForExistence(timeout: 3), "Field not found")
        field.tap()
        field.typeText(text)
    }

    private func clearAndType(_ text: String, into field: XCUIElement) {
        XCTAssertTrue(field.waitForExistence(timeout: 3), "Field not found")
        field.tap()
        if let currentValue = field.value as? String, !currentValue.isEmpty {
            let deleteString = String(
                repeating: XCUIKeyboardKey.delete.rawValue,
                count: currentValue.count
            )
            field.typeText(deleteString)
        }
        field.typeText(text)
    }

    private func switchTab(_ label: String) {
        let tab = app.tabBars.buttons[label]
        XCTAssertTrue(tab.waitForExistence(timeout: 2), "Tab \(label) not found")
        tab.tap()
    }

    // MARK: - Add word

    @MainActor
    func testAddWord() throws {
        switchTab("wordlist")

        let plusButton = app.navigationBars.buttons.element(boundBy: 1)
        XCTAssertTrue(plusButton.waitForExistence(timeout: 2))
        plusButton.tap()

        type("apple", into: app.textFields["Original spelling"])
        type("яблуко", into: app.textFields["Translation"])

        let saveButton = app.buttons["Save"]
        XCTAssertTrue(saveButton.isEnabled, "Save must be enabled with valid input")
        saveButton.tap()

        XCTAssertTrue(
            app.staticTexts["apple"].waitForExistence(timeout: 2),
            "Word 'apple' not shown in list"
        )
        XCTAssertTrue(app.staticTexts["яблуко"].exists)
    }

    // MARK: - Add tag

    @MainActor
    func testAddTag() throws {
        switchTab("settings")

        let manageTags = app.buttons["Manage tags"]
        XCTAssertTrue(manageTags.waitForExistence(timeout: 2))
        manageTags.tap()

        let plusButton = app.navigationBars.buttons.element(boundBy: 1)
        XCTAssertTrue(plusButton.waitForExistence(timeout: 2))
        plusButton.tap()

        let nameField = app.textFields["e.g. Food, Verbs, Travel"]
        type("Food", into: nameField)

        app.buttons["Save"].tap()

        XCTAssertTrue(
            app.staticTexts["Food"].waitForExistence(timeout: 2),
            "Tag 'Food' not in list"
        )
    }

    // MARK: - Delete word

    @MainActor
    func testDeleteWord() throws {
        try testAddWord()

        let row = app.staticTexts["apple"]
        XCTAssertTrue(row.waitForExistence(timeout: 2))

        row.swipeLeft()

        let deleteButton = app.buttons["Delete"]
        XCTAssertTrue(deleteButton.waitForExistence(timeout: 2))
        deleteButton.tap()

        let emptyText = app.staticTexts["To start your journey, add your first word"]
        XCTAssertTrue(emptyText.waitForExistence(timeout: 2))
        XCTAssertFalse(app.staticTexts["apple"].exists)
    }

    // MARK: - Delete tag

    @MainActor
    func testDeleteTag() throws {
        try testAddTag()

        let row = app.staticTexts["Food"]
        XCTAssertTrue(row.waitForExistence(timeout: 2))
        row.swipeLeft()

        let deleteButton = app.buttons["Delete"]
        XCTAssertTrue(deleteButton.waitForExistence(timeout: 2))
        deleteButton.tap()

        XCTAssertTrue(
            app.staticTexts["No tags yet"].waitForExistence(timeout: 2),
            "Empty state not shown after deleting tag"
        )
    }

    // MARK: - Edit word

    @MainActor
    func testEditWord() throws {
        try testAddWord()

        let row = app.staticTexts["apple"]
        XCTAssertTrue(row.waitForExistence(timeout: 2))
        row.swipeRight()

        let editButton = app.buttons["Edit"]
        XCTAssertTrue(editButton.waitForExistence(timeout: 2))
        editButton.tap()

        clearAndType("apples", into: app.textFields["Original spelling"])

        app.buttons["Done"].tap()

        XCTAssertTrue(
            app.staticTexts["apples"].waitForExistence(timeout: 2),
            "Edited word 'apples' not shown"
        )
    }

    // MARK: - Edit tag

    @MainActor
    func testEditTag() throws {
        try testAddTag()

        let row = app.staticTexts["Food"]
        XCTAssertTrue(row.waitForExistence(timeout: 2))
        row.swipeRight()

        let editButton = app.buttons["Edit"]
        XCTAssertTrue(editButton.waitForExistence(timeout: 2))
        editButton.tap()

        clearAndType("Meals", into: app.textFields["e.g. Food, Verbs, Travel"])

        app.buttons["Done"].tap()

        XCTAssertTrue(
            app.staticTexts["Meals"].waitForExistence(timeout: 2),
            "Renamed tag 'Meals' not shown"
        )
    }

    // MARK: - Onboarding flow

    @MainActor
    func testOnboardingFlow() throws {
        app.terminate()
        app.launchArguments = ["-uitest-reset", "-force-onboarding"]
        app.launch()

        XCTAssertTrue(
            app.buttons["Continue"].waitForExistence(timeout: 3),
            "Onboarding did not appear"
        )

        for _ in 0..<3 {
            let continueButton = app.buttons["Continue"]
            XCTAssertTrue(continueButton.waitForExistence(timeout: 2))
            continueButton.tap()
        }

        let getStarted = app.buttons["Get Started"]
        XCTAssertTrue(getStarted.waitForExistence(timeout: 2))
        getStarted.tap()

        XCTAssertTrue(
            app.tabBars.buttons["wordlist"].waitForExistence(timeout: 3),
            "Main app did not appear after finishing onboarding"
        )
    }

    // MARK: - Add word with tag (end-to-end)

    @MainActor
    func testAddWordWithTag() throws {
        try testAddTag()

        switchTab("wordlist")

        let plusButton = app.navigationBars.buttons.element(boundBy: 1)
        XCTAssertTrue(plusButton.waitForExistence(timeout: 2))
        plusButton.tap()

        type("pizza", into: app.textFields["Original spelling"])
        type("піца", into: app.textFields["Translation"])

        let addTagsLink = app.buttons["Add tags"]
        XCTAssertTrue(addTagsLink.waitForExistence(timeout: 2))
        addTagsLink.tap()

        let foodOption = app.collectionViews.buttons["Food"]
        XCTAssertTrue(foodOption.waitForExistence(timeout: 2), "Food tag not in picker")
        foodOption.tap()

        // Back to Add word sheet
        app.navigationBars["Tags"].buttons.element(boundBy: 0).tap()

        app.buttons["Save"].tap()

        XCTAssertTrue(app.staticTexts["pizza"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.staticTexts["Food"].exists, "Food tag chip missing on word row")
    }
}

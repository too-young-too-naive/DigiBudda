import XCTest
@testable import DigiBuddaCore

final class ShortcutDisplayTests: XCTestCase {

    // MARK: - Key name mapping

    func testCommonLetterKeys() {
        XCTAssertEqual(ShortcutManager.keyName(for: 0), "A")
        XCTAssertEqual(ShortcutManager.keyName(for: 1), "S")
        XCTAssertEqual(ShortcutManager.keyName(for: 2), "D")
        XCTAssertEqual(ShortcutManager.keyName(for: 40), "K")
        XCTAssertEqual(ShortcutManager.keyName(for: 46), "M")
    }

    func testNumberKeys() {
        XCTAssertEqual(ShortcutManager.keyName(for: 18), "1")
        XCTAssertEqual(ShortcutManager.keyName(for: 19), "2")
        XCTAssertEqual(ShortcutManager.keyName(for: 29), "0")
    }

    func testFunctionKeys() {
        XCTAssertEqual(ShortcutManager.keyName(for: 122), "F1")
        XCTAssertEqual(ShortcutManager.keyName(for: 120), "F2")
        XCTAssertEqual(ShortcutManager.keyName(for: 111), "F12")
    }

    func testSpecialKeys() {
        XCTAssertEqual(ShortcutManager.keyName(for: 49), "Space")
        XCTAssertEqual(ShortcutManager.keyName(for: 36), "↩")
        XCTAssertEqual(ShortcutManager.keyName(for: 48), "⇥")
        XCTAssertEqual(ShortcutManager.keyName(for: 51), "⌫")
        XCTAssertEqual(ShortcutManager.keyName(for: 53), "⎋")
    }

    func testArrowKeys() {
        XCTAssertEqual(ShortcutManager.keyName(for: 123), "←")
        XCTAssertEqual(ShortcutManager.keyName(for: 124), "→")
        XCTAssertEqual(ShortcutManager.keyName(for: 125), "↓")
        XCTAssertEqual(ShortcutManager.keyName(for: 126), "↑")
    }

    func testUnknownKeyCodeReturnsQuestionMark() {
        XCTAssertEqual(ShortcutManager.keyName(for: 255), "?")
        XCTAssertEqual(ShortcutManager.keyName(for: 200), "?")
    }

    // MARK: - Display string building

    func testDefaultShortcutDisplayString() {
        let mgr = ShortcutManager.shared
        let display = mgr.shortcutDisplayString
        XCTAssertFalse(display.isEmpty, "Shortcut display should not be empty")
    }

    func testKeyNameCoversAllQWERTYLetters() {
        let letterCodes: [UInt16] = [
            0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 11, 12, 13, 14, 15,
            16, 17, 31, 32, 33, 34, 35, 37, 38, 40, 41, 43, 45, 46
        ]
        for code in letterCodes {
            let name = ShortcutManager.keyName(for: code)
            XCTAssertNotEqual(name, "?", "Key code \(code) should have a mapped name")
            XCTAssertEqual(name.count, 1, "Letter key name should be a single character, got '\(name)' for code \(code)")
        }
    }
}

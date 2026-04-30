import XCTest
@testable import DigiBuddaCore

final class LocalizedStringsTests: XCTestCase {

    private let allLanguages: [AppLanguage] = [.chinese, .chineseTraditional, .english, .japanese, .korean]

    // MARK: - All functions return non-empty for every language

    func testAppTitleNonEmpty() {
        for lang in allLanguages {
            XCTAssertFalse(L10n.appTitle(lang).isEmpty, "\(lang)")
        }
    }

    func testTodayKnocksNonEmpty() {
        for lang in allLanguages {
            XCTAssertFalse(L10n.todayKnocks(lang).isEmpty, "\(lang)")
        }
    }

    func testKnockButtonNonEmpty() {
        for lang in allLanguages {
            XCTAssertFalse(L10n.knockButton(lang).isEmpty, "\(lang)")
        }
    }

    func testLanguageLabelNonEmpty() {
        for lang in allLanguages {
            XCTAssertFalse(L10n.language(lang).isEmpty, "\(lang)")
        }
    }

    func testQuitNonEmpty() {
        for lang in allLanguages {
            XCTAssertFalse(L10n.quit(lang).isEmpty, "\(lang)")
        }
    }

    func testMeritGoalNonEmpty() {
        for lang in allLanguages {
            XCTAssertFalse(L10n.meritGoal(lang).isEmpty, "\(lang)")
        }
    }

    func testSettingsNonEmpty() {
        for lang in allLanguages {
            XCTAssertFalse(L10n.settings(lang).isEmpty, "\(lang)")
        }
    }

    func testShortcutSectionNonEmpty() {
        for lang in allLanguages {
            XCTAssertFalse(L10n.shortcutSection(lang).isEmpty, "\(lang)")
        }
    }

    func testEnableShortcutNonEmpty() {
        for lang in allLanguages {
            XCTAssertFalse(L10n.enableShortcut(lang).isEmpty, "\(lang)")
        }
    }

    func testCurrentShortcutNonEmpty() {
        for lang in allLanguages {
            XCTAssertFalse(L10n.currentShortcut(lang).isEmpty, "\(lang)")
        }
    }

    func testPressKeysNonEmpty() {
        for lang in allLanguages {
            XCTAssertFalse(L10n.pressKeys(lang).isEmpty, "\(lang)")
        }
    }

    func testShortcutAccessibilityHintNonEmpty() {
        for lang in allLanguages {
            XCTAssertFalse(L10n.shortcutAccessibilityHint(lang).isEmpty, "\(lang)")
        }
    }

    func testVolumeSectionNonEmpty() {
        for lang in allLanguages {
            XCTAssertFalse(L10n.volumeSection(lang).isEmpty, "\(lang)")
        }
    }

    func testTestSoundNonEmpty() {
        for lang in allLanguages {
            XCTAssertFalse(L10n.testSound(lang).isEmpty, "\(lang)")
        }
    }

    // MARK: - English defaults

    func testEnglishAppTitle() {
        XCTAssertEqual(L10n.appTitle(.english), "DigiBudda")
    }

    func testEnglishTodayKnocks() {
        XCTAssertEqual(L10n.todayKnocks(.english), "Today's Merit")
    }

    func testEnglishKnockButton() {
        XCTAssertEqual(L10n.knockButton(.english), "🪷 Knock")
    }

    func testEnglishSettings() {
        XCTAssertEqual(L10n.settings(.english), "Settings")
    }

    func testEnglishLanguage() {
        XCTAssertEqual(L10n.language(.english), "Language")
    }

    // MARK: - Chinese titles contain DigiBudda

    func testChineseTitlesContainDigiBudda() {
        XCTAssertTrue(L10n.appTitle(.chinese).contains("DigiBudda"))
        XCTAssertTrue(L10n.appTitle(.chineseTraditional).contains("DigiBudda"))
        XCTAssertTrue(L10n.appTitle(.japanese).contains("DigiBudda"))
        XCTAssertTrue(L10n.appTitle(.korean).contains("DigiBudda"))
    }

    // MARK: - followSystem delegates correctly

    func testFollowSystemReturnsNonEmpty() {
        XCTAssertFalse(L10n.appTitle(.followSystem).isEmpty)
        XCTAssertFalse(L10n.todayKnocks(.followSystem).isEmpty)
        XCTAssertFalse(L10n.knockButton(.followSystem).isEmpty)
        XCTAssertFalse(L10n.settings(.followSystem).isEmpty)
    }

    // MARK: - Merit goal contains 108

    func testMeritGoalContains108() {
        for lang in allLanguages {
            XCTAssertTrue(L10n.meritGoal(lang).contains("108"), "\(lang) merit goal should reference 108")
        }
    }

    // MARK: - Quit contains DigiBudda

    func testQuitContainsAppName() {
        for lang in allLanguages {
            XCTAssertTrue(L10n.quit(lang).contains("DigiBudda"), "\(lang) quit should contain app name")
        }
    }
}

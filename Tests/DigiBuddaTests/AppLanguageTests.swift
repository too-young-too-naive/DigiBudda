import XCTest
@testable import DigiBuddaCore

final class AppLanguageTests: XCTestCase {

    func testAllCasesCount() {
        XCTAssertEqual(AppLanguage.allCases.count, 6)
    }

    func testRawValues() {
        XCTAssertEqual(AppLanguage.followSystem.rawValue, "followSystem")
        XCTAssertEqual(AppLanguage.chinese.rawValue, "zh-Hans")
        XCTAssertEqual(AppLanguage.chineseTraditional.rawValue, "zh-Hant")
        XCTAssertEqual(AppLanguage.english.rawValue, "en")
        XCTAssertEqual(AppLanguage.japanese.rawValue, "ja")
        XCTAssertEqual(AppLanguage.korean.rawValue, "ko")
    }

    func testInitFromRawValue() {
        XCTAssertEqual(AppLanguage(rawValue: "zh-Hans"), .chinese)
        XCTAssertEqual(AppLanguage(rawValue: "en"), .english)
        XCTAssertEqual(AppLanguage(rawValue: "ja"), .japanese)
        XCTAssertEqual(AppLanguage(rawValue: "ko"), .korean)
        XCTAssertEqual(AppLanguage(rawValue: "zh-Hant"), .chineseTraditional)
        XCTAssertEqual(AppLanguage(rawValue: "followSystem"), .followSystem)
        XCTAssertNil(AppLanguage(rawValue: "invalid"))
    }

    func testDisplayNameNonEmpty() {
        for lang in AppLanguage.allCases {
            XCTAssertFalse(lang.displayName.isEmpty, "\(lang) has empty displayName")
        }
    }

    func testDisplayNameValues() {
        XCTAssertEqual(AppLanguage.followSystem.displayName, "Follow System")
        XCTAssertEqual(AppLanguage.chinese.displayName, "简体中文")
        XCTAssertEqual(AppLanguage.chineseTraditional.displayName, "繁體中文")
        XCTAssertEqual(AppLanguage.english.displayName, "English")
        XCTAssertEqual(AppLanguage.japanese.displayName, "日本語")
        XCTAssertEqual(AppLanguage.korean.displayName, "한국어")
    }

    func testDisplayNamesAreUnique() {
        let names = AppLanguage.allCases.map(\.displayName)
        XCTAssertEqual(names.count, Set(names).count, "Display names should be unique")
    }

    func testIdMatchesRawValue() {
        for lang in AppLanguage.allCases {
            XCTAssertEqual(lang.id, lang.rawValue)
        }
    }

    func testResolvedConcreteCasesReturnSelf() {
        let concrete: [AppLanguage] = [.chinese, .chineseTraditional, .english, .japanese, .korean]
        for lang in concrete {
            XCTAssertEqual(lang.resolved, lang, "\(lang).resolved should return self")
        }
    }

    func testFollowSystemResolvesToConcreteLanguage() {
        let resolved = AppLanguage.followSystem.resolved
        XCTAssertNotEqual(resolved, .followSystem, "followSystem should resolve to a concrete language")
        let concrete: [AppLanguage] = [.chinese, .chineseTraditional, .english, .japanese, .korean]
        XCTAssertTrue(concrete.contains(resolved), "followSystem should resolve to one of the concrete languages")
    }
}

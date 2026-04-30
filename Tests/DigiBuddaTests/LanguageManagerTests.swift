import XCTest
@testable import DigiBuddaCore

final class LanguageManagerTests: XCTestCase {

    private var defaults: UserDefaults!

    override func setUp() {
        super.setUp()
        defaults = UserDefaults(suiteName: "com.digibudda.tests.\(UUID().uuidString)")!
    }

    override func tearDown() {
        defaults = nil
        super.tearDown()
    }

    // MARK: - Default state

    func testDefaultIsFollowSystem() {
        let mgr = LanguageManager(defaults: defaults)
        XCTAssertEqual(mgr.selectedLanguage, .followSystem)
    }

    // MARK: - Effective resolution

    func testEffectiveIsNotFollowSystem() {
        let mgr = LanguageManager(defaults: defaults)
        let concrete: [AppLanguage] = [.chinese, .chineseTraditional, .english, .japanese, .korean]
        XCTAssertTrue(concrete.contains(mgr.effective),
                      "effective should resolve to a concrete language")
    }

    func testEffectiveMatchesResolvedSelectedLanguage() {
        let mgr = LanguageManager(defaults: defaults)
        XCTAssertEqual(mgr.effective, mgr.selectedLanguage.resolved)
    }

    // MARK: - Language switching

    func testSetLanguageChinese() {
        let mgr = LanguageManager(defaults: defaults)
        mgr.selectedLanguage = .chinese
        XCTAssertEqual(mgr.selectedLanguage, .chinese)
        XCTAssertEqual(mgr.effective, .chinese)
    }

    func testSetLanguageJapanese() {
        let mgr = LanguageManager(defaults: defaults)
        mgr.selectedLanguage = .japanese
        XCTAssertEqual(mgr.effective, .japanese)
    }

    func testSetLanguageKorean() {
        let mgr = LanguageManager(defaults: defaults)
        mgr.selectedLanguage = .korean
        XCTAssertEqual(mgr.effective, .korean)
    }

    func testSetLanguageTraditionalChinese() {
        let mgr = LanguageManager(defaults: defaults)
        mgr.selectedLanguage = .chineseTraditional
        XCTAssertEqual(mgr.effective, .chineseTraditional)
    }

    func testSetLanguageEnglish() {
        let mgr = LanguageManager(defaults: defaults)
        mgr.selectedLanguage = .english
        XCTAssertEqual(mgr.effective, .english)
    }

    // MARK: - Persistence

    func testLanguagePersistsToDefaults() {
        let mgr = LanguageManager(defaults: defaults)
        mgr.selectedLanguage = .japanese
        let stored = defaults.string(forKey: LanguageManager.storageKey)
        XCTAssertEqual(stored, "ja")
    }

    func testLanguageRestoresFromDefaults() {
        let mgr1 = LanguageManager(defaults: defaults)
        mgr1.selectedLanguage = .korean

        let mgr2 = LanguageManager(defaults: defaults)
        XCTAssertEqual(mgr2.selectedLanguage, .korean, "Should restore persisted language")
    }

    func testInvalidStoredValueFallsBackToFollowSystem() {
        defaults.set("xx-invalid", forKey: LanguageManager.storageKey)
        let mgr = LanguageManager(defaults: defaults)
        XCTAssertEqual(mgr.selectedLanguage, .followSystem)
    }

    // MARK: - Switching back to followSystem

    func testSwitchBackToFollowSystem() {
        let mgr = LanguageManager(defaults: defaults)
        mgr.selectedLanguage = .chinese
        XCTAssertEqual(mgr.effective, .chinese)

        mgr.selectedLanguage = .followSystem
        XCTAssertNotEqual(mgr.effective, .followSystem, "effective should never be followSystem")
    }
}

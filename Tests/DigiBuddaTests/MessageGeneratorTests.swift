import XCTest
@testable import DigiBuddaCore

final class MessageGeneratorTests: XCTestCase {

    private let allLanguages: [AppLanguage] = [.chinese, .chineseTraditional, .english, .japanese, .korean]
    private let poolSize = 20

    // MARK: - Non-empty output

    func testAllLanguagesReturnNonEmptyMessage() {
        for lang in allLanguages {
            for count in [0, 1, 42, 108, 999] {
                let msg = MessageGenerator.meritMessage(count: count, language: lang)
                XCTAssertFalse(msg.isEmpty, "\(lang) count=\(count) returned empty message")
            }
        }
    }

    // MARK: - Count interpolation

    func testMessageContainsCount() {
        for lang in allLanguages {
            let count = 42
            let msg = MessageGenerator.meritMessage(count: count, language: lang)
            XCTAssertTrue(msg.contains("42"), "\(lang) message should contain count 42: \(msg)")
        }
    }

    func testMessageContainsLargeCount() {
        for lang in allLanguages {
            let count = 12345
            let msg = MessageGenerator.meritMessage(count: count, language: lang)
            XCTAssertTrue(msg.contains("12345"), "\(lang) message should contain count 12345: \(msg)")
        }
    }

    // MARK: - Pool cycling

    func testPoolCyclesThrough20Messages() {
        for lang in allLanguages {
            var unique = Set<String>()
            for count in 0..<poolSize {
                unique.insert(MessageGenerator.meritMessage(count: count, language: lang))
            }
            XCTAssertEqual(unique.count, poolSize,
                           "\(lang) should have \(poolSize) unique messages in pool, got \(unique.count)")
        }
    }

    func testPoolWrapsAround() {
        for lang in allLanguages {
            let first = MessageGenerator.meritMessage(count: 0, language: lang)
            let wrapped = MessageGenerator.meritMessage(count: poolSize, language: lang)
            XCTAssertTrue(first.contains("0"), "\(lang) count=0 message should contain 0")
            XCTAssertTrue(wrapped.contains("\(poolSize)"), "\(lang) count=\(poolSize) message should contain \(poolSize)")
        }
    }

    // MARK: - Determinism

    func testSameCountReturnsSameMessageIndex() {
        for lang in allLanguages {
            let a = MessageGenerator.meritMessage(count: 7, language: lang)
            let b = MessageGenerator.meritMessage(count: 7, language: lang)
            XCTAssertEqual(a, b, "\(lang) should return same message for same count")
        }
    }

    func testDifferentCountsReturnDifferentMessages() {
        for lang in allLanguages {
            let a = MessageGenerator.meritMessage(count: 1, language: lang)
            let b = MessageGenerator.meritMessage(count: 2, language: lang)
            XCTAssertNotEqual(a, b, "\(lang) should return different messages for consecutive counts")
        }
    }

    // MARK: - Edge cases

    func testZeroCount() {
        for lang in allLanguages {
            let msg = MessageGenerator.meritMessage(count: 0, language: lang)
            XCTAssertTrue(msg.contains("0"), "\(lang) should contain 0 for count=0")
        }
    }

    func testFollowSystemDelegatesToResolved() {
        let msg = MessageGenerator.meritMessage(count: 5, language: .followSystem)
        XCTAssertFalse(msg.isEmpty, "followSystem should produce a valid message")
    }
}

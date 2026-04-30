import Foundation

/// Centralized static UI strings.
/// All user-facing text flows through here so adding a new language
/// only requires extending these functions (and `AppLanguage`).
enum L10n {

    static func appTitle(_ lang: AppLanguage) -> String {
        switch lang.resolved {
        case .chinese:            return "DigiBudda · 赛博木鱼"
        case .chineseTraditional: return "DigiBudda · 賽博木魚"
        case .japanese:           return "DigiBudda · サイバー木魚"
        case .korean:             return "DigiBudda · 사이버 목어"
        default:                  return "DigiBudda"
        }
    }

    static func todayKnocks(_ lang: AppLanguage) -> String {
        switch lang.resolved {
        case .chinese:            return "今日敲击"
        case .chineseTraditional: return "今日敲擊"
        case .japanese:           return "今日の打数"
        case .korean:             return "오늘의 두드림"
        default:                  return "Today's Merit"
        }
    }

    static func knockButton(_ lang: AppLanguage) -> String {
        switch lang.resolved {
        case .chinese:            return "🪷 敲木鱼"
        case .chineseTraditional: return "🪷 敲木魚"
        case .japanese:           return "🪷 木魚を叩く"
        case .korean:             return "🪷 목어 두드리기"
        default:                  return "🪷 Knock"
        }
    }

    static func language(_ lang: AppLanguage) -> String {
        switch lang.resolved {
        case .chinese:            return "语言"
        case .chineseTraditional: return "語言"
        case .japanese:           return "言語"
        case .korean:             return "언어"
        default:                  return "Language"
        }
    }

    static func quit(_ lang: AppLanguage) -> String {
        switch lang.resolved {
        case .chinese:            return "退出 DigiBudda"
        case .chineseTraditional: return "結束 DigiBudda"
        case .japanese:           return "DigiBudda を終了"
        case .korean:             return "DigiBudda 종료"
        default:                  return "Quit DigiBudda"
        }
    }

    static func meritGoal(_ lang: AppLanguage) -> String {
        switch lang.resolved {
        case .chinese:            return "每日目标：108"
        case .chineseTraditional: return "每日目標：108"
        case .japanese:           return "日課目標：108"
        case .korean:             return "일일 목표: 108"
        default:                  return "Daily goal: 108"
        }
    }

    // MARK: - Settings

    static func settings(_ lang: AppLanguage) -> String {
        switch lang.resolved {
        case .chinese:            return "设置"
        case .chineseTraditional: return "設定"
        case .japanese:           return "設定"
        case .korean:             return "설정"
        default:                  return "Settings"
        }
    }

    static func shortcutSection(_ lang: AppLanguage) -> String {
        switch lang.resolved {
        case .chinese:            return "快捷键"
        case .chineseTraditional: return "快捷鍵"
        case .japanese:           return "ショートカット"
        case .korean:             return "단축키"
        default:                  return "Shortcut"
        }
    }

    static func enableShortcut(_ lang: AppLanguage) -> String {
        switch lang.resolved {
        case .chinese:            return "启用全局快捷键"
        case .chineseTraditional: return "啟用全域快捷鍵"
        case .japanese:           return "グローバルショートカットを有効化"
        case .korean:             return "전역 단축키 활성화"
        default:                  return "Enable global shortcut"
        }
    }

    static func currentShortcut(_ lang: AppLanguage) -> String {
        switch lang.resolved {
        case .chinese:            return "当前快捷键"
        case .chineseTraditional: return "目前快捷鍵"
        case .japanese:           return "現在のキー"
        case .korean:             return "현재 단축키"
        default:                  return "Current shortcut"
        }
    }

    static func pressKeys(_ lang: AppLanguage) -> String {
        switch lang.resolved {
        case .chinese:            return "请按下组合键…"
        case .chineseTraditional: return "請按下組合鍵…"
        case .japanese:           return "キーを押してください…"
        case .korean:             return "키를 누르세요…"
        default:                  return "Press keys…"
        }
    }

    static func shortcutAccessibilityHint(_ lang: AppLanguage) -> String {
        switch lang.resolved {
        case .chinese:            return "需要在系统设置 → 隐私与安全 → 辅助功能中授权"
        case .chineseTraditional: return "需要在系統設定 → 隱私與安全 → 輔助使用中授權"
        case .japanese:           return "システム設定 → プライバシーとセキュリティ → アクセシビリティで許可が必要"
        case .korean:             return "시스템 설정 → 개인 정보 보호 → 손쉬운 사용에서 권한 필요"
        default:                  return "Requires Accessibility permission in System Settings"
        }
    }

    static func volumeSection(_ lang: AppLanguage) -> String {
        switch lang.resolved {
        case .chinese:            return "音量"
        case .chineseTraditional: return "音量"
        case .japanese:           return "音量"
        case .korean:             return "음량"
        default:                  return "Volume"
        }
    }

    static func testSound(_ lang: AppLanguage) -> String {
        switch lang.resolved {
        case .chinese:            return "试听"
        case .chineseTraditional: return "試聽"
        case .japanese:           return "テスト再生"
        case .korean:             return "테스트"
        default:                  return "Test"
        }
    }
}

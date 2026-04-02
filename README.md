# DigiBudda 🪷 赛博木鱼

<p align="center">
  <img src="DigiBudda/Resources/icon.png" alt="DigiBudda" width="160">
</p>

A lightweight, funny macOS menu bar productivity/spiritual parody app.

Press **⌘⇧K** anywhere to knock the wooden fish (敲木鱼). Each knock plays a sound and accumulates today's merit. Click the menu bar icon to see your daily count and a playful message.

Bilingual: supports **Simplified Chinese** and **English** with in-app language switching.

---

## Features

- **Menu bar only** — lives in the top bar, no Dock icon
- **Global shortcut** ⌘⇧K — works from any app
- **Wooden fish sound** on every knock
- **Daily counter** — persists across restarts, auto-resets each day
- **Funny merit messages** in Chinese and English
- **Language picker** — Follow System / 简体中文 / English
- **Lightweight** — pure Swift + SwiftUI, no third-party dependencies

---

## Quick Start

No Xcode required. Just a terminal and macOS Command Line Tools.

### 1. Install Command Line Tools (if you don't have them)

```bash
xcode-select --install
```

### 2. Clone and Build

```bash
git clone <repo-url> DigiBudda
cd DigiBudda
./build.sh run
```

That's it. The build script will:
- Generate a placeholder wooden fish sound (if you haven't added your own)
- Compile all Swift source files
- Assemble a proper `.app` bundle
- Launch the app

A wooden fish icon will appear in your menu bar.

### 3. Grant Accessibility Permission (for global shortcut)

The **⌘⇧K** shortcut needs Accessibility access to work from any app:

1. Open **System Settings → Privacy & Security → Accessibility**
2. Click **+**, navigate to `build/DigiBudda.app` (or `/Applications/DigiBudda.app`)
3. Toggle it **on**

### 4. Install to Applications (optional)

```bash
./build.sh install
```

Copies the app to `/Applications/DigiBudda.app` so you can launch it from Spotlight.

---

## Build Commands

| Command | What it does |
|---|---|
| `./build.sh` | Build only |
| `./build.sh run` | Build and launch |
| `./build.sh install` | Build and copy to `/Applications` |
| `./build.sh clean` | Remove build artifacts |

---

## Usage

- **Click** the wooden fish icon in the menu bar to open the popover
- **⌘⇧K** from any app to knock (plays sound + increments count)
- **Switch language** in the popover dropdown
- Count **persists** across app restarts and **resets at midnight**

---

## Replace the Placeholder Sound

The build auto-generates a synthetic "tok" sound. To use a real wooden fish sound:

1. Drop a `woodenfish.mp3` (or `.wav` / `.m4a`) into `DigiBudda/Resources/`
2. Rebuild: `./build.sh run`

Free wooden fish sounds are available on [freesound.org](https://freesound.org) (search "wooden fish" or "木鱼").

---

## Project Structure

```
DigiBudda/
├── build.sh                             # ← Build & install script
├── scripts/
│   └── generate_sound.py                # Generates placeholder sound
├── DigiBudda/
│   ├── App/
│   │   ├── DigiBuddaApp.swift           # @main entry point
│   │   └── AppDelegate.swift            # NSStatusItem + NSPopover + wiring
│   ├── Models/
│   │   └── AppLanguage.swift            # Language enum (Follow System / 中文 / EN)
│   ├── Services/
│   │   ├── AudioManager.swift           # AVFoundation playback
│   │   ├── KnockManager.swift           # Daily count + UserDefaults persistence
│   │   ├── ShortcutManager.swift        # Global ⌘⇧K via NSEvent monitors
│   │   ├── LanguageManager.swift        # In-app language override
│   │   └── MessageGenerator.swift       # Funny bilingual merit messages
│   ├── Views/
│   │   ├── MenuBarPopover.swift         # Main popover UI
│   │   └── LanguagePickerView.swift     # Language selector
│   ├── Localization/
│   │   └── LocalizedStrings.swift       # Centralized UI strings
│   ├── Resources/
│   │   ├── woodenfish.wav               # Sound (auto-generated or your own)
│   │   ├── AppIcon.icns                 # App icon
│   │   └── menubar_icon.png             # Menu bar template icon
│   └── Assets.xcassets/                 # Icon catalog
├── .gitignore
└── README.md
```

---

## Customization

### Change the Shortcut

In `ShortcutManager.swift`, modify:

```swift
var modifiers: NSEvent.ModifierFlags = [.command, .shift]
var keyCode: UInt16 = 40  // 'k'
```

Key codes reference: [macOS Virtual Key Codes](https://eastmanreference.com/complete-list-of-applescript-key-codes)

### Add a New Language

1. Add a case to `AppLanguage` (e.g. `.japanese = "ja"`)
2. Add display name and resolution logic
3. Add strings in `L10n` and `MessageGenerator`

---

## v2 Roadmap

- [ ] Shortcut customization UI (record-style key binding)
- [ ] Knock animation / particle effect on screen
- [ ] Streak tracking (consecutive days)
- [ ] Weekly/monthly stats view
- [ ] Custom sound packs
- [ ] Launch at Login toggle
- [ ] Menu bar icon shows today's count
- [ ] Traditional Chinese language support

---

## Requirements

- macOS 14.0+
- Swift 5.9+ (included with Command Line Tools)

---

## License

MIT — knock freely, accumulate merit infinitely.

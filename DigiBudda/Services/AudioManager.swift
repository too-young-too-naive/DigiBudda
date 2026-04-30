import AVFoundation

/// Manages wooden-fish sound playback using AVFoundation.
final class AudioManager: ObservableObject {

    static let shared = AudioManager()

    private static let volumeKey = "sound_volume"

    private var player: AVAudioPlayer?

    @Published var volume: Float {
        didSet {
            player?.volume = volume
            UserDefaults.standard.set(volume, forKey: Self.volumeKey)
        }
    }

    private init() {
        let saved = UserDefaults.standard.object(forKey: Self.volumeKey) as? Float
        self.volume = saved ?? 0.8
        prepareSound()
    }

    func playKnockSound() {
        player?.currentTime = 0
        player?.play()
    }

    // MARK: - Private

    private func prepareSound() {
        let extensions = ["mp3", "wav", "m4a", "aiff", "caf"]
        for ext in extensions {
            if let url = Bundle.main.url(forResource: "woodenfish", withExtension: ext) {
                do {
                    player = try AVAudioPlayer(contentsOf: url)
                    player?.volume = volume
                    player?.prepareToPlay()
                    return
                } catch {
                    print("[AudioManager] Failed to load woodenfish.\(ext): \(error.localizedDescription)")
                }
            }
        }
        print("[AudioManager] ⚠️ No woodenfish sound file found in bundle.")
    }
}

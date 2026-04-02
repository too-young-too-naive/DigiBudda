import AVFoundation

/// Manages wooden-fish sound playback using AVFoundation.
final class AudioManager: ObservableObject {

    static let shared = AudioManager()

    private var player: AVAudioPlayer?

    private init() {
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

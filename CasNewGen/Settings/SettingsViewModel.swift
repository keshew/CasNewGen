import SwiftUI

class SettingsViewModel: ObservableObject {
    let contact = SettingsModel()
    @ObservedObject private var soundManager = SoundManager.shared
    @Published var isSound: Bool {
        didSet {
            soundManager.toggleSound()
            UserDefaults.standard.set(isSound, forKey: "isSoundOn")
            NotificationCenter.default.post(name: Notification.Name("UserResourcesUpdated"), object: nil)
        }
    }
    @Published var isMsuic: Bool {
        didSet {
            UserDefaults.standard.set(isMsuic, forKey: "isMusicOn")
            soundManager.toggleMusic()
            NotificationCenter.default.post(name: Notification.Name("UserResourcesUpdated"), object: nil)
        }
    }
    
    init() {
        self.isSound = UserDefaults.standard.bool(forKey: "isSoundOn")
        self.isMsuic = UserDefaults.standard.bool(forKey: "isMusicOn")
    }
}

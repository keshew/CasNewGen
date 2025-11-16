import SwiftUI

class SettingsViewModel: ObservableObject {
    let contact = SettingsModel()

    @Published var isSound: Bool {
        didSet {
            UserDefaults.standard.set(isSound, forKey: "isSound")
        }
    }
    @Published var isMsuic: Bool {
        didSet {
            UserDefaults.standard.set(isMsuic, forKey: "isMsuic")
        }
    }
    
    init() {
        self.isSound = UserDefaults.standard.bool(forKey: "isSound")
        self.isMsuic = UserDefaults.standard.bool(forKey: "isMsuic")
    }
}

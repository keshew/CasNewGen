import SwiftUI

class PlinkoViewModel: ObservableObject {
    @Published var coin =  UserDefaultsManager.shared.coins
    @Published var bet = 100
    @Published var win = 0
    @ObservedObject private var soundManager = SoundManager.shared

    func createGameScene(gameData: GameData) -> GameSpriteKit {
        let scene = GameSpriteKit()
        scene.game  = gameData
        return scene
    }
}

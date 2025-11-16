import SwiftUI

class HeadOrTailViewModel: ObservableObject {
    let contact = HeadOrTailModel()
    @Published var coin =  UserDefaultsManager.shared.coins
    @Published var bet = 100
    @Published var win = 0
    @ObservedObject private var soundManager = SoundManager.shared
    @Published var isTail = false
    @Published var isFlipping = false
    @Published var rotationStep = 0
    @Published var totalRotations = 0

    private var userChoiceIsTail: Bool = false
    private var finalResultTail: Bool = false
    var onFlipResult: ((Bool) -> Void)? = nil

    func startFlip(userChoice: Bool) {
        guard !isFlipping, bet <= coin else { return }
        let _ = UserDefaultsManager.shared.spendCoins(bet)
        coin = UserDefaultsManager.shared.coins
        userChoiceIsTail = userChoice
        totalRotations = Int.random(in: 5...7)
        finalResultTail = (totalRotations % 2 != 0)
        rotationStep = 0
        isFlipping = true
        runRotationAnimation()
    }

    private func runRotationAnimation() {
        guard rotationStep < totalRotations else {
            isFlipping = false
            isTail = finalResultTail

            if userChoiceIsTail == finalResultTail {
                UserDefaultsManager.shared.addCoins(bet * 2)
                coin = UserDefaultsManager.shared.coins
                onFlipResult?(true)
            } else {
                onFlipResult?(false)
            }
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.rotationStep += 1
            self.runRotationAnimation()
        }
    }
}

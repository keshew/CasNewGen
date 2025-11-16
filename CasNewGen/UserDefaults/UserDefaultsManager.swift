import SwiftUI

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private let coinsKey = "coinsValue"
    private let rewardsKey = "rewardsReceived"
    private let lastRewardDateKey = "lastRewardDate"
    private let calendar = Calendar.current

    private init() {}


    var coins: Int {
        get { UserDefaults.standard.integer(forKey: coinsKey) }
        set { UserDefaults.standard.set(newValue, forKey: coinsKey) }
    }

    func addCoins(_ amount: Int) {
        coins += amount
    }

    func spendCoins(_ amount: Int) -> Bool {
        if coins >= amount {
            coins -= amount
            return true
        }
        return false
    }

}

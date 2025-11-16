import SwiftUI
import Combine

struct WheelSegment: Identifiable {
    let id = UUID()
    let title: String
    let prize: Double
    let color: Color
}

class WheelViewModel: ObservableObject {
    @Published var coin =  UserDefaultsManager.shared.coins
    @Published var bet = 100
    @Published var win = 0
    @ObservedObject private var soundManager = SoundManager.shared
    @Published var segments: [WheelSegment] = [
        WheelSegment(title: "1K", prize: 1000, color: Color(red: 139/255, green: 30/255, blue: 47/255)),
        WheelSegment(title: "500", prize: 500, color: Color(red: 75/255, green: 42/255, blue: 123/255)),
        WheelSegment(title: "1K", prize: 1000, color: Color(red: 139/255, green: 30/255, blue: 47/255)),
        WheelSegment(title: "2K", prize: 2000, color: Color(red: 75/255, green: 42/255, blue: 123/255)),
        WheelSegment(title: "5K", prize: 5000, color: Color(red: 139/255, green: 30/255, blue: 47/255)),
        WheelSegment(title: "500", prize: 500, color: Color(red: 75/255, green: 42/255, blue: 123/255)),
        WheelSegment(title: "100", prize: 100, color: Color(red: 139/255, green: 30/255, blue: 47/255)),
        WheelSegment(title: "10K", prize: 10000, color: Color(red: 212/255, green: 175/255, blue: 56/255))
    ]
    
    @Published var isSpinning = false
    @Published var rotationDegree: Double = 0
    private var cancellables = Set<AnyCancellable>()
    private var userDefaults = UserDefaultsManager.shared
    @Published private(set) var balance: Double = 0
    @Published var alertMessage: String? = nil
    
    @Published var selectedSegmentIndex: Int? = nil
     @Published var betAmount: Double = 0
    
    func spinWheel() {
         guard !isSpinning else { return }
         win = 0
         guard let selectedIndex = selectedSegmentIndex else {
             alertMessage = "Please select a segment before spinning."
             return
         }
         
        guard bet > 0 && bet <= coin else {
             alertMessage = "Please set a valid bet amount."
             return
         }
         
         isSpinning = true
        soundManager.playSoundBtn()
        let _ = UserDefaultsManager.shared.spendCoins(bet)
        coin = UserDefaultsManager.shared.coins
        
         let fullRotations = Double.random(in: 3...6)
         let randomAngle = Double.random(in: 0..<360)
         let newRotation = rotationDegree + fullRotations * 360 + randomAngle
         
         withAnimation(.easeOut(duration: 3)) {
             rotationDegree = newRotation
         }
         
         DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
             let normalizedDegree = (self.rotationDegree.truncatingRemainder(dividingBy: 360))
             let segmentAngle = 360.0 / Double(self.segments.count)
             let index = Int(Double(self.segments.count) - (normalizedDegree / segmentAngle)) % self.segments.count
             
             if index == selectedIndex {
                 let prize = self.segments[index].prize * self.betAmount
                 self.applyPrize(Int(prize))
                 self.alertMessage = "You won $\(String(format: "%.2f", prize))!"
             } else {
                 self.alertMessage = "You lost your bet. Try again!"
             }
             
             self.isSpinning = false
             self.soundManager.stopWrong()
         }
     }
     
    private func applyPrize(_ prize: Int) {
         win = prize
         UserDefaultsManager.shared.addCoins(win)
         coin = UserDefaultsManager.shared.coins
     }
    
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

import SwiftUI
import SpriteKit
import Combine

class GameData: ObservableObject {
    @Published var reward: Double = 0.0
    @Published var bet: Int = 50
    @Published var numberOfBets: Int = 1 {
        didSet {
            if numberOfBets < 1 { numberOfBets = 1 }
            if numberOfBets > 4 { numberOfBets = 4 }
        }
    }
    @Published var balance: Int = UserDefaultsManager.shared.coins
    @Published var isPlayTapped: Bool = false
    @Published var labels: [String] = ["0.5x", "1x", "1.5x", "2x", "3x", "5x", "3x", "2x", "1.5x", "1x", "0.5x"]
    
    var createBallPublisher = PassthroughSubject<Void, Never>()
    
    var formattedBalance: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: balance)) ?? "\(balance)"
    }
    
    var formattedBetTotal: String {
        let total = bet * numberOfBets
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: total)) ?? "\(total)"
    }
    
    func decreaseBet() {
        if bet - 50 >= 50 {
            bet -= 50
        }
    }
    func increaseBet() {
        let newBet = bet + 50
        if newBet * numberOfBets <= balance {
            bet = newBet
        }
    }
    func setBet(to value: Int) {
        if value * numberOfBets <= balance {
            bet = value
        }
    }
    func maxBet() {
        let max = balance / numberOfBets
        bet = max - max % 50
        if bet < 50 { bet = 50 }
    }
    
    func decreaseBalls() {
        if numberOfBets > 1 {
            numberOfBets -= 1
            if bet * numberOfBets > balance {
                bet = balance / numberOfBets
                bet -= bet % 50
                if bet < 50 { bet = 50 }
            }
        }
    }
    func increaseBalls() {
        if numberOfBets < 4 {
            if bet * (numberOfBets + 1) <= balance {
                numberOfBets += 1
            }
        }
    }
    
    func dropBalls() {
        guard bet * numberOfBets <= balance else {
            return
        }
        let _ = UserDefaultsManager.shared.spendCoins(bet * numberOfBets)
        balance = UserDefaultsManager.shared.coins
        reward = 0.0
        isPlayTapped = true
        createBallPublisher.send(())
    }
    func resetGame() {
        bet = 50
        numberOfBets = 1
        reward = 0
        isPlayTapped = false
    }
    
    func addWin(_ amount: Double) {
        reward += amount
        UserDefaultsManager.shared.addCoins(Int(reward))
        balance = UserDefaultsManager.shared.coins
    }
    
    func finishGame() {
        balance += Int(reward)
        
        reward = 0
        isPlayTapped = false
    }
}

class GameSpriteKit: SKScene, SKPhysicsContactDelegate {
    var game: GameData? {
        didSet {
            bindToGame()
        }
    }
    
    private func bindToGame() {
        cancellables.removeAll()
        game?.$numberOfBets
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.createInitialBalls()
            }
            .store(in: &cancellables)
    }
    
    let ballCategory: UInt32 = 0x1 << 0
    let obstacleCategory: UInt32 = 0x1 << 1
    let ticketCategory: UInt32 = 0x1 << 2
    
    var ballsInPlay: Int = 0
    var ballNodes: [SKSpriteNode] = []
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        size = UIScreen.main.bounds.size
        backgroundColor = .clear
        
        createObstacles()
        createTickets()
        createInitialBalls()
        
        game?.createBallPublisher.sink { [weak self] in
            self?.launchBalls()
        }.store(in: &cancellables)
    }
    
    var cancellables = Set<AnyCancellable>()
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        for (index, ball) in ballNodes.enumerated().reversed() {
            if ball.position.y < 0 || ball.position.x < 0 || ball.position.x > size.width {
                ball.removeFromParent()
                ballNodes.remove(at: index)
                ballsInPlay -= 1
                createBall(atIndex: index)
            }
        }
    }
    
    func createObstacles() {
        let startRowCount = 2
        let numberOfRows = 6
        let obstacleSize = CGSize(width: size.width > 1000 ? 30 : 30, height: size.width > 1000 ? 40 : 20)
        let horizontalSpacing: CGFloat = size.width > 1000 ? 90 : 55
        
        for row in 0..<numberOfRows {
            let countInRow = startRowCount + row
            let totalWidth = CGFloat(countInRow) * (obstacleSize.width + horizontalSpacing) - horizontalSpacing
            let xOffset = (size.width - totalWidth) / 2 + obstacleSize.width / 2
            let yPosition = (UIScreen.main.bounds.width > 1000 ? size.height / 1.35 : size.height / 1.32) - CGFloat(row) * (obstacleSize.height + UIScreen.main.bounds.width > 1000 ? 105 : 45)
            
            for col in 0..<countInRow {
                let obstacle = SKSpriteNode(imageNamed: "obstacle")
                obstacle.size = obstacleSize
                let xPosition = xOffset + CGFloat(col) * (obstacleSize.width + horizontalSpacing)
                obstacle.position = CGPoint(x: xPosition, y: yPosition)
                
                obstacle.physicsBody = SKPhysicsBody(circleOfRadius: obstacleSize.width / 2.0)
                obstacle.physicsBody?.isDynamic = false
                obstacle.physicsBody?.categoryBitMask = obstacleCategory
                obstacle.physicsBody?.contactTestBitMask = ballCategory
                
                addChild(obstacle)
            }
        }
    }
    
    func createTickets() {
        guard let game = self.game else { return }
        let labels = game.labels
        let count = labels.count
        let ticketWidth: CGFloat = size.width > 1000 ? 80 : 50
        let horizontalSpacing: CGFloat = 15
        let totalWidth = CGFloat(count) * (ticketWidth + horizontalSpacing) - horizontalSpacing
        let xOffset = (size.width - totalWidth) / 2 + ticketWidth / 2
        let yPosition = size.width > 1200 ? size.height / 10 : size.height / 7.5
        for i in 0..<count {
            let label = SKLabelNode(text: labels[i])
            label.fontName = "Helvetica-Bold"
            label.fontSize = size.width > 1200 ? 28 : 16
            label.fontColor = UIColor(red: 253/255, green: 255/255, blue: 193/255, alpha: 1)
            label.verticalAlignmentMode = .center
            label.horizontalAlignmentMode = .center
            label.position = CGPoint(x: xOffset + CGFloat(i) * (ticketWidth + horizontalSpacing), y: yPosition)
            label.xScale = size.width > 1000 ? 1 : 1.5
            label.yScale = 1
            
            label.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: ticketWidth, height: label.frame.height))
            label.physicsBody?.isDynamic = false
            label.physicsBody?.categoryBitMask = ticketCategory
            label.physicsBody?.contactTestBitMask = ballCategory
            label.name = "ticket_\(i)"
            
            addChild(label)
        }
    }
    
    func createInitialBalls() {
        guard let game = game else { return }
        
        ballNodes.forEach { $0.removeFromParent() }
        ballNodes.removeAll()
        ballsInPlay = 0
        
        for _ in 0..<game.numberOfBets {
            let ball = SKSpriteNode(imageNamed: "ball")
            ball.size = CGSize(width: UIScreen.main.bounds.width > 1000 ? 40 : 30, height: UIScreen.main.bounds.width > 1000 ? 43 : 20)
            ball.position = CGPoint(x: size.width / 2,
                                    y: size.height / 1.15)
            ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 5)
            ball.physicsBody?.categoryBitMask = ballCategory
            ball.physicsBody?.contactTestBitMask = obstacleCategory | ticketCategory
            ball.physicsBody?.collisionBitMask = obstacleCategory | ticketCategory
            ball.physicsBody?.restitution = 0.4
            ball.physicsBody?.linearDamping = 0.5
            ball.physicsBody?.friction = 0.1
            ball.physicsBody?.isDynamic = true
            ball.physicsBody?.allowsRotation = false
            ball.physicsBody?.affectedByGravity = false
            
            addChild(ball)
            ballNodes.append(ball)
            ballsInPlay += 1
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let game = game else { return }
        var ticketNode: SKNode?
        var ballNode: SKNode?
        
        if contact.bodyA.categoryBitMask == ticketCategory {
            ticketNode = contact.bodyA.node
        }
        if contact.bodyB.categoryBitMask == ticketCategory {
            ticketNode = contact.bodyB.node
        }
        if contact.bodyA.categoryBitMask == ballCategory {
            ballNode = contact.bodyA.node
        }
        if contact.bodyB.categoryBitMask == ballCategory {
            ballNode = contact.bodyB.node
        }
        
        if let ticket = ticketNode as? SKLabelNode,
           let multiplier = parseMultiplier(from: ticket.text),
           let ball = ballNode as? SKSpriteNode {
           
           let win = Double(game.bet) * multiplier
           game.addWin(win)
           
           ball.removeFromParent()
           if let index = ballNodes.firstIndex(of: ball) {
               ballNodes.remove(at: index)
           }
           ballsInPlay -= 1

           createBall(atIndex: 0)
        }

        
        checkBallsStopped()
    }
    
    func createBall(atIndex index: Int) {
        guard let game = game else { return }
        guard index < game.numberOfBets else { return }
        
        let ball = SKSpriteNode(imageNamed: "ball")
        ball.size = CGSize(width: UIScreen.main.bounds.width > 1000 ? 40 : 30, height: UIScreen.main.bounds.width > 1000 ? 43 : 20)
        ball.position = CGPoint(x: size.width / 2 ,
                                y: size.height / 1.15)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 5)
        ball.physicsBody?.categoryBitMask = ballCategory
        ball.physicsBody?.contactTestBitMask = obstacleCategory | ticketCategory
        ball.physicsBody?.collisionBitMask = obstacleCategory | ticketCategory
        ball.physicsBody?.restitution = 0.4
        ball.physicsBody?.linearDamping = 0.5
        ball.physicsBody?.friction = 0.1
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.allowsRotation = false
        ball.physicsBody?.affectedByGravity = false
        
        addChild(ball)
        ballNodes.append(ball)
        ballsInPlay += 1
    }
    
    func launchBalls() {
        for (i, ball) in ballNodes.enumerated() {
            ball.physicsBody?.affectedByGravity = true
            let baseImpulseX: CGFloat = 0.2
            let variation = CGFloat(i) - CGFloat(ballNodes.count - 1)/2
            
            let randomXImpulse = baseImpulseX * variation + CGFloat.random(in: -0.1...0.1)
            
            ball.physicsBody?.applyImpulse(CGVector(dx: randomXImpulse, dy: 0))
        }
    }
    
    private func parseMultiplier(from text: String?) -> Double? {
        guard let text = text?.lowercased().replacingOccurrences(of: "x", with: "") else { return nil }
        return Double(text)
    }
    
    private func checkBallsStopped() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self, let game = self.game else { return }
            let movingBalls = self.ballNodes.filter {
                guard let body = $0.physicsBody else { return false }
                return body.velocity.dx > 5 || body.velocity.dy > 5
            }
            if movingBalls.isEmpty && game.isPlayTapped {
                game.finishGame()
            }
        }
    }
}

struct PlinkoView: View {
    @StateObject var viewModel =  PlinkoViewModel()
    @Environment(\.presentationMode) var presentationMode
    @StateObject var gameModel = GameData()
    var body: some View {
        ZStack {
            ZStack(alignment: .top) {
                Image(.bgPlinko)
                    .resizable()
                
                Image(.rectGalact)
                    .resizable()
                    .frame(height:  UIScreen.main.bounds.width > 1000 ? 115 : 95)
            }
            .ignoresSafeArea()
            
            VStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                        NotificationCenter.default.post(name: Notification.Name("UserResourcesUpdated"), object: nil)
                    }) {
                        Image(.home)
                            .resizable()
                            .frame(width: 49, height: 49)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 35) {
                        VStack(spacing: 0) {
                            Text("BET")
                                .font(.custom("PaytoneOne-Regular", size: 14))
                                .foregroundStyle(Color(red: 253/255, green: 255/255, blue: 193/255))
                            
                            ZStack(alignment: .leading) {
                                Rectangle()
                                    .fill(LinearGradient(colors: [Color(red: 69/255, green: 0/255, blue: 152/255),
                                                                  Color(red: 43/255, green: 0/255, blue: 63/255)], startPoint: .top, endPoint: .bottom))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 24)
                                            .stroke(.white)
                                            .overlay {
                                                Text("\(gameModel.bet)")
                                                    .font(.custom("PaytoneOne-Regular", size: 18))
                                                    .foregroundStyle(Color(red: 253/255, green: 255/255, blue: 193/255))
                                                    .offset(x: 8, y: -1)
                                            }
                                    }
                                    .frame(width: 90, height: 31)
                                    .cornerRadius(24)
                                
                                Image(.coin)
                                    .resizable()
                                    .frame(width: 39, height: 40)
                                    .offset(x: -15)
                            }
                        }
                        
                        VStack(spacing: 0) {
                            Text("WIN")
                                .font(.custom("PaytoneOne-Regular", size: 14))
                                .foregroundStyle(Color(red: 253/255, green: 255/255, blue: 193/255))
                            
                            ZStack(alignment: .leading) {
                                Rectangle()
                                    .fill(LinearGradient(colors: [Color(red: 69/255, green: 0/255, blue: 152/255),
                                                                  Color(red: 43/255, green: 0/255, blue: 63/255)], startPoint: .top, endPoint: .bottom))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 24)
                                            .stroke(.white)
                                            .overlay {
                                                Text("\(viewModel.win)")
                                                    .font(.custom("PaytoneOne-Regular", size: 18))
                                                    .foregroundStyle(Color(red: 253/255, green: 255/255, blue: 193/255))
                                                    .offset(x: 8, y: -1)
                                            }
                                    }
                                    .frame(width: 90, height: 31)
                                    .cornerRadius(24)
                                
                                Image(.coin)
                                    .resizable()
                                    .frame(width: 39, height: 40)
                                    .offset(x: -15)
                            }
                        }
                        
                        VStack(spacing: 0) {
                            Text("BALANCE")
                                .font(.custom("PaytoneOne-Regular", size: 14))
                                .foregroundStyle(Color(red: 253/255, green: 255/255, blue: 193/255))
                            
                            ZStack(alignment: .leading) {
                                Rectangle()
                                    .fill(LinearGradient(colors: [Color(red: 69/255, green: 0/255, blue: 152/255),
                                                                  Color(red: 43/255, green: 0/255, blue: 63/255)], startPoint: .top, endPoint: .bottom))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 24)
                                            .stroke(.white)
                                            .overlay {
                                                Text("\(gameModel.balance)")
                                                    .font(.custom("PaytoneOne-Regular", size: 18))
                                                    .foregroundStyle(Color(red: 253/255, green: 255/255, blue: 193/255))
                                                    .offset(x: 8, y: -1)
                                            }
                                    }
                                    .frame(width: 90, height: 31)
                                    .cornerRadius(24)
                                
                                Image(.coin)
                                    .resizable()
                                    .frame(width: 39, height: 40)
                                    .offset(x: -15)
                            }
                        }
                    }
                    
                    Spacer()
                }
                
                Spacer()
                
                Image(.descPlinko)
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width > 1000 ? 550 : 373, height: UIScreen.main.bounds.width > 1000 ? 350 : 228)
                    .overlay {
                        VStack {
                            SpriteView(scene: viewModel.createGameScene(gameData: gameModel), options: [.allowsTransparency])
                                .frame(width: UIScreen.main.bounds.width > 1000 ? 550 : 370, height: UIScreen.main.bounds.width > 1000 ? 350 : 228)
                        }
                    }
                    .offset(y: -25)
                
                Spacer()
            }
            .padding(.top)
            
            ZStack(alignment: .bottomLeading) {
                Image(.rectGalact)
                    .resizable()
                    .opacity(0)
                
                Image("plinkoPerson")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 208, height: 248)
                    .offset(x: -0, y: -60)
                
                Image(.rectGalact)
                    .resizable()
                    .scaleEffect(y: -1)
                    .overlay {
                        HStack {
                            HStack(spacing: 15) {
                                Button(action: {
                                    withAnimation {
                                        gameModel.decreaseBet()
                                    }
                                }) {
                                    Circle()
                                        .fill(LinearGradient(colors: [Color(red: 69/255, green: 0/255, blue: 152/255),
                                                                      Color(red: 43/255, green: 0/255, blue: 63/255)], startPoint: .top, endPoint: .bottom))
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 24)
                                                .stroke(.white, lineWidth: 2)
                                                .overlay {
                                                    Text("-")
                                                        .font(.custom("PaytoneOne-Regular", size: 36))
                                                        .foregroundStyle(Color(red: 253/255, green: 255/255, blue: 193/255))
                                                        .offset(y: -6)
                                                }
                                        }
                                        .frame(width: 43, height: 43)
                                }
                                .opacity(viewModel.bet <= 100 ? 0.5 : 1)
                                .disabled(viewModel.bet <= 100 ? true : false)
                                
                                VStack(spacing: 0) {
                                    Text("BET:")
                                        .font(.custom("PaytoneOne-Regular", size: 16))
                                        .foregroundStyle(Color(red: 253/255, green: 255/255, blue: 193/255))
                                    
                                    Text("\(viewModel.bet)")
                                        .font(.custom("PaytoneOne-Regular", size: 16))
                                        .foregroundStyle(Color(red: 253/255, green: 255/255, blue: 193/255))
                                }
                                
                                Button(action: {
                                    withAnimation {
                                        gameModel.increaseBet()
                                    }
                                }) {
                                    Circle()
                                        .fill(LinearGradient(colors: [Color(red: 69/255, green: 0/255, blue: 152/255),
                                                                      Color(red: 43/255, green: 0/255, blue: 63/255)], startPoint: .top, endPoint: .bottom))
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 24)
                                                .stroke(.white, lineWidth: 2)
                                                .overlay {
                                                    Text("+")
                                                        .font(.custom("PaytoneOne-Regular", size: 36))
                                                        .foregroundStyle(Color(red: 253/255, green: 255/255, blue: 193/255))
                                                        .offset(y: -6)
                                                }
                                        }
                                        .frame(width: 43, height: 43)
                                }
                                .opacity(viewModel.bet <= (viewModel.coin - 50) ? 1 : 0.5)
                                .disabled(viewModel.bet <= (viewModel.coin - 50) ? false : true)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                withAnimation {
                                       gameModel.dropBalls()
                                   }
                            }) {
                                Image(.dropPlinko)
                                    .resizable()
                                    .frame(width: 148, height: 57)
                            }
                            .offset(y: -20)
                            
                            Spacer()
                            
                            Button(action: {
                                withAnimation {
                                    viewModel.bet = viewModel.coin
                                }
                            }) {
                                Image(.maxPlinko)
                                    .resizable()
                                    .frame(width: 143, height: 55)
                            }
                            .opacity(viewModel.bet == viewModel.coin ? 0.5 : 1)
                            .disabled(viewModel.bet != viewModel.coin ? false : true)
                        }
                        .padding(.horizontal, 30)
                    }
                    .frame(height: 80)
            }
            .ignoresSafeArea()
            
            if viewModel.win >= 2000 {
                Color.black.opacity(0.8).ignoresSafeArea()
                Color.yellow.opacity(0.25).ignoresSafeArea()
                
                ZStack(alignment: .bottomLeading) {
                    HStack(spacing: 0) {
                        Image(.coins1)
                            .resizable()
                            .scaleEffect(x: -1)
                        
                        Image(.coins2)
                            .resizable()
                            .scaleEffect(x: -1)
                    }
                 
                    Image("plinkoPerson")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 308, height: 348)
                        .offset(y: 30)
                }
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    Image(.winQueen)
                        .resizable()
                        .frame(width: 358, height: 223)
                    
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(LinearGradient(colors: [Color(red: 69/255, green: 0/255, blue: 152/255),
                                                          Color(red: 43/255, green: 0/255, blue: 63/255)], startPoint: .top, endPoint: .bottom))
                            .overlay {
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(.white)
                                    .overlay {
                                        Text("+\(viewModel.win)")
                                            .font(.custom("PaytoneOne-Regular", size: 40))
                                            .foregroundStyle(Color(red: 253/255, green: 255/255, blue: 193/255))
                                            .offset(x: 8, y: -1)
                                    }
                            }
                            .frame(width: 243, height: 57)
                            .cornerRadius(24)
                        
                        Image(.coin)
                            .resizable()
                            .frame(width: 82, height: 82)
                            .offset(x: -15)
                    }
                    
                    Button(action: {
                        withAnimation {
                            viewModel.win = 0
                        }
                    }) {
                        Image(.clainGalact)
                            .resizable()
                            .frame(width: 148, height: 57)
                    }
                }
            }
        }
    }
}

#Preview {
    PlinkoView()
}


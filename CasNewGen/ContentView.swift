import SwiftUI

struct ContentView: View {
    @State var isSlots = true
    @State var selectedIndex = 0
    @State var showAlert = false
    @State var showSettings = false
    @State var slot1 = false
    @State var slot2 = false
    @State var slot3 = false
    @State var slot4 = false
    @State var slot5 = false
    @State var crash1 = false
    @State var crash2 = false
    @State var crash3 = false
    @State var coins = UserDefaultsManager.shared.coins
    
    var body: some View {
        ZStack {
            ZStack(alignment: .top) {
                Image(.bg)
                    .resizable()
                
                Image(.rectCstm)
                    .resizable()
                    .frame(height: UIScreen.main.bounds.width > 1000 ? 120 : 80)
            }
            .ignoresSafeArea()
            
            VStack {
                HStack {
                    Button(action: {
                        showSettings = true
                    }) {
                        Image(.sett)
                            .resizable()
                            .frame(width: 49, height: 49)
                    }
                    
                    
                    Spacer()
                    
                    Image(!isSlots ? .instantLabel : .chooseGame)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 220, height: 50)
                        .padding(.leading, 51)
                    
                    Spacer()
                    
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(LinearGradient(colors: [Color(red: 152/255, green: 0/255, blue: 3/255),
                                                          Color(red: 62/255, green: 0/255, blue: 0/255)], startPoint: .top, endPoint: .bottom))
                            .overlay {
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(.white)
                                    .overlay {
                                        Text("\(coins)")
                                            .font(.custom("PaytoneOne-Regular", size: 20))
                                            .foregroundStyle(Color(red: 253/255, green: 255/255, blue: 193/255))
                                            .offset(x: 8, y: -1)
                                    }
                            }
                            .frame(width: 100, height: 33)
                            .cornerRadius(24)
                        
                        Image(.coin)
                            .resizable()
                            .frame(width: 43, height: 45)
                            .offset(x: -15)
                    }
                }
                
                Spacer()
                
                VStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 25) {
                            if isSlots {
                                ForEach(0..<9, id: \.self) { index in
                                    Button(action: {
                                        if index <= 4 {
                                            selectedIndex = index
                                        }
                                    }) {
                                        if index >= 5 {
                                            ZStack {
                                                Image("slot\(index + 1)")
                                                    .resizable()
                                                    .frame(width: UIScreen.main.bounds.width > 1000 ? 250 : 150, height: UIScreen.main.bounds.width > 1000 ? 250 : 150)
                                                    .opacity(selectedIndex == index ? 0.5 : 1)
                                                    .blur(radius: index >= 5 ? 5 : 0)
                                                    .cornerRadius(index >= 5 ? 10 : 0)
                                                
                                                VStack(spacing: 60) {
                                                    ZStack(alignment: .leading) {
                                                        Rectangle()
                                                            .fill(LinearGradient(colors: [Color(red: 152/255, green: 0/255, blue: 3/255),
                                                                                          Color(red: 62/255, green: 0/255, blue: 0/255)], startPoint: .top, endPoint: .bottom))
                                                            .overlay {
                                                                RoundedRectangle(cornerRadius: 24)
                                                                    .stroke(.white)
                                                                    .overlay {
                                                                        Text("100000")
                                                                            .font(.custom("PaytoneOne-Regular", size: 14))
                                                                            .foregroundStyle(Color(red: 253/255, green: 255/255, blue: 193/255))
                                                                            .offset(x: 8, y: -1)
                                                                    }
                                                            }
                                                            .frame(width: 100, height: 33)
                                                            .cornerRadius(24)
                                                        
                                                        Image(.coin)
                                                            .resizable()
                                                            .frame(width: 43, height: 45)
                                                            .offset(x: -15)
                                                    }
                                                    
                                                    Button(action: {
                                                        showAlert = true
                                                    }) {
                                                        Image(.buy)
                                                            .resizable()
                                                            .frame(width: 106, height: 50)
                                                    }
                                                    .alert("Not enough coins", isPresented: $showAlert) {
                                                        Button("OK") {
                                                            
                                                        }
                                                    }
                                                }
                                            }
                                        } else {
                                            Image("slot\(index + 1)")
                                                .resizable()
                                                .frame(width: UIScreen.main.bounds.width > 1000 ? 250 : 150, height: UIScreen.main.bounds.width > 1000 ? 250 : 150)
                                                .opacity(selectedIndex == index ? 0.5 : 1)
                                                .blur(radius: index >= 5 ? 5 : 0)
                                                .cornerRadius(index >= 5 ? 10 : 0)
                                        }
                                    }
                                }
                            } else {
                                ForEach(0..<3, id: \.self) { index in
                                    Button(action: {
                                        selectedIndex = index
                                    }) {
                                        Image("crash\(index + 1)")
                                            .resizable()
                                            .frame(width: UIScreen.main.bounds.width > 1000 ? 250 : 150, height: UIScreen.main.bounds.width > 1000 ? 250 : 150)
                                            .opacity(selectedIndex == index ? 0.5 : 1)
                                            .blur(radius: index >= 5 ? 5 : 0)
                                            .cornerRadius(index >= 5 ? 10 : 0)
                                    }
                                    .disabled(index >= 5)
                                }
                            }
                        }
                        .padding(.leading, 200)
                    }
                    
                    Button(action: {
                        if isSlots {
                            switch selectedIndex {
                            case 0: slot1 = true
                            case 1: slot2 = true
                            case 2: slot3 = true
                            case 3: slot4 = true
                            case 4: slot5 = true
                            default: slot1 = true
                            }
                        } else {
                            switch selectedIndex {
                            case 0: crash1 = true
                            case 1: crash2 = true
                            case 2: crash3 = true
                            default: crash1 = true
                            }
                        }
                    }) {
                        Image(.playBtn)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 159, height: 60)
                    }
                    .padding(.top, 10)
                }
                .padding(.bottom, 40)
                
                Spacer()
            }
            .padding(.top)
            
            ZStack(alignment: .bottomLeading) {
                Image(.bg)
                    .resizable()
                    .opacity(0)
                
                Image(isSlots ? "person\(selectedIndex + 1)" : "personCrash\(selectedIndex + 1)")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 288, height: 308)
                
                Image(.rectCstm)
                    .resizable()
                    .scaleEffect(y: -1)
                    .overlay {
                        HStack {
                            Spacer()
                            
                            Button(action: {
                                withAnimation {
                                    selectedIndex = 0
                                    isSlots.toggle()
                                }
                            }) {
                                Image(.changeGame)
                                    .resizable()
                                    .overlay {
                                        VStack(spacing: -5) {
                                            Text(isSlots ? "SLOT" : "INSTANT")
                                                .font(.custom("PaytoneOne-Regular", size: 12))
                                                .foregroundStyle(Color(red: 253/255, green: 255/255, blue: 193/255))
                                            Text("GAMES")
                                                .font(.custom("PaytoneOne-Regular", size: 12))
                                                .foregroundStyle(Color(red: 253/255, green: 255/255, blue: 193/255))
                                        }
                                    }
                                    .frame(width: 127, height: 50)
                            }
                            .padding(.horizontal, 30)
                        }
                    }
                    .frame(height: 80)
            }
            .ignoresSafeArea()
        }
        .onAppear() {
            NotificationCenter.default.addObserver(forName: Notification.Name("UserResourcesUpdated"), object: nil, queue: .main) { _ in
                coins = UserDefaultsManager.shared.coins
            }
        }
        .fullScreenCover(isPresented: $showSettings) {
            SettingsView()
        }
        .fullScreenCover(isPresented: $slot1) {
            TrickesterSlotView()
        }
        .fullScreenCover(isPresented: $slot2) {
            QuinSlotView()
        }
        .fullScreenCover(isPresented: $slot3) {
            JockerSlotView()
        }
        .fullScreenCover(isPresented: $slot4) {
            ArcaneSlotsView()
        }
        .fullScreenCover(isPresented: $slot5) {
            IntergalacSlotView()
        }
        .fullScreenCover(isPresented: $crash1) {
            HeadOrTailView()
        }
        .fullScreenCover(isPresented: $crash2) {
            WheelView()
        }
        .fullScreenCover(isPresented: $crash3) {
            PlinkoView()
        }
    }
}

#Preview {
    ContentView()
}

import SwiftUI

struct QuinSlotView: View {
    @StateObject var viewModel =  QuinSlotViewModel()
    @State var isInfo = false
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack {
            ZStack(alignment: .top) {
                Image(.bg)
                    .resizable()
                
                Image(.rectCstm)
                    .resizable()
                    .frame(height: UIScreen.main.bounds.width > 1000 ? 120 : 95)
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
                                    .fill(LinearGradient(colors: [Color(red: 152/255, green: 0/255, blue: 3/255),
                                                                  Color(red: 62/255, green: 0/255, blue: 0/255)], startPoint: .top, endPoint: .bottom))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 24)
                                            .stroke(.white)
                                            .overlay {
                                                Text("\(viewModel.bet)")
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
                                    .fill(LinearGradient(colors: [Color(red: 152/255, green: 0/255, blue: 3/255),
                                                                  Color(red: 62/255, green: 0/255, blue: 0/255)], startPoint: .top, endPoint: .bottom))
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
                                    .fill(LinearGradient(colors: [Color(red: 152/255, green: 0/255, blue: 3/255),
                                                                  Color(red: 62/255, green: 0/255, blue: 0/255)], startPoint: .top, endPoint: .bottom))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 24)
                                            .stroke(.white)
                                            .overlay {
                                                Text("\(viewModel.coin)")
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
                  
                    Button(action: {
                        isInfo = true
                    }) {
                        Image(.help)
                            .resizable()
                            .frame(width: 49, height: 49)
                    }
                }
                
                Spacer()
                
                VStack {
                    Image(.descQueen)
                        .resizable()
                        .overlay {
                            VStack(spacing: 5) {
                                ForEach(0..<3, id: \.self) { row in
                                    HStack(spacing: 27) {
                                        ForEach(0..<5, id: \.self) { col in
                                            Image(.queenBack)
                                                .resizable()
                                                .overlay {
                                                    RoundedRectangle(cornerRadius: 14)
                                                        .stroke(Color.yellow, lineWidth: 1)
                                                        .overlay(
                                                            Image(viewModel.slots[row][col])
                                                                .resizable()
                                                                .aspectRatio(contentMode: .fit)
                                                                .frame(width: 40, height: 40)
                                                        )
                                                }
                                                .frame(width: 55, height: 55)
                                                .cornerRadius(14)
                                                .padding(.horizontal, 5)
                                                .shadow(
                                                    color: viewModel.winningPositions.contains(where: { $0.row == row && $0.col == col }) ? Color.yellow : .clear,
                                                    radius: viewModel.isSpinning ? 0 : 25
                                                )
                                        }
                                    }
                                }
                            }
                        }
                        .frame(width: 478, height: 240)
                        .offset(y: -15)
                }
                
                Spacer()
            }
            .padding(.top)
            
            ZStack(alignment: .bottomLeading) {
                Image(.bg)
                    .resizable()
                    .opacity(0)
                
                Image("person2")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 208, height: 248)
                    .offset(x: -10, y: -30)
                
                Image(.rectCstm)
                    .resizable()
                    .scaleEffect(y: -1)
                    .overlay {
                        HStack {
                            HStack(spacing: 15) {
                                Button(action: {
                                    withAnimation {
                                        if viewModel.bet >= 100 {
                                            viewModel.bet -= 50
                                        }
                                    }
                                }) {
                                    Circle()
                                        .fill(LinearGradient(colors: [Color(red: 152/255, green: 0/255, blue: 3/255),
                                                                      Color(red: 62/255, green: 0/255, blue: 0/255)], startPoint: .top, endPoint: .bottom))
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
                                        if viewModel.bet <= (viewModel.coin - 50) {
                                            viewModel.bet += 50
                                        }
                                    }
                                }) {
                                    Circle()
                                        .fill(LinearGradient(colors: [Color(red: 152/255, green: 0/255, blue: 3/255),
                                                                      Color(red: 62/255, green: 0/255, blue: 0/255)], startPoint: .top, endPoint: .bottom))
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
                                    if viewModel.coin >= viewModel.bet {
                                        viewModel.spin()
                                    }
                                }
                            }) {
                                Image(.spinQueen)
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
                                Image(.maxBetQueen)
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
            
            if isInfo {
                Color.black.opacity(0.7).ignoresSafeArea()
                
                VStack {
                    HStack {
                        Button(action: {
                            isInfo.toggle()
                        }) {
                            Image(.back)
                                .resizable()
                                .frame(width: 49, height: 49)
                        }
                        
                        Spacer()
                    }
                    .padding(.top, 20)
                    
                    Image(.infoQueen)
                        .resizable()
                        .frame(width: 531, height: 284)
                    
                    Spacer()
                }
            }
            
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
                 
                    Image("person2")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 308, height: 348)
                }
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    Image(.winQueen)
                        .resizable()
                        .frame(width: 358, height: 223)
                    
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(LinearGradient(colors: [Color(red: 152/255, green: 0/255, blue: 3/255),
                                                          Color(red: 62/255, green: 0/255, blue: 0/255)], startPoint: .top, endPoint: .bottom))
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
                        Image(.clainQueen)
                            .resizable()
                            .frame(width: 148, height: 57)
                    }
                }
            }
        }
    }
}

#Preview {
    QuinSlotView()
}


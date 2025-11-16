import SwiftUI

struct HeadOrTailView: View {
    @StateObject var viewModel =  HeadOrTailViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State var isTail = false
    
    var body: some View {
        ZStack {
            ZStack(alignment: .top) {
                Image(.bgFlip)
                    .resizable()
                
                Image(.rectFlip)
                    .resizable()
                    .frame(height: UIScreen.main.bounds.width > 1000 ? 115 : 95)
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
                                    .fill(LinearGradient(colors: [Color(red: 67/255, green: 152/255, blue: 0/255),
                                                                  Color(red: 14/255, green: 63/255, blue: 0/255)], startPoint: .top, endPoint: .bottom))
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
                                    .fill(LinearGradient(colors: [Color(red: 67/255, green: 152/255, blue: 0/255),
                                                                  Color(red: 14/255, green: 63/255, blue: 0/255)], startPoint: .top, endPoint: .bottom))
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
                                    .fill(LinearGradient(colors: [Color(red: 67/255, green: 152/255, blue: 0/255),
                                                                  Color(red: 14/255, green: 63/255, blue: 0/255)], startPoint: .top, endPoint: .bottom))
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
                }
                
                Spacer()
                
                Image(.backFlip)
                    .resizable()
                    .frame(width: 373, height: 258)
                    .overlay {
                        VStack {
                            Image(viewModel.rotationStep % 2 == 0 ? .headFlip : .tailFlip)
                                .resizable()
                                .frame(width: 86, height: 86)
                                .rotation3DEffect(
                                    .degrees(Double(viewModel.rotationStep) * 360.0 / 2),
                                    axis: (x: 0, y: 1, z: 0)
                                )
                                .animation(.easeInOut(duration: 0.1), value: viewModel.rotationStep)
                                .padding(.top)
                            
                            HStack(spacing: 30) {
                                Button(action: {
                                    withAnimation {
                                        isTail = false
                                    }
                                }) {
                                    Rectangle()
                                        .fill(.clear)
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 15)
                                                .stroke(Color(red: 255/255, green: 215/255, blue: 0/255), lineWidth: 3)
                                                .overlay {
                                                    VStack(spacing: 0) {
                                                        Image(.headFlip)
                                                            .resizable()
                                                            .frame(width: 46, height: 46)
                                                        
                                                        Text("Heads")
                                                            .font(.custom("PaytoneOne-Regular", size: 16))
                                                            .foregroundStyle(Color(red: 255/255, green: 215/255, blue: 0/255))
                                                    }
                                                }
                                        }
                                        .frame(height: 83)
                                        .shadow(color: isTail ? .clear : Color(red: 199/255, green: 168/255, blue: 106/255), radius: 4)
                                }
                                
                                Button(action: {
                                    withAnimation {
                                        isTail = true
                                    }
                                }) {
                                    Rectangle()
                                        .fill(.clear)
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 15)
                                                .stroke(Color(red: 255/255, green: 215/255, blue: 0/255), lineWidth: 3)
                                                .overlay {
                                                    VStack(spacing: 0) {
                                                        Image(.tailFlip)
                                                            .resizable()
                                                            .frame(width: 46, height: 46)
                                                        
                                                        Text("Tails")
                                                            .font(.custom("PaytoneOne-Regular", size: 16))
                                                            .foregroundStyle(Color(red: 255/255, green: 215/255, blue: 0/255))
                                                    }
                                                }
                                        }
                                        .frame(height: 83)
                                        .shadow(color: !isTail ? .clear : Color(red: 199/255, green: 168/255, blue: 106/255), radius: 4)
                                }
                            }
                            .padding(.horizontal, 50)
                            .padding(.top)
                            
                            Spacer()
                        }
                    }
                
                Spacer()
            }
            .padding(.top)
            
            ZStack(alignment: .bottomLeading) {
                Image(.bg)
                    .resizable()
                    .opacity(0)
                
                Image("personFlip")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 208, height: 248)
                    .offset(x: -10, y: -60)
                
                Image(.rectFlip)
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
                                        .fill(LinearGradient(colors: [Color(red: 67/255, green: 152/255, blue: 0/255),
                                                                      Color(red: 14/255, green: 63/255, blue: 0/255)], startPoint: .top, endPoint: .bottom))
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
                                        .fill(LinearGradient(colors: [Color(red: 67/255, green: 152/255, blue: 0/255),
                                                                      Color(red: 14/255, green: 63/255, blue: 0/255)], startPoint: .top, endPoint: .bottom))
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
                                    viewModel.startFlip(userChoice: isTail)
                                   }
                            }) {
                                Image(.flipFlip)
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
                                Image(.maxFlip)
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
        }
    }
}

#Preview {
    HeadOrTailView()
}


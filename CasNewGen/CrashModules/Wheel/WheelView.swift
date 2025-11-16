import SwiftUI

struct WheelView: View {
    @StateObject var viewModel =  WheelViewModel()
    @State private var showAlert = false
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack {
            ZStack(alignment: .top) {
                Image(.bg)
                    .resizable()
                
                Image(.rectCstm)
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
                }
                
                Spacer()
                
                VStack {
                    HStack {
                        Spacer()
                        
                        ZStack {
                            ZStack {
                                Circle()
                                    .stroke(lineWidth: 5)
                                    .foregroundColor(Color(red: 212/255, green: 175/255, blue: 56/255))
                                
                                Circle()
                                    .stroke(lineWidth: 10)
                                    .foregroundColor(.clear)
                                
                                ForEach(viewModel.segments.indices) { i in
                                    let segmentCount = viewModel.segments.count
                                    let segmentAngle = 360.0 / Double(segmentCount)
                                    let midAngle = Double(i) * segmentAngle + segmentAngle / 2 - 90
                                    
                                    SectorShape(
                                        startAngle: Angle(degrees: Double(i) * segmentAngle),
                                        endAngle: Angle(degrees: Double(i + 1) * segmentAngle)
                                    )
                                    .fill(viewModel.segments[i].color)
                                    .overlay(
                                        Text(viewModel.segments[i].title)
                                            .font(.custom("PaytoneOne-Regular", size: 12))
                                            .foregroundStyle(Color(red: 253/255, green: 255/255, blue: 193/255))
                                            .rotationEffect(Angle(degrees: midAngle + viewModel.rotationDegree))
                                            .position(
                                                x: 90 + 50 * CGFloat(cos(midAngle * .pi / 180)),
                                                y: 90 + 60 * CGFloat(sin(midAngle * .pi / 180))
                                            )
                                    )
                                    .onTapGesture {
                                        viewModel.selectedSegmentIndex = i
                                    }
                                }
                            }
                            .frame(width: 180, height: 180)
                            .rotationEffect(Angle(degrees: viewModel.rotationDegree))
                            
                            Triangle()
                                .fill(Color(red: 231/255, green: 201/255, blue: 104/255))
                                .scaleEffect(y: -1)
                                .frame(width: 20, height: 25)
                                .offset(y: -90)
                        }
//                        .padding(.trailing, 50)
                        .offset(y: -15)
                        .alert("Attention", isPresented: $showAlert, actions: {
                            Button("OK", role: .cancel) {}
                        }, message: {
                            Text(viewModel.selectedSegmentIndex == nil ? "Please select a segment before spinning." : "Please set a valid bet amount.")
                        })
                        
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
                
                Image("wheelPerson")
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
                                    if viewModel.selectedSegmentIndex == nil {
                                        showAlert = true
                                    } else if viewModel.bet <= 0 {
                                        showAlert = true
                                    } else {
                                        viewModel.spinWheel()
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
                    
                    Image("wheelPerson")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 338, height: 378)
                        .offset(y: 60)
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
    WheelView()
}

struct SectorShape: Shape {
    var startAngle: Angle
    var endAngle: Angle
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        path.move(to: center)
        path.addArc(center: center,
                    radius: rect.width/2,
                    startAngle: startAngle - Angle(degrees: 90),
                    endAngle: endAngle - Angle(degrees: 90),
                    clockwise: false)
        path.closeSubpath()
        return path
    }
}

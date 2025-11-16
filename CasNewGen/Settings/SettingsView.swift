import SwiftUI

struct SettingsView: View {
    @StateObject var settingsModel =  SettingsViewModel()
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack {
            ZStack(alignment: .top) {
                Image(.bg)
                    .resizable()
                
                Image(.rectCstm)
                    .resizable()
                    .frame(height: UIScreen.main.bounds.width > 1000 ? 110 : 80)
            }
            .ignoresSafeArea()
            
            VStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(.back)
                            .resizable()
                            .frame(width: 49, height: 49)
                    }
                    
                    Spacer()
                    
                    Image(.settLabel)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 220, height: 45)
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
                                        Text("6500")
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
                    Image(.settBack)
                        .resizable()
                        .overlay {
                            VStack(spacing: 30) {
                                HStack {
                                    Image(.music)
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                    
                                    VStack(alignment: .leading) {
                                        Text("Sound Effects")
                                            .font(.custom("PaytoneOne-Regular", size: 16))
                                            .foregroundStyle(Color(red: 255/255, green: 215/255, blue: 0/255))
                                        
                                        Text("Game audio and effects")
                                            .font(.custom("PaytoneOne-Regular", size: 14))
                                            .foregroundStyle(Color(red: 255/255, green: 215/255, blue: 0/255).opacity(0.6))
                                    }
                                    .padding(.leading, 10)
                                    
                                    Spacer()
                                    
                                    Toggle("", isOn: $settingsModel.isSound)
                                        .toggleStyle(CustomToggleStyle())
                                        .frame(width: 48)
                                }
                                
                                HStack {
                                    Image(.music)
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                    
                                    VStack(alignment: .leading) {
                                        Text("Music")
                                            .font(.custom("PaytoneOne-Regular", size: 16))
                                            .foregroundStyle(Color(red: 255/255, green: 215/255, blue: 0/255))
                                        
                                        Text("Background music")
                                            .font(.custom("PaytoneOne-Regular", size: 14))
                                            .foregroundStyle(Color(red: 255/255, green: 215/255, blue: 0/255).opacity(0.6))
                                    }
                                    .padding(.leading, 10)
                                    
                                    Spacer()
                                    
                                    Toggle("", isOn: $settingsModel.isMsuic)
                                        .toggleStyle(CustomToggleStyle())
                                        .frame(width: 48)
                                }
                            }
                            .padding(.horizontal, 40)
                        }
                        .frame(width: 714, height: 180)
                    
//                    Button(action: {
//                        
//                    }) {
//                        Image(.saveBtn)
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: 159, height: 60)
//                    }
//                    .padding(.top, 10)
                }
                
                Spacer()
            }
            .padding(.top)
        }
    }
}

#Preview {
    SettingsView()
}

struct CustomToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            RoundedRectangle(cornerRadius: 16)
                .fill(configuration.isOn ? .white : Color(red: 255/255, green: 215/255, blue: 0/255))
                .frame(width: 32, height: 18)
                .overlay(
                    Circle()
                        .fill(configuration.isOn ? Color(red: 255/255, green: 215/255, blue: 0/255) : .white)
                        .frame(width: 16, height: 16)
                        .offset(x: configuration.isOn ? 6 : -6)
                        .animation(.easeInOut, value: configuration.isOn)
                )
                .onTapGesture {
                    configuration.isOn.toggle()
                }
        }
    }
}

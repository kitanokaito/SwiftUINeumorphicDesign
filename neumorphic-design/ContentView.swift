import SwiftUI

struct ContentView: View {
  @State var darkmode = false
  @State var percentage1: Double = 30
  @State var percentage2: Double = 20
  @State var percentage3: Double = 80
  
  var body: some View {
    ZStack {
      Color("MainColor")
      
      VStack(spacing: 0) {
        // ボタン
        HStack(spacing: 0) {
          Spacer()
          Button(action: {
            self.darkmode.toggle()
          }) {
            Image(systemName: "sun.min.fill")
              .resizable()
              .frame(width: 30, height: 30)
          }
          .buttonStyle(NeuromorphicButtonStyle())
        }
        .padding(.horizontal, 30)
        
        // タイトル
        Text("Neuromorphic Design")
          .font(.system(size: 30, weight: .medium, design: .serif))
          .gradientForeground(colors: [Color.blue, Color.purple])
          .padding(.top, 100)
          .padding(.bottom, 50)
        
        // ニューメニックバー
        HStack(spacing: 30) {
          SliderBarAndButton(percent: self.$percentage1, buttomImageName: "cloud.fill")
          SliderBarAndButton(percent: self.$percentage2, buttomImageName: "moon.fill")
          SliderBarAndButton(percent: self.$percentage3, buttomImageName: "hurricane")
        }
        
        
        Spacer()
      }
      .padding(.top, 50)
    }
    .edgesIgnoringSafeArea(.all)
    .environment(\.colorScheme, self.darkmode ? .dark : .light)
  }
}

struct SliderBarAndButton: View {
  @Binding var percent: Double
  @State var barHeight: CGFloat = 0
  let buttomImageName: String
  
  var body: some View {
    VStack(spacing: 0) {
      GeometryReader { geo in
        ZStack(alignment: .bottom) {
          // 背景カプセル
          Capsule()
            .frame(width: 40, height: 200)
            .modifier(Neuromorphic())
          
          // 色付きカプセル
          Capsule()
            .fill(
              LinearGradient(
                gradient: .init(colors: [Color.blue, Color.purple]),
                startPoint: .top,
                endPoint: .bottom
              )
          )
            .frame(
              width: 40,
              height: self.barHeight
          )
            .gesture(
              DragGesture(minimumDistance: 0)
                .onChanged(
                  { value in
                    let sliderPos = min(max(self.barHeight - value.translation.height, 40), geo.size.height)
                    self.barHeight = sliderPos
                  }
              )
          )
        }
      }
      .frame(width: 40, height: 200)
      .padding(.bottom, 30)
      
      Button(action: {}) {
        Image(systemName: buttomImageName)
          .resizable()
          .foregroundColor(Color.gray)
          .frame(width: 20, height: 20)
      }
      .buttonStyle(NeuromorphicButtonStyle())
    }
    .onAppear() {
      self.barHeight = CGFloat(1.6 * self.percent + 40)
    }
  }
}

extension View {
  public func gradientForeground(colors: [Color]) -> some View {
    self.overlay(
      LinearGradient(
        gradient: .init(colors: colors),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
      )
    )
      .mask(self)
  }
}

struct Neuromorphic: ViewModifier {
  func body(content: Content) -> some View {
    content
      .foregroundColor(Color("MainColor"))
      .shadow(color: Color("TopLeftShadow"), radius: 5, x: -6, y: -6)
      .shadow(color: Color("BottomRightShadow"), radius: 5, x: 6, y: 6)
  }
}

struct NeuromorphicTaped: ViewModifier {
  func body(content: Content) -> some View {
    content
      .foregroundColor(Color("MainColor"))
      .overlay(
        Circle()
          .stroke(Color("TopLeftShadow"), lineWidth: 4)
          .blur(radius: 4)
          .offset(x: 2, y: 2)
          .mask(
            Circle().fill(
              LinearGradient(
                gradient: Gradient(colors: [Color.clear, Color("TopLeftShadow")]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
              )
            )
        )
    )
      .overlay(
        Circle()
          .stroke(Color("BottomRightShadow"), lineWidth: 8)
          .blur(radius: 4)
          .offset(x: -2, y: -2)
          .mask(Circle().fill(
            LinearGradient(
              gradient: Gradient(colors: [Color("BottomRightShadow"), Color.clear]),
              startPoint: .topLeading,
              endPoint: .bottomTrailing
            )
            )
        )
    )
  }
}

struct NeuromorphicButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .padding(20)
      .contentShape(Circle())
      .background(
        Group {
          if (configuration.isPressed) {
            Circle()
              .modifier(NeuromorphicTaped())
          } else {
            Circle()
              .modifier(Neuromorphic())
          }
        }
    )
  }
}

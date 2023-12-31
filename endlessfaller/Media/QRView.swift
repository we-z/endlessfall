//
//  QRView.swift
//  Fall Ball
//
//  Created by Wheezy Salem on 9/2/23.
//

import SwiftUI

struct QRView: View {
    var body: some View {
        ZStack{
            VStack(spacing: 0){
                Rectangle()
                    .foregroundColor(.blue)
                Rectangle()
                    .overlay(Color(hex: "e31937ff"))
            }
            
            CharacteresFallingView()
            
            Image("fallballQR")
                .resizable()
                .frame(width: 300, height: 300)
                .cornerRadius(30)

        }
        .ignoresSafeArea()
    }
}

struct CharacteresFallingView: View {
    func HoleShapeMask(in rect: CGRect) -> Path {
        var shape = Rectangle().path(in: rect)
        shape.addPath(Circle().path(in: rect))
        return shape
    }
    let rect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    var body: some View {
        ZStack{
            ZStack{
                VStack(spacing: 0){
                    Rectangle()
                        .foregroundColor(.blue)
                    Rectangle()
                        .foregroundColor(.red)
                }
//                LaughBallViewFalling()
//                    .offset(x:-160)
//                ShockedBallViewFalling()
//                    .offset(x:120, y: 120)
//                IceSpiceViewFalling()
//                    .offset(x:160)
//                AmericaViewFalling()
//                    .offset(x:-120, y: 120)
//                KaiViewFalling()
//                    .offset(x:-120, y: -120)
//                ChinaViewFalling()
//                    .offset(x:120, y: -120)
                
                Text("FALL")
                    .bold()
                    .italic()
                    .font(.largeTitle)
                    .foregroundColor(.black)
//                    .shadow(color: .black, radius: 0.5, x: -3, y: 3)
                    .scaleEffect(3)
                    .offset(y: -210)
                Text("BALL")
                    .bold()
                    .italic()
                    .font(.largeTitle)
                    .foregroundColor(.black)
//                    .shadow(color: .black, radius: 0.5, x: -3, y: 3)
                    .scaleEffect(3)
                    .offset(y: 210)
                    
                
            }
//            Rectangle()
//                .fill(Color.black)
//                .frame(width: rect.width, height: rect.height)
//                .mask(HoleShapeMask(in: rect).fill(style: FillStyle(eoFill: true)))
            
        }
    }
}

struct AlbertViewFalling: View {
    var body: some View {
        ZStack{
            VStack{
                LinearGradient(
                    colors: [.gray.opacity(0.01), .white],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
            .frame(width: 45, height: 45)
            .offset(x:0, y:-27)
            AlbertView()
        }
    }
}

struct LaughBallViewFalling: View {
    var body: some View {
        ZStack{
            VStack{
                LinearGradient(
                    colors: [.gray.opacity(0.01), .white],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
            .frame(width: 45, height: 45)
            .offset(x:0, y:-27)
            FallBallLaughBall()
        }
    }
}

struct BombBallViewFalling: View {
    var body: some View {
        ZStack{
            VStack{
                LinearGradient(
                    colors: [.gray.opacity(0.01), .white],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
            .frame(width: 45, height: 45)
            .offset(x:0, y:-27)
            BombBallView()
        }
    }
}

struct AmericaViewFalling: View {
    var body: some View {
        ZStack{
            VStack{
                LinearGradient(
                    colors: [.gray.opacity(0.01), .white],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
            .frame(width: 45, height: 45)
            .offset(x:0, y:-27)
            AmericaView()
        }
    }
}

struct ChinaViewFalling: View {
    var body: some View {
        ZStack{
            VStack{
                LinearGradient(
                    colors: [.gray.opacity(0.01), .white],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
            .frame(width: 45, height: 45)
            .offset(x:0, y:-27)
            ChinaView()
        }
    }
}

struct IceSpiceViewFalling: View {
    var body: some View {
        ZStack{
            VStack{
                LinearGradient(
                    colors: [.gray.opacity(0.01), .white],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
            .frame(width: 45, height: 45)
            .offset(x:0, y:-27)
            IceSpiceView()
        }
    }
}

struct IndiaViewFalling: View {
    var body: some View {
        ZStack{
            VStack{
                LinearGradient(
                    colors: [.gray.opacity(0.01), .white],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
            .frame(width: 45, height: 45)
            .offset(x:0, y:-27)
            IndiaView()
        }
    }
}

struct ShockedBallViewFalling: View {
    var body: some View {
        ZStack{
            VStack{
                LinearGradient(
                    colors: [.gray.opacity(0.01), .white],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
            .frame(width: 45, height: 45)
            .offset(x:0, y:-27)
            ShockedBall()
        }
    }
}

struct KaiViewFalling: View {
    var body: some View {
        ZStack{
            VStack{
                LinearGradient(
                    colors: [.gray.opacity(0.01), .white],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
            .frame(width: 45, height: 45)
            .offset(x:0, y:-27)
            KaiView()
        }
    }
}

struct QRView_Previews: PreviewProvider {
    static var previews: some View {
        QRView()
    }
}

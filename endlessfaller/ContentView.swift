//
//  ContentView.swift
//  endlessfaller
//
//  Created by Wheezy Salem on 7/12/23.
//

import SwiftUI
import VTabView
import AudioToolbox
import AVKit

let bestScoreKey = "BestScore"

struct ContentView: View {
    
    @AppStorage(bestScoreKey) var bestScore: Int = UserDefaults.standard.integer(forKey: bestScoreKey)
    @StateObject var model = AppModel()
    @State var score: Int = 0
    @State var highestScoreInGame: Int = 0
    @State var currentScore: Int = 0
    @State var currentIndex: Int = -1
    @State var speed: Double = 2
    @State var isAnimating = false
    @State var gameOver = false
    @State var freezeScrolling = false
    @State var showCharactersMenu = false
    @State var mute = false
    @State var showGameOver = false
    @State var showNewBestScore = false
    
    @State var audioPlayer: AVAudioPlayer!
    
    @State var colors: [Color] = (1...1000).map { _ in
        Color(red: .random(in: 0.3...0.7), green: .random(in: 0.3...0.9), blue: .random(in: 0.3...0.9))
    }
    
    func dropCircle() {
        withAnimation(
            Animation.linear(duration: speed)
        ) {
            isAnimating = true
        }
    }
    
    let impactMed = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        ScrollView {
            ZStack{
                VTabView(selection: $currentIndex) {
                    ZStack{
                        VStack{
                            Spacer()
                            HStack{
                                Button {
                                    mute.toggle()
                                } label: {
                                    Image(systemName: mute ? "speaker.slash" : "speaker.wave.2")
                                        .foregroundColor(.primary)
                                        .font(.largeTitle)
                                        .padding(36)
                                }
                                .onChange(of: mute) { setting in
                                    if setting == true {
                                        self.audioPlayer.setVolume(0, fadeDuration: 0)
                                    } else {
                                        self.audioPlayer.setVolume(1, fadeDuration: 0)
                                    }
                                }
                                Spacer()
                                Button {
                                    showCharactersMenu = true
                                } label: {
                                    Image(systemName: "cart")
                                        .foregroundColor(.primary)
                                        .font(.largeTitle)
                                        .padding(36)
                                }
                            }
                        }
                        if !gameOver {
                            VStack{
                                Text("Swipe up \nto play")
                                    .bold()
                                    .italic()
                                    .multilineTextAlignment(.center)
                                    .padding()
                                Image(systemName: "arrow.up")
                            }
                            .font(.largeTitle)
                            .tag(-1)
                            .blinking()
                        } else {
                            VStack{
                                Text("Game Over!")
                                    .foregroundColor(.red)
                                    .bold()
                                    .font(.system(size: UIScreen.main.bounds.width * 0.12))
                                ZStack{
                                    Rectangle()
                                        .foregroundColor(.primary.opacity(0.05))
                                        .cornerRadius(30)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 30)
                                                .stroke(Color.black, lineWidth: 2)
                                        )
                                    HStack{
                                        VStack{
                                            Text("Ball")
                                                .foregroundColor(.black)
                                                .bold()
                                                .italic()
                                                .font(.title)
                                            let character = model.characters[model.selectedCharacter]
                                            AnyView(character.character)
                                        }
                                        .offset(y: -(UIScreen.main.bounds.height * 0.02))
                                        .padding(.leading, UIScreen.main.bounds.width * 0.12)
                                        Spacer()
                                        VStack(alignment: .trailing){
                                            Spacer()
                                            Text("Score")
                                                .foregroundColor(.blue)
                                                .bold()
                                                .italic()
                                            Text(String(currentScore))
                                            Spacer()
                                            Text("Best")
                                                .foregroundColor(.blue)
                                                .bold()
                                                .italic()
                                            Text(String(bestScore))
                                            Spacer()
                                        }
                                        .padding(.trailing, UIScreen.main.bounds.width * 0.07)
                                        .padding()
                                        .font(.largeTitle)
                                    }
                                }
                                .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.27)
                                
                                VStack{
                                    Text("Swipe up to \nplay again")
                                        .bold()
                                        .italic()
                                        .multilineTextAlignment(.center)
                                        .padding()
                                    Image(systemName: "arrow.up")
                                }
                                .foregroundColor(.primary)
                                .font(.largeTitle)
                                .tag(-1)
                            }
                            .offset(y: UIScreen.main.bounds.height * 0.036)
                        }
                    }
                    let character = model.characters[model.selectedCharacter]
                    ForEach(colors.indices, id: \.self) { index in
                        ZStack{
                            Rectangle()
                                .fill(colors[index])
                            if highestScoreInGame == index {
                                ZStack{
                                    VStack{
                                        LinearGradient(
                                            colors: [.gray.opacity(0.01), .gray.opacity(0.75)],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    }
                                    .frame(width: 46, height: 60)
                                    .offset(x: 0, y:-23)
                                    AnyView(character.character)
                                }
                                .position(x: UIScreen.main.bounds.width/2, y: isAnimating ? UIScreen.main.bounds.height - 23 : -23)
                            }
                            if index == 0{
                                Rectangle()
                                    .frame(width: 100, height: 100)
                                    .foregroundColor(.white)
                                    .position(x: UIScreen.main.bounds.width/2, y: -50)
                            }
                        }
                    }
                }
                .frame(
                    width: UIScreen.main.bounds.width,
                    height: UIScreen.main.bounds.height
                )
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .onChange(of: currentIndex) { newValue in
                    if newValue > 0{
                        gameOver = true
                    }
                    score = newValue
                    if newValue >= highestScoreInGame {
                        highestScoreInGame = newValue
                        if currentIndex < 21 {
                            speed = 2.0 / ((Double(newValue) / 3) + 1)
                        }
                        isAnimating = false
                        dropCircle()
                    }
                    impactMed.impactOccurred()
                    if currentIndex > bestScore && currentIndex > 3 {
                        showNewBestScore = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + speed) {
                        if currentIndex <= newValue && currentIndex != -1 {
                            showNewBestScore = false
                            gameOver = true
                            currentScore = highestScoreInGame
                            if currentScore > bestScore {
                                bestScore = currentScore
                                UserDefaults.standard.set(bestScore, forKey: bestScoreKey)
                            }
                            freezeScrolling = true
                            highestScoreInGame = 0
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                                currentIndex = -1
//                            }
//                            //sleep(1)
//                            DispatchQueue.main.asyncAfter(deadline: .now()) {
//                                currentIndex = -1
//                            }
                            AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) {}
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                                currentIndex = -1
                                self.colors = (1...1000).map { _ in
                                    Color(red: .random(in: 0.3...0.7), green: .random(in: 0.3...0.9), blue: .random(in: 0.3...0.9))
                                }
                                freezeScrolling = false
                            }
                            currentIndex = -1
                        }
                    }
                }
                
                if currentIndex >= 0 {
                    VStack{
                        HStack{
                            Text(String(score))
                                .font(.system(size: 90))
                                .padding(36)
                                .padding(.top, 30)
                            Spacer()
//                            Text(String(speed))
//                                .padding()
                        }
                        Spacer()
                    }
                    .allowsHitTesting(false)
                }
                
                if !showNewBestScore {
                    if currentIndex >= 0 && currentIndex < 2 {
                        KeepSwiping()
                    }
                    
                    if currentIndex > 21 && currentIndex < 33 {
                        KeepGoing()
                    }
                    
                    if currentIndex > 100 && currentIndex < 115 {
                        YourGood()
                    }
                    
                    if currentIndex > 200 && currentIndex < 215 {
                        YourInsane()
                    }
                    
                    if currentIndex > 300 && currentIndex < 315 {
                        GoBerzerk()
                    }
                    
                } else {
                    CelebrationEffect()
                    NewBestScore()
                }
                
                if currentIndex > 315 {
                    VStack{
                        Spacer()
                        BearView()
                    }
                }
                if currentIndex > 115 {
                    ReactionsView()
                        .offset(y: 70)
                }
                
                if currentIndex > 215 {
                    VStack{
                        Spacer()
                        SwiftUIXmasTree2()
                            .padding(.bottom, 90)
                    }
                }
                
                if currentIndex > 33 {
                    VStack{
                        Spacer()
                        HStack{
                            Spacer()
                            SVGCharacterView()
                                .padding([.bottom, .trailing],60)
                        }
                    }
                    .allowsHitTesting(false)
                }
            }
        }
        .sheet(isPresented: self.$showCharactersMenu){
               CharactersMenuView()
        }
        .edgesIgnoringSafeArea(.all)
        .allowsHitTesting(!freezeScrolling)
        .onAppear {
            let sound = Bundle.main.path(forResource: "FallBallOST120", ofType: "mp3")
            self.audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
            self.audioPlayer.numberOfLoops = 1000
            self.audioPlayer.play()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//
//  GenerateRecipeViewController.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 1/18/24.
//

import UIKit
import SwiftUI
import AVFoundation

// MARK: - GenerateRecipeViewController
final class GenerateRecipeViewController: UIViewController {
    
    // MARK: Properties
    
    private var audioPlayer: AVAudioPlayer?
    // MARK: - ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
    }
    
    // MARK: - Private Methods
    
    private func setup() {
        view.backgroundColor = .systemBackground
        addWheelView()
    }
    
    private func addWheelView() {
        let wheelViewWrapper = WheelViewWrapper()
        
        let hostingController = UIHostingController(rootView: wheelViewWrapper)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(hostingController)
        view.addSubview(hostingController.view)
        
        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        hostingController.didMove(toParent: self)
    }
    private func setupAudio() {
        guard let url = Bundle.main.url(forResource: "spinning_sound", withExtension: ".mp3") else { return }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch let error {
            print("Error playing sound. \(error.localizedDescription)")
        }
    }
}

// MARK: - Pie Shape
struct Pie: Shape {
    var startAngle: Angle
    var endAngle: Angle
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let start = CGPoint(
            x: center.x + radius * cos(CGFloat(startAngle.radians)),
            y: center.y + radius * sin(CGFloat(startAngle.radians))
        )
        
        var path = Path()
        path.move(to: center)
        path.addLine(to: start)
        path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        path.addLine(to: center)
        
        return path
    }
}

// MARK: - WheelView
struct WheelView: View {
    
    // MARK: Properties
    
    @State private var spin: Double = 0
    @State private var isSpinning = false
    @State private var recipes = dummyRecipes.map { $0.title }
    @State private var selectedRecipe: DRecipe?
    @State private var showingRecipe = false
    @State private var audioPlayer: AVAudioPlayer?
    
    // MARK: Body
    var body: some View {
    
            VStack {
                
                let uiColors: [UIColor] = [
                    UIColor(red: 0.86, green: 0.58, blue: 0.98, alpha: 1.00),
                    UIColor(red: 0.46, green: 0.87, blue: 0.77, alpha: 1.00),
                    UIColor(red: 0.99, green: 0.58, blue: 0.76, alpha: 1.00),
                    UIColor(red: 0.44, green: 0.76, blue: 0.99, alpha: 1.00),
                    UIColor(red: 1.00, green: 0.80, blue: 0.40, alpha: 1.00),
                    UIColor(red: 0.86, green: 0.58, blue: 0.98, alpha: 1.00),
                    UIColor(red: 0.46, green: 0.87, blue: 0.77, alpha: 1.00),
                    UIColor(red: 0.99, green: 0.58, blue: 0.76, alpha: 1.00),
                    UIColor(red: 0.44, green: 0.76, blue: 0.99, alpha: 1.00),
                    UIColor(red: 1.00, green: 0.80, blue: 0.40, alpha: 1.00)
                ]
                
                let colors: [Color] = uiColors.map { Color($0) }
                
                ZStack {
                    
                    Rectangle()
                        .fill(Color.black.opacity(isSpinning ? 0.5 : 0))
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        VStack {
                            HStack {
                                Text("Not Sure What to Cook?")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(.testColorSet)
                                    .padding()
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.5)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Spacer()
                            }
                            .padding(.top, -30)
                            
                            ZStack {
                                
                                Pie(startAngle: .degrees(0), endAngle: .degrees(360))
                                    .stroke(Color.black, lineWidth: 10)
                                    .shadow(color: .gray, radius: 5, x: 0, y: 0)
                                    .scaleEffect(0.85)
                                Pie(startAngle: .degrees(0), endAngle: .degrees(360))
                                    .stroke(Color.white, lineWidth: 10)
                                    .scaleEffect(0.8)
                                
                                ForEach(0..<colors.count, id: \.self) { index in
                                    Pie(startAngle: .degrees(Double(index) / Double(colors.count) * 360),
                                        endAngle: .degrees(Double(index + 1) / Double(colors.count) * 360))
                                    .fill(colors[index])
                                    .scaleEffect(0.8)
                                }
                                
                                Image("logo")
                                    .resizable()
                                    .frame(width: 75, height: 75)
                                    .offset(y: -0)
                                    .rotationEffect(.degrees(-spin))
                            }
                            .rotationEffect(.degrees(spin))
                            
                            VStack {
                                Image("stopper")
                                    .resizable()
                                    .frame(width: 30, height: 40)
                                    .foregroundColor(.red)
                                    .offset(y: -40)
                            }
                            .rotationEffect(.degrees(0))
                        }
                        .padding()
                        
                        Spacer()
                        
                        Button {
                            withAnimation(.spring(response: 2, dampingFraction: 2)) {
                                spin += 1440
                                isSpinning = true
                                guard let url = Bundle.main.url(forResource: "spinning_sound", withExtension: "mp3") else { return }
                                do {
                                    audioPlayer = try AVAudioPlayer(contentsOf: url)
                                    audioPlayer?.prepareToPlay()
                                    audioPlayer?.play()
                                } catch let error {
                                    print("Error playing sound. \(error.localizedDescription)")
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                                    isSpinning = false
                                    audioPlayer?.stop()
                                    audioPlayer = nil
                                    selectedRecipe = dummyRecipes.randomElement()
                                    showingRecipe = true
                                }
                            }
                        } label: {
                            Text("Spin")
                                .frame(width: 200)
                                .font(.title)
                                .fontWeight(.bold)
                                .padding()
                                .background(Color(red: 134/255, green: 191/255, blue: 62/255, opacity: 1.0))
                                .foregroundColor(.white)
                                .cornerRadius(20)
                        }
                        .padding()
                        .sheet(isPresented: $showingRecipe) {
                            if let recipe = selectedRecipe {
                                DummyRecipeView(recipe: recipe, showingRecipe: $showingRecipe)
                            }
                        
                        }
                        
                    }
                }
            }
        }
    }


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        WheelView()
    }
}

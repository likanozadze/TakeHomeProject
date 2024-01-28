//
//  GenerateRecipeViewController.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 1/18/24.
//

import UIKit
import SwiftUI

final class GenerateRecipeViewController: UIViewController {
    
    
    // MARK: - ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Private Methods
    
    private func setup() {
        view.backgroundColor = UIColor.backgroundColor
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
}

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

struct WheelView: View {
    let colors: [Color] = [.red, .blue, .green, .yellow, .purple, .orange, .pink, .purple, .mint, .red, .blue, .green, .yellow, .purple, .orange]
    
    @State private var spin: Double = 0
    
    var body: some View {
        VStack {
            Text("Don't know what to cook today?")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
                .foregroundColor(.black)
                .cornerRadius(20)
            
            ZStack {
                
                Pie(startAngle: .degrees(0), endAngle: .degrees(360))
                    .stroke(Color.black, lineWidth: 30)
                    .shadow(color: .gray, radius: 5, x: 0, y: 0)
                
                ForEach(0..<colors.count, id: \.self) { index in
                    Pie(startAngle: .degrees(Double(index) / Double(colors.count) * 360),
                        endAngle: .degrees(Double(index + 1) / Double(colors.count) * 360))
                    .fill(colors[index])
                }
                
                Image(systemName: "fork.knife")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.red)
                    .offset(y: 220)
                    .rotationEffect(.degrees(-spin))
                
                Image("logo2")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .offset(y: -0)
                    .rotationEffect(.degrees(-spin))
                
            }
            
            .rotationEffect(.degrees(spin))
            
            Spacer()
            
            Button {
                withAnimation(.spring(response: 2, dampingFraction: 1.5)) {
                    spin += 360
                }
            } label: {
                Text("Spin")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(20)
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        WheelView()
    }
}

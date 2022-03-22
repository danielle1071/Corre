//
//  LaunchView.swift
//  corre
//
//  Created by Mariana Botero on 3/15/22.
//

import SwiftUI
import SDWebImageSwiftUI
import Foundation

struct LaunchView: View {
   
    
    @State var animationFinished: Bool = false
    @State var animationStarted: Bool = false
    @EnvironmentObject var sessionManager: SessionManger
    @State var removeGIF  = false
    
    var body: some View {
        
        ZStack {
            
            
            ZStack
            {
                Color("backgroundColor")
                    .ignoresSafeArea()
                
                Image("footer")
                    .offset(x: 0, y: 300)
                
                if !removeGIF {
                    ZStack (alignment: .center){
                        
                        if animationFinished{
                            Image("finalFrame")
                        }
                        else {
                            AnimatedImage(url: getAnimationURL())
                                .aspectRatio(contentMode: .fit)
                        }
                    }
                    .animation(.none, value: animationFinished)
                }
                
            }
            .opacity(animationFinished ? 0 : 1)
        }
        .onAppear {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                animationStarted = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    animationFinished = true
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    removeGIF = true
                }
            }
            
            
        }
        
    }
    
    func getAnimationURL()->URL {
        let bundle = Bundle.main.path(forResource: "animation", ofType: "gif")
        let url = URL(fileURLWithPath: bundle ?? "")
        
        return url
    }
}
struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}



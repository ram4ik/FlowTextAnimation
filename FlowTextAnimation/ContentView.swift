//
//  ContentView.swift
//  FlowTextAnimation
//
//  Created by ramil on 02.03.2020.
//  Copyright © 2020 com.ri. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "flame")
                .resizable()
                .frame(width: 62, height: 63)
                .modifier(FlowTextModifier(background: Image("flow")))
            
            Text("Flow Text")
                .font(.system(size: 62))
                .bold()
                .modifier(FlowTextModifier(background: Image("flow")))
            
            Image(systemName: "square.and.arrow.down")
                .resizable()
                .frame(width: 62, height: 63)
                .modifier(FlowTextModifier(background: Image("flow")))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

public struct FlowTextModifier: ViewModifier {

    var image: Image
    @State var offset:CGPoint = .zero
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    init(background: Image) {
        self.image = background
    }
    
    public func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geo in
                    ZStack(alignment: .center) {
                        self.image
                            .resizable()
                            .offset(x: self.offset.x - geo.size.width, y: self.offset.y)
                            .mask(content)
                        self.image
                            .resizable()
                            .offset(x: self.offset.x, y: self.offset.y)
                            .mask(content)
                            .onReceive(self.timer) { _ in
                                // Update Offset here
                                let newOffset = self.getNextOffset(size: geo.size, offset: self.offset)

                                if newOffset == .zero {
                                    self.offset = newOffset
                                    withAnimation(.linear(duration: 1)) {
                                        self.offset = self.getNextOffset(size: geo.size, offset: newOffset)
                                    }
                                } else {
                                    withAnimation(.linear(duration: 1)) {
                                        self.offset = newOffset
                                    }
                                }
                            }
                    }
                }
            )
    }
    
    func getNextOffset(size: CGSize, offset: CGPoint) -> CGPoint {
        var nextOffset = offset

        if nextOffset.x + (size.width / 10.0) > size.width {
            nextOffset.x = 0
        } else {
            nextOffset.x += size.width / 10.0
        }
        return nextOffset
    }

}

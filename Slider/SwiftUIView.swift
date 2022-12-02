//
//  SwiftUIView.swift
//  Slider
//
//  Created by cocoa@nenhall on 2022/12/2.
//

import SwiftUI

struct SwiftUIView: View {
    @State var value: CGFloat = 0

    var body: some View {
        Text("SwiftUI 版")
        
        CocoaSlider(value: $value)

        CocoaSlider(value: $value, minValue: 0, maxValue: 10, knobColor: .red) { value in
            print(value)
        }
        
        CocoaSlider(value: $value, onChange: { value in
            print(value)
        })
        
        Slider(value: $value) { value in
//            print(value)
        }
        
        Slider(value: $value)
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView(value: 1)
    }
}

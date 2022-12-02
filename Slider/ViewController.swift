//
//  ViewController.swift
//  Slider
//
//  Created by cocoa@nenhall on 2022/10/11.
//

import Cocoa
import SwiftUI

class ViewController: NSViewController {
    @State var value: CGFloat = 1
    let slider = NSSlider()

    override func viewDidLoad() {
        super.viewDidLoad()

        // AppKit 版
        let slider2 = CocoaSlider(value: $value, minValue: 0, maxValue: 10, trackHeight: 4, knobSize: 10, knobColor: .white, fillColor: .red, backgroundColor: .black) { newValue in
            print(newValue)
        }
        let hview = NSHostingView(rootView: slider2)
        hview.frame = CGRect(x: 20, y: 100, width: 200, height: 30)
        view.addSubview(hview)
        
        slider.frame = CGRect(x: 20, y: 150, width: 200, height: 30)
        slider.cell = CocoaSliderCell(minValue: -10, maxValue: 10, trackHeight: 2, knobSize: 12, style: .doubleSide, fillColor: .red, backgroundColor: .black)
        view.addSubview(slider)
        
        // SwiftUI 版
        let hview2 = NSHostingView(rootView: SwiftUIView(value: value))
        hview2.frame = CGRect(x: 250, y: 220, width: 200, height: 60)
        view.addSubview(hview2)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

}


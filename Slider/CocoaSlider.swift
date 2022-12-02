//
//  CocoaSlider.swift
//  CocoaSlider (macOS)
//
//  Created by cocoa@nenhall on 2022/10/11.
//

import AppKit
import SwiftUI

public let sliderKnobColor = NSColor(red: 0.851, green: 0.851, blue: 0.851, alpha: 1)

public struct CocoaSlider: NSViewRepresentable {
    
    public enum Style {
        case singleSide
        case doubleSide
    }
    
    public typealias OnChangeCallback = ((_ value: CGFloat) -> Void)

    public final class Coordinator: NSObject {
        var value: Binding<CGFloat>
        var onChange: OnChangeCallback?

        public init(value: Binding<CGFloat>, onChange: OnChangeCallback?) {
            self.value = value
            self.onChange = onChange
        }

        @objc func valueChanged(_ sender: NSSlider) {
            value.wrappedValue = sender.doubleValue
            onChange?(value.wrappedValue)
        }
    }

    let trackHeight: CGFloat
    let minValue: CGFloat
    let maxValue: CGFloat
    let style: CocoaSlider.Style
    let onChange: OnChangeCallback?
    
    var knobColor: NSColor = sliderKnobColor
    var fillColor: NSColor = .white
    var backgroundColor: NSColor = .black
    var knobSize: CGFloat = 12
    var value: Binding<CGFloat>
    
    /// Create Slider
    /// - Parameters:
    ///   - trackHeight: 轨道线高，建议 1～4
    ///   - knobSize: 旋扭大小，最大不能超过：21
    public init(value: Binding<CGFloat>,
                minValue: CGFloat = 0.01,
                maxValue: CGFloat = 1,
                trackHeight: CGFloat = 4,
                knobSize: CGFloat = 12,
                style: CocoaSlider.Style = .singleSide,
                knobColor: NSColor = sliderKnobColor,
                fillColor: NSColor = .white,
                backgroundColor: NSColor = .black,
                onChange: OnChangeCallback? = nil) {
                
        self.fillColor = fillColor
        self.trackHeight = trackHeight
        self.knobSize = min(knobSize, 21)
        self.backgroundColor = backgroundColor
        self.value = value
        self.onChange = onChange
        self.minValue = minValue
        self.maxValue = maxValue
        self.knobColor = knobColor
        self.style = style
    }

    public func makeNSView(context: Context) -> NSSlider {
        let slider = NSSlider(frame: .zero)
        slider.cell = CocoaSliderCell(minValue: minValue, maxValue: maxValue, trackHeight: trackHeight, knobSize: knobSize, style: style, knobColor: knobColor, fillColor: fillColor, backgroundColor: backgroundColor)
        slider.target = context.coordinator
        slider.action = #selector(Coordinator.valueChanged(_:))
        return slider
    }

    public func updateNSView(_ nsView: NSSlider, context: Context) {
        let convertValue = value.wrappedValue
        nsView.doubleValue = convertValue
    }

    public func makeCoordinator() -> CocoaSlider.Coordinator {
        Coordinator(value: value, onChange: onChange)
    }
}

public class CocoaSliderCell: NSSliderCell {
    
    let style: CocoaSlider.Style

    var knobColor: NSColor = sliderKnobColor
    var fillColor: NSColor = .white
    var backgroundColor: NSColor = .black
    var trackHeight: CGFloat = 4
    var knobSize: CGFloat = 12
    var delta: CGFloat = 1

    public required init(coder aDecoder: NSCoder) {
        style = .singleSide
        super.init(coder: aDecoder)
    }
    
    /// Create SliderCell
    /// - Parameters:
    ///   - height: 轨道线高，建议 1～4
    ///   - knobDiameter: 旋扭大小，最大不能超过：21
    public init(minValue: CGFloat? = nil, maxValue: CGFloat? = nil, trackHeight: CGFloat, knobSize: CGFloat, style: CocoaSlider.Style = .singleSide, knobColor: NSColor = sliderKnobColor, fillColor: NSColor = .white, backgroundColor: NSColor = .black) {
        self.trackHeight = trackHeight
        self.knobColor = knobColor
        self.fillColor = fillColor
        self.backgroundColor = backgroundColor
        self.knobSize = min(knobSize, 21)
        self.style = style
        if let minValue = minValue, let maxValue = maxValue {
            delta = maxValue - minValue
        }
        super.init()
        if let minValue = minValue {
            self.minValue = minValue
        }
        if let maxValue = maxValue {
            self.maxValue = maxValue
        }
    }
    
    public override func drawKnob(_ knobRect: NSRect) {
        let rect = resetKnobFrame(from: knobRect)
        let halfKnobRadius = knobSize / 2
        let knob = NSBezierPath(roundedRect: rect, xRadius: halfKnobRadius, yRadius: halfKnobRadius)
        if isEnabled {
            knobColor.setFill()
        } else {
            NSColor(red: knobColor.redComponent, green: knobColor.greenComponent, blue: knobColor.blueComponent, alpha: 0.3).setFill()
        }
        knob.fill()
    }
    
    private func resetKnobFrame(from knobRect: NSRect) -> NSRect {
        guard let controlView = controlView else {
            return knobRect
        }
        
        let offset: CGFloat = (knobRect.width - (knobRect.width - (abs(knobRect.minY) * 2) - knobSize))
        var scale = CGFloat((doubleValue - minValue) / (maxValue - minValue))
        // 处理最小值为负数的时候
        if style == .doubleSide && minValue < 0 {
            if doubleValue < 0 {
                scale = 0.5 - abs(CGFloat(doubleValue / maxValue) * 0.5)
            } else {
                scale = 0.5 + abs(CGFloat(doubleValue / maxValue) * 0.5)
            }
        }
        var x: CGFloat = (controlView.width - (knobSize)) * scale
        if style == .singleSide {
            if x <= abs(controlView.frame.minX) {
                x = abs(controlView.frame.minX)
            } else if x >= controlView.width - offset {
                x = controlView.width - offset
            }
        }

        let y: CGFloat
        if #available(macOS 11, *) {
            y = (controlView.height - knobSize) / 2 - 2
        } else {
            y =  (controlView.height - knobSize) / 2
        }
        
        let newRect = NSRect(x: x, y: y, width: knobSize, height: knobSize)
        return newRect
    }
    
    public override func drawBar(inside rect: NSRect, flipped: Bool) {
        var newRect = rect
        if flipped {
            newRect.origin.y -= (trackHeight - rect.size.height) * 0.5
        } else {
            newRect.origin.y += (trackHeight - rect.size.height) * 0.5
        }
        newRect.size.height = trackHeight

        let barRadius = trackHeight / 2
        switch style {
        case .singleSide:
            let value = CGFloat((doubleValue - minValue) / (maxValue - minValue))
            let finalWidth = CGFloat(value * (controlView!.frame.size.width - 8))
            var leftRect = newRect
            leftRect.size.width = finalWidth
            let bg = NSBezierPath(roundedRect: newRect, xRadius: barRadius, yRadius: barRadius)
            if isEnabled {
                backgroundColor.setFill()
            } else {
                NSColor(red: backgroundColor.redComponent, green: backgroundColor.greenComponent, blue: backgroundColor.blueComponent, alpha: 0.3).setFill()
            }
            bg.fill()
            let active = NSBezierPath(roundedRect: leftRect, xRadius: barRadius, yRadius: barRadius)
            if isEnabled {
                fillColor.setFill()
            } else {
                NSColor(red: fillColor.redComponent, green: fillColor.greenComponent, blue: fillColor.blueComponent, alpha: 0.3).setFill()
            }
            active.fill()
        case .doubleSide:
            let middleValue = (maxValue + minValue) / 2
            if doubleValue > middleValue {
                let value = CGFloat((doubleValue - middleValue) / (maxValue - minValue))
                let finalWidth = CGFloat(value * (controlView!.frame.size.width - 8))
                var leftRect = newRect
                leftRect.size.width = finalWidth
                leftRect.origin.x = 0.5 * newRect.width
                let bg = NSBezierPath(roundedRect: newRect, xRadius: barRadius, yRadius: barRadius)
                if isEnabled {
                    backgroundColor.setFill()
                } else {
                    NSColor(red: backgroundColor.redComponent, green: backgroundColor.greenComponent, blue: backgroundColor.blueComponent, alpha: 0.3).setFill()
                }
                bg.fill()
                let active = NSBezierPath(roundedRect: leftRect, xRadius: barRadius, yRadius: barRadius)
                if isEnabled {
                    fillColor.setFill()
                } else {
                    NSColor(red: fillColor.redComponent, green: fillColor.greenComponent, blue: fillColor.blueComponent, alpha: 0.3).setFill()
                }
                active.fill()
            } else {
                let value = CGFloat((middleValue - doubleValue) / (maxValue - minValue))
                let finalWidth = CGFloat(value * (controlView!.frame.size.width - 8))
                var leftRect = newRect
                leftRect.size.width = finalWidth
                leftRect.origin.x = 0.5 * newRect.width - finalWidth
                let bg = NSBezierPath(roundedRect: newRect, xRadius: barRadius, yRadius: barRadius)
                if isEnabled {
                    backgroundColor.setFill()
                } else {
                    NSColor(red: backgroundColor.redComponent, green: backgroundColor.greenComponent, blue: backgroundColor.blueComponent, alpha: 0.3).setFill()
                }
                bg.fill()
                let active = NSBezierPath(roundedRect: leftRect, xRadius: barRadius, yRadius: barRadius)
                if isEnabled {
                    fillColor.setFill()
                } else {
                    NSColor(red: fillColor.redComponent, green: fillColor.greenComponent, blue: fillColor.blueComponent, alpha: 0.3).setFill()
                }
                active.fill()
            }
        }
    }
}

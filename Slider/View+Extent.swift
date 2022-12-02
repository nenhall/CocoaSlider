//
//  extent.swift
//  CocoaSlider (macOS)
//
//  Created by cocoa@nenhall on 2022/10/11.
//

import Cocoa

public extension CGRect {
    var x: CGFloat {
        get { return minX }
        set { origin.x = newValue }
    }
    
    var y: CGFloat {
        get { return minY }
        set { origin.y = newValue }
    }
    
    var end: CGPoint {
        get {
            return CGPoint(x: x + width, y: y + height)
        }
        set {
            width = (newValue.x - x) >= 0 ? (newValue.x - x) : 0
            height = (newValue.y - y) >= 0 ? (newValue.y - y) : 0
        }
    }
    
    var width: CGFloat {
        get { return size.width }
        set { size.width = newValue }
    }
    
    var height: CGFloat {
        get { return size.height }
        set { size.height = newValue }
    }
    
    var left: CGFloat {
        get { return minX }
        set { x = newValue }
    }
    
    var right: CGFloat {
        get { return maxX}
        set { x = newValue - width}
    }
    
    var top: CGFloat {
        get { return minY }
        set { y = newValue }
    }
    
    var bottom: CGFloat {
        get { return maxY }
        set { y = newValue - height }
    }
}


public extension NSView {
    var x: CGFloat {
        get { return frame.x }
        set { self.frame.x = newValue }
    }
    
    var y: CGFloat {
        get { return frame.y }
        set { self.frame.y = newValue }
    }
    
    var end: CGPoint {
        get { return frame.end }
        set { frame.end = newValue }
    }
    
    var size: CGSize {
        get { return frame.size }
        set { frame.size = newValue }
    }

    var width: CGFloat {
        get { return frame.width }
        set { frame.width = newValue }
    }
    
    var height: CGFloat {
        get { return frame.height }
        set { frame.height = newValue }
    }
    
    var left: CGFloat {
        get { return x }
        set { x = newValue }
    }
    
    var right: CGFloat {
        get { return frame.right}
        set { x = newValue - width}
    }
    
    var top: CGFloat {
        get { return y }
        set { y = newValue }
    }
    
    var bottom: CGFloat {
        get { return frame.bottom }
        set { y = newValue - height }
    }
}

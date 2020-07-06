//
//  Diag.swift
//  CourseWork
//
//  Created by IvanLyuhtikov on 4/20/20.
//  Copyright © 2020 IvanLyuhtikov. All rights reserved.
//

import Macaw

class DiagramView: MacawView {
    
    struct ScreenSize {
        static let widthOfScreen = UIScreen.main.bounds.width
        static let heightOfScreen = UIScreen.main.bounds.height
    }
    
    static var dataDiagram: [Double] = []
    static let palette = [0xf08c00, 0xbf1a04, 0xffd505, 0x8fcc16, 0xd1aae3].map { val in Color(val: val)}
    
    
    
    required init?(coder aDecoder: NSCoder) {
        
        let chart = DiagramView.createChart()
        let bars = DiagramView.createBars()
        
        super.init(node: Group(contents: [chart, bars]), coder: aDecoder)
    }
    
    private static func searchCoef() -> Double {
        let max = dataDiagram.max()!
        return max/Double(dataDiagram.count)
    }
    
    private static func createChart() -> Group {
        let coef = searchCoef()
        var items: [Node] = []
        for i in 1...dataDiagram.count+1 {
            let y = 100 - Double(i) * coef/10
            items.append(Line(x1: -5, y1: y, x2: 275, y2: y).stroke(fill: Color(val: 0xF0F0F0)))
            items.append(Text(text: "\(i*Int(coef))", align: .max, baseline: .mid, place: .move(dx: -10, dy: y)))
        }
        
        items.append(Line(x1: 0, y1: 100, x2: 275, y2: 100).stroke())
        items.append(Line(x1: 0, y1: -100, x2: 0, y2: 100).stroke())
        return Group(contents: items, place: .move(dx: 50, dy: 100))
    }
    
    
    private static func createBars() -> Group {
        var animations: [Animation] = []
        var items: [Node] = []
        for (i, item) in dataDiagram.enumerated() {
            let bar = Shape(
                form: Rect(x: Double(i) * 50 + 75, y: 0, w: 30, h: item/10),
                fill: LinearGradient(degree: 90, from: palette[i], to: palette[i].with(a: 0.3)),
                place: .scale(sx: 1, sy: 0))
            items.append(bar)
            animations.append(bar.placeVar.animation(to: .move(dx: 0, dy: -dataDiagram[i]/10), delay: Double(i) * 0.1))
        }
        animations.combine().play()
        return Group(contents: items, place: .move(dx: 0, dy: 200))
    }
    
}

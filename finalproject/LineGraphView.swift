//
//  LineGraphView.swift
//  finalproject
//
//  Created by Sydney Blakeman on 8/1/22.
//

import SwiftUI

class LineGraphModel: ObservableObject {
    var ids: [UUID] = []
    @Published var data: [Zip2Sequence<[Date], [Double]>] = []
    @Published var label: [String] = []
}

struct LineGraphView: View {
    @EnvironmentObject var model: LineGraphModel
    
    var body: some View {
        Canvas { context, size in
            let gap = CGFloat(20)
            let height = size.height - gap * 3.0
            let width = size.width - gap * 3.0
            var border = Path()
            border.addLines([
                .init(x: gap * 2.5, y: gap),
                .init(x: gap * 2.5, y: height),
                .init(x: width + gap * 2.0, y: height)
            ])
            context.stroke(border, with: .foreground, lineWidth: 2)
            
            let y_max = model.data.map{$0.map{$1}.max() ?? -.infinity}.max() ?? -.infinity
            let y_min = model.data.map{$0.map{$1}.min() ?? .infinity}.min() ?? .infinity
            
            let x_max = model.data.map { element in
                element.map {(date,_) in date}.max() ?? .distantFuture
            }.max() ?? .distantFuture
            let x_min = model.data.map { element in
                element.map {(date,_) in date}.min() ?? .distantPast
            }.min() ?? .distantPast
            
            let y_scale = (height - gap) / (y_max - y_min)
            let x_range = (x_max.timeIntervalSinceReferenceDate - x_min.timeIntervalSinceReferenceDate) / (width - gap)
            for (index, datum) in model.data.enumerated() {
                var line = Path()
//                line.move(to: .init(x: gap * 2.5, y: height - y_min * y_scale + 0.1))
                line.move(to: .init(x: gap * 2.5, y: height * 0.95 - (0.0 - y_min) * y_scale * 0.9))

                line.addLine(to: .init(x: gap * 2.5, y: height * 0.95 - (0.0 - y_min) * y_scale * 0.9))
                for (date, number) in datum {
                    line.addLine(to: .init(x: (date.timeIntervalSinceReferenceDate - x_min.timeIntervalSinceReferenceDate) / x_range + gap * 2.5 + 0.1, y: height * 0.95 - (number - y_min) * y_scale * 0.9))
                }
//                let color = Color.randomColor()
                let color = Color.fromUUID(uuid: model.ids[index])
                let circle = Path(ellipseIn: .init(x: CGFloat(index % 3) * width / 3.0 + gap * 2.8, y: height + 32.0 + 15 * CGFloat(index / 3), width: 10.0, height: 10.0))
                context.fill(circle, with: .color(color))
                context.stroke(line, with: .color(color), lineWidth: 4)
                let text = context.resolve(Text(model.label[index].uppercased()).font(.caption2))
                context.draw(text, at: .init(x: CGFloat(index % 3) * width / 3.0 + gap * 2.8 + 15.0, y: height + 30.5 + 15 * CGFloat(index / 3) ), anchor: .topLeading)
            }
            for y in stride(from: gap, through: height, by: height / 5) {
                var line = Path()
                line.addLines([
                    .init(x: gap * 2.5, y: y + height / 20),
                    .init(x: width + gap * 2.0, y: y + height / 20)
                ])
                context.stroke(line, with: .color(.secondary.opacity(0.5)), style: .init(lineWidth: 1, dash: [5, 7]))
                let label = (-y + height * 0.95) / y_scale / 0.9 + y_min - height * 0.95 / 20.0 / y_scale / 0.9
                let text = context.resolve(Text(label.formatted(.percent.precision(.fractionLength(0)))).font(.caption))

                context.draw(text, at: .init(x: gap * 2.1, y: y + height / 20), anchor: .trailing)
            }
            if y_min < 0 {
                let temp = height + y_min * y_scale - height * 0.95 / 20.0 / 2
                var zero = Path()
                zero.addLines([
                    .init(x: gap * 2.5, y: temp),
                    .init(x: width + gap * 2.0, y: temp)
                ])
                context.stroke(zero, with: .color(.red.opacity(0.5)), style: .init(lineWidth: 3, dash: [7, 10]))
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "M/d"
            
            for (index, date) in model.data.first?.map({$0.0}).enumerated() ?? [Date]().enumerated() {
                let label = Text(dateFormatter.string(from: date)).font(.caption)
                context.draw(context.resolve(label), at: .init(
                    x: CGFloat((width - gap) / CGFloat(model.data.first!.underestimatedCount - 1) * CGFloat(index)) + gap * 1.8,
                    y: height + 15.0), anchor: .leading)
            }
        }
    }
}

extension Color {
    static func randomColor() -> Color {
        Color(red: .random(in: 0.0...1.0), green: .random(in: 0.0...1.0), blue: .random(in: 0.0...1.0))
    }
    
    static func fromUUID(uuid: UUID) -> Color {
        let data = withUnsafePointer(to: uuid) {
            Data(bytes: $0, count: MemoryLayout.size(ofValue: uuid))
        }
        
        return Color(hue: Double([UInt8](data).last!) / 256.0, saturation: 0.7, brightness: 1.0)
    }
}

struct LineGraphView_Previews: PreviewProvider {
    static var lineGraphModel = LineGraphModel()
    
    static var previews: some View {
        LineGraphView()
            .environmentObject(lineGraphModel)
            .onAppear {
                for index in 0..<6 {
                    let seq = [Double.random(in: -0.3..<1.3), Double.random(in: -0.3..<1.3), Double.random(in: -0.3..<1.3)]
                    lineGraphModel.data.append(zip([Date.distantPast, .now, .distantFuture], seq))
                    lineGraphModel.label.append("number\(index)")
                    lineGraphModel.ids.append(UUID())
                }
            }
    }
}

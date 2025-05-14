import Foundation
import CoreGraphics
import DGCharts

/// Sadece LimitLine'ları çizen özel bir Y ekseni çizer.
public class YAxisRenderer: AxisRenderer {
    
    public typealias Axis = YAxis

    public var axis: YAxis
    public var transformer: Transformer?
    public var viewPortHandler: ViewPortHandler

    public init(viewPortHandler: ViewPortHandler, axis: YAxis, transformer: Transformer?) {
        self.viewPortHandler = viewPortHandler
        self.axis = axis
        self.transformer = transformer
    }

    /// LimitLine çizgilerini ve değerlerini Y ekseni yanında gösterme
    public func renderLimitLines(context: CGContext) {
        guard let transformer = transformer else { return }

        let limitLines = axis.limitLines

        for limitLine in limitLines {
            if !limitLine.isEnabled { continue }

            var position = CGPoint(x: 0.0, y: limitLine.limit)
            transformer.pointValueToPixel(&position)

            if position.y < viewPortHandler.contentTop || position.y > viewPortHandler.contentBottom {
                continue
            }

            // **1️⃣ Limit Line Çizgisini Çiz**
            context.setStrokeColor(limitLine.lineColor.cgColor)
            context.setLineWidth(limitLine.lineWidth)
            context.setLineDash(phase: 0, lengths: limitLine.lineDashLengths ?? [])

            context.beginPath()
            context.move(to: CGPoint(x: viewPortHandler.contentLeft, y: position.y))
            context.addLine(to: CGPoint(x: viewPortHandler.contentRight, y: position.y))
            context.strokePath()

            // **2️⃣ LimitLine Değerini Y Ekseni Yanında Göster**
            let text = "\(limitLine.limit)" as NSString
            let attributes: [NSAttributedString.Key: Any] = [
                .font: limitLine.valueFont,
                .foregroundColor: limitLine.valueTextColor
            ]

            let textSize = text.size(withAttributes: attributes)
            let padding: CGFloat = 6

            let labelRect = CGRect(
                x: viewPortHandler.contentLeft - textSize.width - padding * 2 - 4,
                y: position.y - textSize.height / 2 - padding / 2,
                width: textSize.width + padding * 2,
                height: textSize.height + padding
            )

            // **3️⃣ Arka Planı Çiz**
            context.setFillColor(UIColor.yellow.withAlphaComponent(0.8).cgColor)
            context.fill(labelRect)

            // **4️⃣ Kenarlık Çiz (Opsiyonel)**
            context.setStrokeColor(UIColor.black.cgColor)
            context.setLineWidth(1)
            context.stroke(labelRect)

            // **5️⃣ Metni Çiz**
            text.draw(in: labelRect.insetBy(dx: padding, dy: padding / 2), withAttributes: attributes)
        }
    }

    // Diğer metodları boş bırakıyoruz çünkü sadece LimitLine çizmek istiyoruz.
    public func renderAxisLabels(context: CGContext) {}
    public func renderGridLines(context: CGContext) {}
    public func renderAxisLine(context: CGContext) {}
    public func computeAxis(min: Double, max: Double, inverted: Bool) {}
    public func computeAxisValues(min: Double, max: Double) {}
}

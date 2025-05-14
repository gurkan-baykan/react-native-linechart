import DGCharts
import UIKit

class BalloonMarker: UIView, Marker {
    weak var chartView: ChartViewBase?
    
    var circleEntity:  CircleEntityStruct
    var color: UIColor
    var arrowSize: CGSize
    var font: UIFont
    var textColor: UIColor
    var insets: UIEdgeInsets
    var minimumSize: CGSize
    private var label: String?
    
    var offset: CGPoint = .init(x: 0, y: 0) // Merkezleme için

    private var _labelSize: CGSize = .zero
    private var _paragraphStyle: NSMutableParagraphStyle = {
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        return style
    }()

    private var _drawAttributes = [NSAttributedString.Key: Any]()

    // Sabit yükseklik için gerekli değişken
    var fixedYPosition: CGFloat = 0

  init(circleEntity:CircleEntityStruct,color: UIColor, font: UIFont, textColor: UIColor, insets: UIEdgeInsets) {
        self.color = color
        arrowSize = CGSize(width: 15, height: 11)
        self.font = font
        self.textColor = textColor
        self.insets = insets
        self.circleEntity = circleEntity
        minimumSize = CGSize(width: 40, height: 25)
        super.init(frame: CGRect.zero)
     
        backgroundColor = .clear
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Y eksenini sabit tutarak sadece X eksenine göre hareket etmesini sağlıyoruz
    func offsetForDrawing(atPoint point: CGPoint) -> CGPoint {
        let newOffset = self.offset

        guard let chart = chartView else { return newOffset }

        // Y koordinatını sabit tutuyoruz (fixedYPosition)
        let yPosition = fixedYPosition

        // X koordinatını Highlight'a göre ayarlıyoruz
        var origin = point
        origin.x -= bounds.size.width / 2

        // Y koordinatını sabit tutarak X koordinatını ayarlıyoruz
        var offset = CGPoint(x: origin.x, y: yPosition)

        // Sağ ve sol sınırları kontrol et
        if offset.x < 0 {
            offset.x = 0
        } else if offset.x + bounds.size.width > chart.bounds.size.width {
            offset.x = chart.bounds.size.width - bounds.size.width
        }

        return offset
    }
  
    // İçeriği güncelleme
    func refreshContent(entry: ChartDataEntry, highlight _: Highlight) {
        setLabel(String(format: "%.2f", entry.y))
       
        setNeedsDisplay() // Marker’ı güncelle
    }

    // Marker'ı çizme işlemi
    func draw(context: CGContext, point: CGPoint) {
        guard let label = label else { return }

        let offset = offsetForDrawing(atPoint: point)
        let size = bounds.size
     
        context.saveGState()
          
      if !circleEntity.isEmpty  {
        
      
        let circleSize: CGFloat = circleEntity.size as? CGFloat ??  20
        let circleColor = (circleEntity.color as? CGColor) ?? UIColor.white.cgColor
        
       
        let circleRect = CGRect(x: point.x - circleSize / 2, y: point.y - circleSize / 2, width: circleSize, height: circleSize)
        context.setFillColor(circleColor)
        context.fillEllipse(in: circleRect)
      }
        
      
        var rect = CGRect(
            origin: CGPoint(
                x: offset.x,
                y: offset.y
            ),
            size: size
        )

        context.saveGState()
        context.setFillColor(color.cgColor)
  

        // Ok (arrow) çizen bölüm
        if offset.y > 0 {
            context.beginPath()
            context.move(to: CGPoint(
                x: rect.origin.x,
                y: rect.origin.y + arrowSize.height
            ))
            context.addLine(to: CGPoint(
                x: rect.origin.x + (rect.size.width - arrowSize.width) / 2.0,
                y: rect.origin.y + arrowSize.height
            ))
            // Okun ucu

            context.addLine(to: CGPoint(
                x: rect.origin.x,
                y: rect.origin.y + rect.size.height
            ))
            context.addLine(to: CGPoint(
                x: rect.origin.x,
                y: rect.origin.y + arrowSize.height
            ))
            context.fillPath()
        } else {
            context.beginPath()
            context.move(to: CGPoint(
                x: rect.origin.x,
                y: rect.origin.y
            ))
            context.addLine(to: CGPoint(
                x: rect.origin.x + rect.size.width,
                y: rect.origin.y
            ))
            context.addLine(to: CGPoint(
                x: rect.origin.x + rect.size.width,
                y: rect.origin.y + rect.size.height - arrowSize.height
            ))
            context.addLine(to: CGPoint(
                x: rect.origin.x + (rect.size.width + arrowSize.width) / 2.0,
                y: rect.origin.y + rect.size.height - arrowSize.height
            ))
            // Okun ucu

            context.addLine(to: CGPoint(
                x: rect.origin.x,
                y: rect.origin.y + rect.size.height - arrowSize.height
            ))
            context.addLine(to: CGPoint(
                x: rect.origin.x,
                y: rect.origin.y
            ))
            context.fillPath()
        }

        // Yazıyı çizme
        if offset.y > 0 {
            rect.origin.y += insets.top + arrowSize.height
        } else {
            rect.origin.y += insets.top
        }

        rect.size.height -= insets.top + insets.bottom

        UIGraphicsPushContext(context)
        label.draw(in: rect, withAttributes: _drawAttributes)
        UIGraphicsPopContext()

        context.restoreGState()
    }

    // **Label’ı güncelleyen yardımcı metod**
    func setLabel(_ newLabel: String) {
        label = newLabel

        _drawAttributes = [
            .font: font,
            .paragraphStyle: _paragraphStyle,
            .foregroundColor: textColor,
        ]

        _labelSize = label?.size(withAttributes: _drawAttributes) ?? .zero

        var size = CGSize()
        size.width = _labelSize.width + insets.left + insets.right
        size.height = _labelSize.height + insets.top + insets.bottom
        size.width = max(minimumSize.width, size.width)
        size.height = max(minimumSize.height, size.height)

        bounds = CGRect(origin: .zero, size: size)
    }
}

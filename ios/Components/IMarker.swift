import DGCharts

/// `IMarker` protokolünü eski versiyonlardaki gibi tanımlıyoruz.
@objc public protocol IMarker {
    /// Grafikte kullanılacak `ChartViewBase` referansı.
    var chartView: ChartViewBase? { get set }

    /// Seçilen noktanın konumuna göre offset hesaplar.
    func offsetForDrawing(atPoint point: CGPoint) -> CGPoint

    /// Yeni veri geldiğinde içeriği günceller.
    func refreshContent(entry: ChartDataEntry, highlight: Highlight)
}

package com.linechart

import android.content.Context
import android.graphics.Color
import android.graphics.LinearGradient
import android.graphics.Shader
import android.graphics.drawable.Drawable
import android.graphics.drawable.GradientDrawable
import android.util.Log
import com.github.mikephil.charting.charts.LineChart
import com.github.mikephil.charting.components.XAxis
import com.github.mikephil.charting.components.YAxis
import com.github.mikephil.charting.data.Entry
import com.github.mikephil.charting.data.LineData
import com.github.mikephil.charting.data.LineDataSet
import com.github.mikephil.charting.interfaces.datasets.ILineDataSet
import com.linechart.custom.MyMarkerView
import com.github.mikephil.charting.animation.Easing
import com.github.mikephil.charting.components.LimitLine


class LineChartSpecView(context: Context) : LineChart(context) {

    init {
        setupChart()
    }

    private fun setupChart() {
        this.setTouchEnabled(true)
        this.setScaleEnabled(false)
        this.setPinchZoom(false)

        this.isDragEnabled = false
        this.setScaleXEnabled(false)
        this.setScaleYEnabled(false)

        this.setBackgroundColor(Color.WHITE)

        // X Axis Default Ayarları
        this.xAxis.apply {
            position = XAxis.XAxisPosition.TOP_INSIDE
            textSize = 15f
            textColor = Color.BLACK
            setDrawAxisLine(false)
            setDrawGridLines(false)
            setCenterAxisLabels(false)
            yOffset = 0f
            setDrawLabels(false)
        }

        this.axisLeft.apply {
            setPosition(YAxis.YAxisLabelPosition.INSIDE_CHART)
            textSize = 15f
            setDrawGridLines(true)
            isGranularityEnabled = true
            axisMinimum = 0f
            axisMaximum = 120f
            yOffset = 30f
            xOffset = -10f
            textColor = Color.RED
            setDrawLabels(true)
        }

        this.data?.setDrawValues(false)

        this.legend.isEnabled = true
        this.legend.form = com.github.mikephil.charting.components.Legend.LegendForm.LINE

        this.isHighlightPerTapEnabled = false
        this.isHighlightPerDragEnabled = false

        this.animateX(800, Easing.Linear)
        this.animateY(1000,Easing.Linear)

        this.axisRight.isEnabled = false
    }


    fun setChartData(data: Map<String, Any>) {
        try {

            val dataSetsArray = data["dataSets"] as? List<Map<String, Any>> ?: return
            val chartDataSets = mutableListOf<LineDataSet>()

            for (dataSetDict in dataSetsArray) {
                val drawVerticalHighlightIndicatorEnabled = dataSetDict["drawVerticalHighlightIndicatorEnabled"] as Boolean
                val drawHorizontalHighlightIndicatorEnabled = dataSetDict["drawHorizontalHighlightIndicatorEnabled"] as Boolean
                val drawValuesEnabled = dataSetDict["drawValuesEnabled"] as Boolean
                val gradientData = dataSetDict["gradientColorsData"] as  Map<String, Any>
                val fromColor = gradientData["from"] as? String ?: "#FFFFFF"
                val toColor = gradientData["to"] as? String ?: "#000000"
                val limitLines = dataSetDict["limitLineEntity"] as? Map<String, Any>
                val valuesArray = dataSetDict["values"] as? List<Map<String, Any>> ?: continue
                val label = dataSetDict["label"] as? String ?: ""

                val entries = valuesArray.mapNotNull { valueDict ->
                    val x = (valueDict["x"] as? Number)?.toFloat() ?: return@mapNotNull null
                    val y = (valueDict["y"] as? Number)?.toFloat() ?: return@mapNotNull null
                    Entry(x, y)
                }

                val dataSet = LineDataSet(entries, label).apply {
                    color = Color.parseColor(fromColor)
                    circleRadius = 5f
                    circleHoleRadius = 2f
                    setDrawCircles(false)
                    valueTextSize = 13f
                    setDrawFilled(true)
                    val gradient = LinearGradient(
                        0f, 600f, 0f, 0f, // Başlangıç ve bitiş koordinatları
                        intArrayOf(Color.parseColor("#f5f0f0"), Color.parseColor("#d6371e")), // Renkler
                        null, // Renk geçiş noktaları (eşit dağılım için `null`)
                        Shader.TileMode.CLAMP // Renklerin sınırlarını kes
                    )

                    val paint = renderer.paintRender

                    fillDrawable = getGradientDrawable(fromColor, toColor)

                    paint.setShader(gradient)
                    setDrawValues(drawValuesEnabled)
                    setDrawHorizontalHighlightIndicator(drawHorizontalHighlightIndicatorEnabled)
                    setDrawVerticalHighlightIndicator(drawVerticalHighlightIndicatorEnabled)
                    setHighLightColor(Color.BLACK);
                    lineWidth = 2f

                    highlightLineWidth = 2f
                    setDrawCircleHole(false)
                }

                limitLines?.takeIf { it.isNotEmpty() }?.let { limitLineEntity ->
                    configureLimitLine(limitLineEntity, dataSet)
                }

                chartDataSets.add(dataSet)
            }

            this.data = LineData(chartDataSets as List<ILineDataSet>?)
            this.notifyDataSetChanged()
        } catch (e: Exception) {
            emitOnChartError("Error setting chart data: ${e.message}")
        }
    }

    fun configureLimitLine(limitLineEntity: Map<String, Any>, dataSet: LineDataSet) {
        val lineWidth = (limitLineEntity["lineWidth"] as? Number)?.toFloat() ?: 1.0f
        val lineColor =
            (limitLineEntity["lineColor"] as? String)?.let { Color.parseColor(it) } ?: Color.RED
        val lineDashLengths =
            (limitLineEntity["lineDashLengths"] as? List<Number>)?.map { it.toFloat() }
                ?: listOf(5f, 5f)
        val fontSize = (limitLineEntity["fontSize"] as? Number)?.toFloat() ?: 10.0f
        val labelPosition = limitLineEntity["labelPosition"] as? String ?: "rightTop"
        val labelValueColor =
            (limitLineEntity["labelValueColor"] as? String)?.let { Color.parseColor(it) }
                ?: Color.RED

        val lastEntry =
            dataSet.entryCount.takeIf { it > 0 }?.let { dataSet.getEntryForIndex(it - 1) }

        if (lastEntry != null) {
            val limit = lastEntry.y
            val labelText = limitLineEntity["label"] as? String ?: limit.toString()

            val limitLine = LimitLine(limit, labelText).apply {
                this.lineWidth = lineWidth
                this.enableDashedLine(lineDashLengths[0], lineDashLengths[1], 0f)
                this.textSize = fontSize
                this.textColor = labelValueColor
                this.lineColor = lineColor

                this.labelPosition = when (labelPosition) {
                    "leftTop" -> LimitLine.LimitLabelPosition.LEFT_TOP
                    "leftBottom" -> LimitLine.LimitLabelPosition.LEFT_BOTTOM
                    "rightBottom" -> LimitLine.LimitLabelPosition.RIGHT_BOTTOM
                    else -> LimitLine.LimitLabelPosition.RIGHT_TOP
                }
            }
            this.axisLeft.addLimitLine(limitLine)
        }
    }

    private fun getGradientDrawable(fromHex: String, toHex: String): Drawable {
        val startColor = Color.parseColor(fromHex)
        val endColor = Color.parseColor(toHex)

        return GradientDrawable(GradientDrawable.Orientation.TOP_BOTTOM, intArrayOf(startColor, endColor)).apply {
            gradientType = GradientDrawable.LINEAR_GRADIENT
        }
    }

    override fun setDragEnabled(enabled: Boolean) {
        super.setDragEnabled(enabled)
    }

    fun setXAxisEntity(data: Map<String, Any>) {
        this.xAxis.apply {
            val labelPosition = when (data["labelPosition"] as? String) {
                "top" -> XAxis.XAxisPosition.TOP
                "bottom" -> XAxis.XAxisPosition.BOTTOM
                "topInside" -> XAxis.XAxisPosition.TOP_INSIDE
                "bottomInside" -> XAxis.XAxisPosition.BOTTOM_INSIDE
                else -> XAxis.XAxisPosition.BOTTOM
            }

            position = labelPosition
            val font = data["labelFont"] as? Map<String, Any>
            val size = "${(font?.get("size") as? Number)?.toFloat() ?: 25}f"

            textSize = size.toFloat()
            textColor = Color.parseColor(data["labelTextColor"] as? String ?: "#000000")
            axisMinimum = (data["axisMin"] as? Float)?.toFloat() ?: 0f
            yOffset = (data["yOffset"] as? Number)?.toFloat() ?: -10f
            val axisMax = (data["axisMax"] as? Number)?.toFloat() ?: 0f

            if (axisMax > 0) {
                axisMaximum = axisMax
            }
            yOffset = (data["yOffset"] as? Number)?.toFloat() ?: 0f
            setDrawLabels(data["drawLabelsEnabled"] as? Boolean ?: true)
        }
    }

    fun setYAxisEntity(data: Map<String, Any>) {
        this.axisLeft.apply {
            val labelPosition = when (data["labelPosition"] as? String) {
                "inside" -> YAxis.YAxisLabelPosition.INSIDE_CHART
                "outside" -> YAxis.YAxisLabelPosition.OUTSIDE_CHART
                else -> YAxis.YAxisLabelPosition.INSIDE_CHART
            }

            setPosition(labelPosition)
            val font = data["labelFont"] as? Map<String, Any>
            val size = "${(font?.get("size") as? Number)?.toFloat() ?: 25}f"
            textSize = size.toFloat()
            textColor = Color.parseColor(data["labelTextColor"] as? String ?: "#FF0000")
            xOffset = (data["xOffset"] as? Number)?.toFloat() ?: -10f
            yOffset = (data["yOffset"] as? Number)?.toFloat() ?: -10f
            axisMinimum = (data["axisMin"] as? Float)?.toFloat() ?: 0f

            val axisMax = (data["axisMax"] as? Number)?.toFloat() ?: 0f

            if (axisMax > 0) {
                axisMaximum = axisMax
            }

            setDrawLabels(data["drawLabelsEnabled"] as? Boolean ?: true)
        }
    }

    // 📌 Tap ile Highlight Aç/Kapat
    override fun setHighlightPerTapEnabled(enabled: Boolean) {
        Log.d("LineChartSpecView", "setChartData: Gelen efsddfd verisi: $enabled")
        super.setHighlightPerTapEnabled(enabled)
    }

    // 📌 Drag ile Highlight Aç/Kapat
    override fun setHighlightPerDragEnabled(enabled: Boolean) {
        super.setHighlightPerDragEnabled(enabled)
    }

    fun setMarkerEntity(data: Map<String, Any>) {
        Log.d("LineChartSpecView", "data geldiiiiii: $data")

        val mv = MyMarkerView(context, R.layout.my_marker_view,data)

        this.marker = mv
        this.invalidate()
    }

    fun setBgColor(bgColor: String) {
        Log.d("LineChartSpecView", "data geldiiiiii: $data")
        val color = bgColor as? String ?: "#FFFFFF"
        val hexColor = Color.parseColor(color)
        this.setBackgroundColor(hexColor)
    }

    fun setAnimationEntity(animationEntity: Map<String, Any>) {
        Log.d("LineChartSpecView", "data geldiiiiii: $data")
        val xAxisDuration = animationEntity["xAxisDuration"] as? Int ?: 800
        val yAxisDuration = animationEntity["yAxisDuration"] as? Int ?: 1000

        val xAxisEasing = animationEntity["xAxisEasing"] as? Easing.EasingFunction ?: Easing.Linear
        val yAxisEasing = animationEntity["yAxisEasing"] as? Easing.EasingFunction ?: Easing.Linear

        this.animateX(xAxisDuration,xAxisEasing)
        this.animateY(xAxisDuration,yAxisEasing)
    }

    fun setDrawGridLinesEnabled(drawGridLinesEnabled: Boolean) {
        this.axisLeft.setDrawAxisLine(drawGridLinesEnabled)
    }
    fun emitOnChartError(errorMessage: String) {
        Log.e("LineChartSpecView", errorMessage)
    }
}

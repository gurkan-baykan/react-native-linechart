package com.linechart.custom

import android.annotation.SuppressLint
import android.content.Context
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Color.parseColor
import android.graphics.Paint
import android.graphics.RectF
import android.provider.CalendarContract.Colors
import android.util.Log
import android.view.Gravity
import android.view.ViewGroup
import android.widget.FrameLayout
import android.widget.TextView
import com.github.mikephil.charting.components.MarkerView
import com.github.mikephil.charting.data.CandleEntry
import com.github.mikephil.charting.data.Entry
import com.github.mikephil.charting.highlight.Highlight
import com.github.mikephil.charting.utils.MPPointF
import com.github.mikephil.charting.utils.Utils
import com.linechart.R;


/**
 * Custom implementation of the MarkerView.
 *
 * @author Philipp Jahoda
 */
@SuppressLint("ViewConstructor")
class MyMarkerView(context: Context?, layoutResource: Int, private val data: Map<String, Any>) :
    MarkerView(context, layoutResource) {
    private val textView: TextView = findViewById<TextView>(R.id.textView)

    init {
        applyStyles()
    }

    private val circlePaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
        color = Color.BLACK
        style = Paint.Style.FILL
    }

    private fun applyStyles() {
        val fontColor = (data["color"] as? String)?.let { Color.parseColor(it) } ?: Color.BLACK
        textView.setTextColor(fontColor)
        val size = data["fontSize"]
        val fontSize = when (size) {
        is Number -> size.toFloat()
        is String -> size.toFloatOrNull() ?: 14f
        else -> 14f
        }

        textView.textSize = fontSize

        val bgColor = (data["bgColor"] as? String)?.let { Color.parseColor(it) } ?: Color.WHITE
        this.setBackgroundColor(bgColor)
    }

    override fun draw(canvas: Canvas, posX: Float, posY: Float) {
        val circleEntity = data["circleEntity"] as? Map<String, Any> ?: emptyMap()

        val circleSize = (circleEntity["size"] as? Number)?.toFloat() ?: 20f
        val circleColor = (circleEntity["color"] as? String)?.let { parseColor(it) } ?: android.graphics.Color.BLACK

        if (circleEntity.isNotEmpty()) {
            circlePaint.color = circleColor
            val circleRect = RectF(
                posX - circleSize ,
                posY - circleSize,
                posX + circleSize ,
                posY + circleSize
            )

            canvas.drawOval(circleRect, circlePaint)

            super.draw(canvas, posX, posY)
        }
    }


    override fun refreshContent(e: Entry, highlight: Highlight) {
        if (e is CandleEntry) {
            textView.setTextColor(Color.BLACK)
        } else {
            textView.text = Utils.formatNumber(e.y, 1, false)

        }
        super.refreshContent(e, highlight)
    }

    override fun getOffset(): MPPointF {
        return MPPointF(-width / 2f, -height.toFloat()) // Sadece kendi yüksekliğini baz al
    }

    override fun getOffsetForDrawingAtPoint(x: Float, y: Float): MPPointF {
        return MPPointF(-width / 2f, -y + 40) // Y ekseninde sabitler
    }

}
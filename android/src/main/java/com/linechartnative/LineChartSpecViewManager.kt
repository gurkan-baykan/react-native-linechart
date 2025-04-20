package com.linechartnative
import android.view.View
import android.util.Log
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.ViewManagerDelegate
import com.facebook.react.uimanager.annotations.ReactProp
import com.facebook.react.viewmanagers.LineChartSpecViewManagerInterface
import com.facebook.react.viewmanagers.LineChartSpecViewManagerDelegate
import com.linechartnative.LineChartSpecView
import org.json.JSONObject
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken



@ReactModule(name = LineChartSpecViewManager.REACT_CLASS)
class LineChartSpecViewManager(context: ReactApplicationContext) :
    SimpleViewManager<LineChartSpecView>(), LineChartSpecViewManagerInterface<LineChartSpecView> {

    private val delegate: ViewManagerDelegate<LineChartSpecView> = LineChartSpecViewManagerDelegate(this)

    override fun getDelegate(): ViewManagerDelegate<LineChartSpecView> = delegate

    override fun getName(): String = REACT_CLASS

    override fun createViewInstance(context: ThemedReactContext): LineChartSpecView {
        return LineChartSpecView(context)
    }

    @ReactProp(name = "data")
    override fun setData(view: LineChartSpecView, value: ReadableMap?) {
        if (value == null) {
            view.emitOnChartError("Invalid data received")
            return
        }
        try {
            Log.d("setData", "setData: json verisi: $value")
            val jsonData = convertReadableMapToJson(value)
            view.setChartData(jsonData)
        } catch (e: Exception) {
             Log.d("setData", "setData: json verisi error: $value")
            view.emitOnChartError("Error parsing JSON: ${e.message}")
        }
    }

    @ReactProp(name = "dragEnabled")
    override fun setDragEnabled(view: LineChartSpecView, value: Boolean) {
        Log.d("setDragEnabled", "drawValuesEnabled: json verisi: $value")
        view.setDragEnabled(value)
    }

    @ReactProp(name = "bgColor")
    override fun setBgColor(view: LineChartSpecView, value: String?) {
        Log.d("bgColor", "drawValuesEnabled: json verisi: $value")
        if (value != null) {
            view.setBgColor(value)
        }
    }

    // 📌 Marker Özelliğini Ayarla
    @ReactProp(name = "markerEntity")
    override fun setMarkerEntity(view: LineChartSpecView, value: ReadableMap?) {
        if (value != null) {
            Log.d("kuzeyyyy", "value: json verisi423423423: $value")
            val jsonData = convertReadableMapToJson(value)
            view.setMarkerEntity(jsonData)
        }
    }

    @ReactProp(name = "xAxisEntity")
    override fun setXAxisEntity(view: LineChartSpecView, value: ReadableMap?) {
        if (value != null) {
            val jsonData = convertReadableMapToJson(value)
            view.setXAxisEntity(jsonData)
        }
    }

    @ReactProp(name = "yAxisEntity")
    override fun setYAxisEntity(view: LineChartSpecView, value: ReadableMap?) {
        if (value != null) {
            val jsonData = convertReadableMapToJson(value)
            view.setYAxisEntity(jsonData)
        }
    }

    @ReactProp(name = "highlightPerTapEnabled")
    override fun setHighlightPerTapEnabled(view: LineChartSpecView, value: Boolean) {
        view.setHighlightPerTapEnabled(value)
    }

    @ReactProp(name = "highlightPerDragEnabled")
    override fun setHighlightPerDragEnabled(view: LineChartSpecView, value: Boolean) {
        view.setHighlightPerDragEnabled(value)
    }

    override fun setAnimationEntity(view: LineChartSpecView?, value: ReadableMap?) {
        if (value != null) {
            val jsonData = convertReadableMapToJson(value)
            view?.setAnimationEntity(jsonData)
        }
    }

    override fun setDrawGridLinesEnabled(view: LineChartSpecView?, value: Boolean) {
        view?.setDrawGridLinesEnabled(value)
    }

    companion object {
        const val REACT_CLASS = "LineChartSpecView"
    }

    override fun getExportedCustomBubblingEventTypeConstants(): Map<String, Any> =
        mapOf(
            "onChartError" to
                    mapOf(
                        "phasedRegistrationNames" to
                                mapOf(
                                    "bubbled" to "onChartError",
                                    "captured" to "onChartErrorCapture"
                                )
                    )
        )

    private fun convertReadableMapToJson(readableMap: ReadableMap): Map<String, Any> {
        val gson = Gson()
        val jsonString = gson.toJson(readableMap.toHashMap())  // JSON formatına çevir
        return gson.fromJson(jsonString, object : TypeToken<Map<String, Any>>() {}.type)
    }

}

// JSON parse etmek için yardımcı fonksiyon
fun JSONObject.toMap(): Map<String, Any> {
    val map = mutableMapOf<String, Any>()
    val keys = this.keys()
    while (keys.hasNext()) {
        val key = keys.next()
        map[key] = this.get(key)
    }
    return map
}

package com.linechartnative

import android.graphics.Color
import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.ViewManagerDelegate
import com.facebook.react.uimanager.annotations.ReactProp
import com.facebook.react.viewmanagers.LinechartNativeViewManagerInterface
import com.facebook.react.viewmanagers.LinechartNativeViewManagerDelegate

@ReactModule(name = LinechartNativeViewManager.NAME)
class LinechartNativeViewManager : SimpleViewManager<LinechartNativeView>(),
  LinechartNativeViewManagerInterface<LinechartNativeView> {
  private val mDelegate: ViewManagerDelegate<LinechartNativeView>

  init {
    mDelegate = LinechartNativeViewManagerDelegate(this)
  }

  override fun getDelegate(): ViewManagerDelegate<LinechartNativeView>? {
    return mDelegate
  }

  override fun getName(): String {
    return NAME
  }

  public override fun createViewInstance(context: ThemedReactContext): LinechartNativeView {
    return LinechartNativeView(context)
  }

  @ReactProp(name = "color")
  override fun setColor(view: LinechartNativeView?, color: String?) {
    view?.setBackgroundColor(Color.parseColor(color))
  }

  companion object {
    const val NAME = "LinechartNativeView"
  }
}

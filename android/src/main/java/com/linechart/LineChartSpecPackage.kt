package com.linechart

import com.facebook.react.BaseReactPackage
import com.facebook.react.bridge.NativeModule
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.module.model.ReactModuleInfo
import com.facebook.react.module.model.ReactModuleInfoProvider
import com.facebook.react.uimanager.ViewManager

class LineChartSpecPackage : BaseReactPackage() {

    override fun createViewManagers(reactContext: ReactApplicationContext): List<ViewManager<*, *>> {
        return listOf(LineChartSpecManager(reactContext))
    }

    override fun getModule(name: String, reactApplicationContext: ReactApplicationContext): NativeModule? {
        return when (name) {
            LineChartSpecManager.REACT_CLASS -> LineChartSpecManager(reactApplicationContext)
            else -> null
        }
    }

    override fun getReactModuleInfoProvider(): ReactModuleInfoProvider = ReactModuleInfoProvider {
        mapOf(
            LineChartSpecManager.REACT_CLASS to ReactModuleInfo(
                _name = LineChartSpecManager.REACT_CLASS,
                _className = LineChartSpecManager.REACT_CLASS,
                _canOverrideExistingModule = false,
                _needsEagerInit = false,
                isCxxModule = false,
                isTurboModule = true,
            )
        )
    }
}

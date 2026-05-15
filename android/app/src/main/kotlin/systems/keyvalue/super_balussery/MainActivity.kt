package systems.keyvalue.super_balussery

import android.content.ComponentName
import android.content.pm.PackageManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channel = "systems.keyvalue.super_balussery/app_icon"

    private val allAliases = listOf(
        "systems.keyvalue.super_balussery.DefaultAlias",
        "systems.keyvalue.super_balussery.BalusseryAlias",
        "systems.keyvalue.super_balussery.KoduvalliAlias",
        "systems.keyvalue.super_balussery.PerambraAlias",
    )
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel).setMethodCallHandler { call, result ->
            if (call.method == "setIcon") {
                val alias = call.argument<String?>("alias")
                try {
                    setActiveAlias(alias)
                    result.success(null)
                } catch (e: Exception) {
                    result.error("ICON_ERROR", e.message, null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun setActiveAlias(targetAlias: String?) {
        val pm = packageManager
        // null means "reset to default" — enable DefaultAlias, disable constituency aliases.
        val targetFull = "$packageName.${targetAlias ?: "DefaultAlias"}"

        allAliases.forEach { alias ->
            val component = ComponentName(packageName, alias)
            val state = if (alias == targetFull)
                PackageManager.COMPONENT_ENABLED_STATE_ENABLED
            else
                PackageManager.COMPONENT_ENABLED_STATE_DISABLED
            pm.setComponentEnabledSetting(component, state, PackageManager.DONT_KILL_APP)
        }
    }
}

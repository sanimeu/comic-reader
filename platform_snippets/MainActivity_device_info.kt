// Drop into android/app/src/main/kotlin/<your/package>/MainActivity.kt after `flutter create .`
// Supplies the signal GlassQualityResolver uses to pick a default (NOT yet device-tested).
import android.app.ActivityManager
import android.content.Context
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "comic_reader/device")
            .setMethodCallHandler { call, result ->
                if (call.method == "perfClass") {
                    val am = getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
                    result.success(mapOf(
                        "isLowRamDevice" to am.isLowRamDevice,
                        "memoryClassMb" to am.memoryClass,
                        "sdkInt" to Build.VERSION.SDK_INT
                    ))
                } else result.notImplemented()
            }
    }
}

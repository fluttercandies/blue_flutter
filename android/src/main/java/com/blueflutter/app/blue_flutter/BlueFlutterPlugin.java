package com.blueflutter.app.blue_flutter;

import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.content.pm.PackageManager;
import android.util.Log;
import android.widget.Toast;

import androidx.annotation.NonNull;

import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * BlueFlutterPlugin
 */
public class BlueFlutterPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    public String TAG = "BlueFlutterPlugin";

    private MethodChannel channel;
    private static final int REQUEST_FINE_LOCATION_PERMISSIONS = 1452;
    private Context context;
    private Activity activity;
    private final BlueToothUtils blueToothUtils = new BlueToothUtils();

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "blue_flutter");
        channel.setMethodCallHandler(this);

    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if (blueToothUtils.mContext == null && context != null) {
            blueToothUtils.setContext(context);
        }
        switch (call.method) {
            case "getPlatformVersion":
                result.success("Android " + android.os.Build.VERSION.RELEASE);
                break;
            case "showToast":
                Toast.makeText(context, "Test", Toast.LENGTH_SHORT).show();
                result.success("Android " + android.os.Build.VERSION.RELEASE);
                break;
            case "permission":
                assert context != null;
                if (ContextCompat.checkSelfPermission(context, Manifest.permission.ACCESS_FINE_LOCATION)
                        != PackageManager.PERMISSION_GRANTED) {
                    ActivityCompat.requestPermissions(
                            activity,
                            new String[]{
                                    Manifest.permission.ACCESS_FINE_LOCATION
                            },
                            REQUEST_FINE_LOCATION_PERMISSIONS);
                }
                result.success("权限申请");
                break;
            case "isOpenBlue":
                result.success(blueToothUtils.getBA().isEnabled());
                break;
            case "openBlue":
                boolean isEnable = blueToothUtils.getBA().enable();
                Log.e(TAG, "isEnable" + isEnable);
                result.success(isEnable);
                break;
            case "closeBlue":
                boolean isDisable = blueToothUtils.getBA().disable();
                Log.e(TAG, "isDisable" + isDisable);
                result.success(isDisable);
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
        context = binding.getApplicationContext();
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        context = binding.getActivity().getApplicationContext();
        activity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {

    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        context = binding.getActivity().getApplicationContext();
        activity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivity() {

    }
}

package com.blueflutter.app.blue_flutter;

import android.Manifest;
import android.app.Activity;
import android.bluetooth.BluetoothDevice;
import android.content.Context;
import android.content.pm.PackageManager;
import android.util.Log;
import android.widget.Toast;

import com.google.gson.Gson;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

        if (blueToothUtils.mContext == null && context != null) {
            blueToothUtils.setContext(context);
        }
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        switch (call.method) {
            case "getPlatformVersion":
                result.success("Android " + android.os.Build.VERSION.RELEASE);
                break;
            case "showToast":
                Toast.makeText(context, "Test", Toast.LENGTH_SHORT).show();
                result.success("Android " + android.os.Build.VERSION.RELEASE);
                break;
            case "permission":
                reqPermission();
                result.success(ContextCompat.checkSelfPermission(context, Manifest.permission.ACCESS_FINE_LOCATION)
                        == PackageManager.PERMISSION_GRANTED);
                break;
            case "isOpenBlue":
                result.success(blueToothUtils.getBA().isEnabled());
                break;
            case "openBlue":
                reqPermission();
                boolean isEnable = blueToothUtils.getBA().enable();
                Log.e(TAG, "isEnable::" + isEnable);
                result.success(isEnable);
                break;
            case "closeBlue":
                reqPermission();
                boolean isDisable = blueToothUtils.getBA().disable();
                Log.e(TAG, "isDisable::" + isDisable);
                result.success(isDisable);
                break;
            case "getBondedDevices":
                reqPermission();
                List<BluetoothDevice> data = blueToothUtils.getBondedDevices();
                List<HashMap<Object, Object>> resultMap = new ArrayList<>();

                if (data.size() > 0) {
                    for (BluetoothDevice device : data) {
                        HashMap<Object, Object> inMap = new HashMap<>();
                        inMap.put("name", device.getName());
                        inMap.put("address", device.getAddress());
                        resultMap.add(inMap);
                    }
                }

                Log.e(TAG, "已配对蓝牙::" + new Gson().toJson(resultMap));
                result.success(new Gson().toJson(resultMap));
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    void reqPermission() {
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

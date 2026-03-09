package com.peoplewareinnovations.bluetooth_thermal_printer

import android.app.Activity
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothClass
import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build
import android.util.Log
import android.widget.Toast
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
// import io.flutter.plugin.common.PluginRegistry.Registrar
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.io.OutputStream
import java.util.*
import androidx.annotation.NonNull
import io.flutter.plugin.common.EventChannel





private const val TAG = "i/flutter mio: "
private var outputStream: OutputStream? = null
private lateinit var mac: String
//val REQUEST_ENABLE_BT = 2

class BluetoothThermalPrinterPlugin: FlutterPlugin, MethodCallHandler{
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var mContext: Context
  private lateinit var channel : MethodChannel
  private lateinit var eventChannel: EventChannel

  private var state:String = "false"
  private var pairedDevices:MutableSet<BluetoothDevice> = mutableSetOf()
  private  lateinit var  printerHandler : PrinterHandler
  private var eventSink: EventChannel.EventSink? = null

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "bluetooth_thermal_printer")
    channel.setMethodCallHandler(this)
    this.mContext = flutterPluginBinding.applicationContext
    printerHandler = PrinterHandler(this.mContext)

    eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "bluetooth_thermal_printer_event")
    eventChannel.setStreamHandler(eventStreamHandler)

    val filter = IntentFilter(BluetoothDevice.ACTION_ACL_DISCONNECTED)
    mContext.registerReceiver(printerHandler.bluetoothReceiver, filter)

  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    onMethodCallHandlerNew(call,result)
  }

  val eventStreamHandler = object : EventChannel.StreamHandler {
    override fun onListen(arguments: Any?, events: EventChannel.EventSink)
    {
      eventSink = events
      printerHandler.attachEventSink(events)


    }

    override fun onCancel(arguments: Any?) {
      eventSink = null
      printerHandler.removeEventSink()

    }
  }


  private  fun onMethodCallHandlerNew(@NonNull call: MethodCall, @NonNull result: Result){
    val method = call.method
    println("i/flutter method :: ${method}")
    if (method == "BluetoothStatus"){
      var stauts =  printerHandler.bluetoothEnable()
        result.success("${stauts}")


      return
    }
    if (method == "connectionStatus"){
      var stauts = printerHandler.IsBluetoothInitialized()
      result.success("${stauts}")
      return
    }

    if (method == "disconnectPrinter"){
      var stauts = printerHandler.disconnectPrinter()
      result.success("${stauts}")
      return
    }


    if (method == "closetPrinter"){
       printerHandler.close()
      result.success("true")
      return
    }




    if (method == "connectPrinter"){
      var printerMAC = call.arguments.toString();
      printerHandler.setBluetoothAddress(printerMAC)

      var stauts = printerHandler.IsBluetoothInitialized()
      if(!stauts){
        printerHandler.ConnectUsingGlobalScope()
      }
      result.success("${stauts}")
      return
    }

    if (method == "writeBytes"){
      var lista: List<Int> = call.arguments as List<Int>
      var stauts =  printerHandler.makeprintUsingBytesInChunks(lista)
//      var stauts =  printerHandler.makeprintUsingBytes(lista)
      println("stauts ${method} :: ${stauts}")
      result.success("${stauts}")
      return
    }

    if (method == "bluetothLinked"){
      var stauts =  printerHandler.getLinkedDevices()
      result.success(stauts)
      return
    }

    result.notImplemented()

  }




  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
    printerHandler.close()
  }
}




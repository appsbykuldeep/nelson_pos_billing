package com.peoplewareinnovations.bluetooth_thermal_printer

import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothSocket
//import kotlinx.coroutines.GlobalScope
import android.content.Context
import android.content.Intent
import android.util.Log
import android.widget.Toast
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import java.io.OutputStream
import java.io.InputStream
import java.io.IOException
import java.util.*
import kotlinx.coroutines.*
import io.flutter.plugin.common.EventChannel
import androidx.lifecycle.lifecycleScope
import android.os.Handler
import android.os.Looper
import android.bluetooth.BluetoothManager

import android.content.BroadcastReceiver




class PrinterHandler{


    private lateinit var mContext: Context
    public var state:String = "false"
    private var pairedDevices:MutableSet<BluetoothDevice> = mutableSetOf()
    private var TAG = "i/flutter mio: "
    private var bluetoothSocket: BluetoothSocket? = null
    private var outputStream: OutputStream? = null
    private var inputStream: InputStream? = null
    private var bluetoothAddress: String = ""
    private var lastbluetoothAddress: String = ""
    private var eventSink: EventChannel.EventSink? = null
    private  var isPrinting:Boolean = false
    private  var isConnecting:Boolean = false

    private val cmdPrintStart = byteArrayOf(0x10.toByte(), 0xFF.toByte(), 0xFE.toByte(), 0x01.toByte())
    private val cmdPrintEnd = byteArrayOf(0x1B.toByte(), 0x4A.toByte(), 0x40.toByte(), 0x10.toByte(), 0xFF.toByte(), 0xFE.toByte(), 0x45.toByte())



    constructor(mContext: Context) {
        this.mContext = mContext

    }



    public val bluetoothReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {

            try {
                val action = intent?.action
                if (action == BluetoothDevice.ACTION_ACL_DISCONNECTED) {
                    val device: BluetoothDevice? =
                        intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE)
                    println("Device disconnected: ${device?.address}")
                    if (device?.address == bluetoothAddress) {
                        disconnectPrinter();

                    }
                }

                if (action == BluetoothDevice.ACTION_FOUND) {
                    val device: BluetoothDevice? =
                        intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE)
                    println("Device disconnected: ${device?.address}")
                    if (device?.address == lastbluetoothAddress) {
                        setBluetoothAddress(lastbluetoothAddress);
                        var stauts = IsBluetoothInitialized()
                        if(!stauts){
                            ConnectUsingGlobalScope()
                        }

                    }
                }

            } catch (closeException: IOException) {
                Log.e(TAG, "bluetoothReceiver: ${closeException.message}", closeException)
            }


        }
    }




    public  fun  disposeBluetoothStreams(){
        try {
            inputStream?.close()
            outputStream?.close()
            bluetoothSocket?.close()
            inputStream = null
            outputStream = null
            bluetoothSocket = null
            bluetoothAddress = ""
            isConnecting = false
            state = "false"
        } catch (closeException: IOException) {
            Log.e(TAG, "Failed to close outputStream: ${closeException.message}", closeException)
        }

    }

    fun  attachEventSink(event: EventChannel.EventSink ){
        eventSink = event

    }

    fun  removeEventSink( ){
        eventSink = null
    }

    fun getEventBody():HashMap<String, Any?>{
        val body = hashMapOf<String, Any?>()
        body["bluetoothAddress"] = bluetoothAddress
        body["state"] = state
        body["bluetoothSocket"] = bluetoothSocket != null
        body["outputStream"] = outputStream != null
        body["inputStream"] = inputStream != null
        body["isConnected"] =  bluetoothSocket?.isConnected
        body["isConnecting"] = isConnecting
        return  body
    }

    fun  SendEvent(processName:String?=null,processStatus:Boolean? = null,extra:HashMap<String, Any?>?=null){
        try {
            var body = getEventBody()
            if(processName !=null){
                if(processStatus == null){
                    body["processName"] = processName
                }else{
                    if(processStatus!!){
                        body["processName"] = "${processName}_End"
                    }else{
                        body["processName"] = "${processName}_Start"
                    }

                }


            }
            if(extra != null){
                body.putAll(extra)
            }
            eventSink?.success(body)
        }catch (e: InterruptedException){
            println("errror : $e")
        }
    }



    fun  SendEventFromMainThred(processName:String?=null,processStatus:Boolean? = null,extra:HashMap<String, Any?>?=null){
        Handler(Looper.getMainLooper()).post {
            SendEvent(processName = processName,processStatus = processStatus,extra = extra)
        }
    }


    private  fun getBluetoothAdapter():BluetoothAdapter?{
        try {
             val bluetoothManager: BluetoothManager =
                 mContext.getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager
             val bluetoothAdapter: BluetoothAdapter? = bluetoothManager.adapter
            return bluetoothAdapter
        }catch (e: Exception){
            return null;
        }
    }




     public  fun bluetoothEnable():Boolean{
        try {
            val bluetoothAdapter = BluetoothAdapter.getDefaultAdapter()
            if (bluetoothAdapter != null && bluetoothAdapter.isEnabled){
                return true
            }
            return  false
        }catch (e: Exception){
            return  false
        }
    }


//    public fun enablebluetooth(){
//        val enableBtIntent = Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE)
//        startActivityForResult(enableBtIntent, 1)
//
//    }

    public fun setpairedDevices(){

        val bluetoothAdapter = BluetoothAdapter.getDefaultAdapter()
        if (bluetoothAdapter != null && bluetoothAdapter.isEnabled){
            pairedDevices = bluetoothAdapter.bondedDevices
        }


        Log.d(TAG, "connected to $pairedDevices")

    }


    public  fun isDeviceConnected(device:BluetoothDevice):Boolean{

        try {
            if (pairedDevices.contains(device)) {
                return  true
            } else {
                return  false
            }

        }catch (e: Exception){
            return  false
        }

    }

    public fun disconnectPrinter():String{
        SendEvent(processName = "disconnectPrinter", processStatus = false)
        disposeBluetoothStreams()
        SendEvent(processName = "disconnectPrinter", processStatus = true)
        return  state
    }

    public fun getLinkedDevices():List<HashMap<String, Any?>>{

        SendEvent(processName = "getLinkedDevices", processStatus = false)
        val listItems: MutableList<HashMap<String, Any?>> = mutableListOf()

        val bluetoothAdapter: BluetoothAdapter? = BluetoothAdapter.getDefaultAdapter()
        if (bluetoothAdapter == null  || bluetoothAdapter?.isEnabled == false) {
            disposeBluetoothStreams()
        }else{

            val pairedDevices: Set<BluetoothDevice>? = bluetoothAdapter?.bondedDevices
            pairedDevices?.forEach { device ->
                val deviceName = device.name
                val deviceHardwareAddress = device.address
                val deviceType = device.type

                val majorDeviceClass = device.bluetoothClass?.majorDeviceClass
                val deviceClass = device.bluetoothClass?.deviceClass

                val map1 = hashMapOf<String, Any?>()
                map1["deviceName"] = deviceName
                map1["address"] = deviceHardwareAddress
                map1["deviceType"] = deviceType
                map1["majorDeviceClass"] = majorDeviceClass
                map1["deviceClass"] = deviceClass
                listItems.add(map1)
            }


        }

       SendEvent(processName = "getLinkedDevices", processStatus = true)
        return listItems;
    }


    public  fun  setBluetoothAddress(address:String){
        bluetoothAddress = address
    }

    public  fun IsBluetoothInitialized():Boolean{
        return bluetoothSocket?.isConnected == true
//        return  bluetoothSocket != null
    }


//    public  fun ConnectUsinglifecycleScope(){
//        SendEvent()
//        lifecycleScope.launch(Dispatchers.IO) {
//
//        }
//    }



    public  fun ConnectUsingGlobalScope(){
//        if(isConnecting){
//            return
//        }
        isConnecting = true
        SendEvent(processName = "connectPrinter", processStatus = false)

        if(!IsBluetoothInitialized()){
            GlobalScope.launch(Dispatchers.Main) {
                connectPrinterWithContext()
            }
        // Don't call SendEvent here becouse now it will call from backend thred.
        }else{
            isConnecting = false
            SendEvent(processName = "connectPrinter", processStatus = true)
        }


    }


    public  fun connectAndPrint(bluetoothAddress:String,lista :List<Int>){

        try {
//            val bluetoothAdapter = getBluetoothAdapter()
            val bluetoothAdapter = BluetoothAdapter.getDefaultAdapter()
            if (bluetoothAdapter != null && bluetoothAdapter.isEnabled && bluetoothAddress.isNotEmpty()){
                val bluetoothDevice = bluetoothAdapter.getRemoteDevice(bluetoothAddress)
               var bluetoothSocket = bluetoothDevice.createRfcommSocketToServiceRecord(
                        UUID.fromString("00001101-0000-1000-8000-00805F9B34FB")
                )

                bluetoothAdapter.cancelDiscovery()
                bluetoothSocket!!.connect()
                if (bluetoothSocket!!.isConnected){
                  var  outputStream = bluetoothSocket!!.outputStream
                    val bytes = lista.map { it.toByte() }.toByteArray()
                    outputStream?.apply {
                        write(bytes)
                        flush()
                    }

                    lastbluetoothAddress = bluetoothAddress

                }

            }

        }catch (e: IOException){

        }


    }

    public  fun connectPrinter() {

        outputStream = null
        inputStream = null
        bluetoothSocket = null
        state = "false"
        val bluetoothAdapter = BluetoothAdapter.getDefaultAdapter()
        if (bluetoothAdapter != null && bluetoothAdapter.isEnabled && bluetoothAddress.isNotEmpty()) {
            try {

                val bluetoothDevice = bluetoothAdapter.getRemoteDevice(bluetoothAddress)
                bluetoothSocket = bluetoothDevice.createRfcommSocketToServiceRecord(
                        UUID.fromString("00001101-0000-1000-8000-00805F9B34FB")
                )

                bluetoothAdapter.cancelDiscovery()
                bluetoothSocket!!.connect()

                if (bluetoothSocket!!.isConnected) {
                    outputStream = bluetoothSocket!!.outputStream
                    inputStream = bluetoothSocket!!.inputStream
                    state = "true"
                    Log.d(TAG, "Connected to $bluetoothAddress")
                } else {
                    state = "false"
                    Log.d(TAG, "Disconnected")
                }

            } catch (e: IOException) {
                disposeBluetoothStreams()
                state = "false"
                Log.e(TAG, "Connection error: , ${e}")
            }

            lastbluetoothAddress = bluetoothAddress
        } else {
            state = "false"
            Log.d(TAG, "Bluetooth adapter is null or disabled")
        }

        isConnecting = false

        SendEventFromMainThred(processName = "connectPrinter", processStatus = true)



    }


    public suspend fun connectPrinterWithContext() {
        withContext(Dispatchers.IO) {
            connectPrinter()
        }
    }

    public  fun checkPrinterPing(
        timeoutMs: Long = 500
    ): Boolean {


        return try {

            if(outputStream == null || inputStream == null || !IsBluetoothInitialized()) {
                return  false
            }


            val pingCommand = byteArrayOf(0x10, 0x04, 0x01) // DLE EOT 1
            val buffer = ByteArray(64)


            outputStream!!.write(pingCommand)
            outputStream!!.flush()

            val startTime = System.currentTimeMillis()
            while (System.currentTimeMillis() - startTime < timeoutMs) {
                if (inputStream!!.available() > 0) {
                    val bytesRead = inputStream!!.read(buffer)
                    if (bytesRead > 0) {
                        return true
                    }
                }
                Thread.sleep(50)
            }
            false // Timeout
        } catch (e: IOException) {
            e.printStackTrace()
            false
        }
    }



    // Check if printer is ready
    public  fun isPrinterReady(): Boolean {
        SendEvent(processName = "isPrinterReady", processStatus = false)
        var ptStatus = false
        try {
            val statusCommand = byteArrayOf(0x10, 0x04, 0x01) // DLE EOT 1 command
            outputStream?.write(statusCommand)

            // Check response (blocking call, read response bytes)
            val response = ByteArray(1)
            bluetoothSocket?.inputStream?.read(response)

            // Analyze response (varies by printer, this example assumes 0x00 = Ready)
            ptStatus =  response.isNotEmpty() && response[0].toInt() == 0x00
        } catch (e: Exception) {
            e.printStackTrace()
            ptStatus = false
        }
        println(TAG + " isPrinterReady ${ptStatus}")
        SendEvent(processName = "isPrinterReady", processStatus = true)
        return  ptStatus
    }




    public fun makeprintUsingBytes(lista: List<Int>):Boolean{

        var printStatus = false
        SendEvent(processName = "makeprintUsingBytes", processStatus = false)

        val bytes = lista.map { it.toByte() }.toByteArray()

        if(!IsBluetoothInitialized()){
            ConnectUsingGlobalScope()
        }

        if(outputStream != null) {
            try{

                outputStream?.apply {
                    write(bytes)
                    flush()
                }

                printStatus = true
            }catch (e: Exception){
                disposeBluetoothStreams()
                ShowToast("Device was disconnected, reconnect")

            }
        }
        SendEvent(processName = "makeprintUsingBytes", processStatus = true)
        return  printStatus
    }


    public fun makeprintUsingBytesInChunks(lista: List<Int>):Boolean{

        var printStatus = false
        isPrinting = true
        SendEvent(processName = "makeprintUsingBytesInChunks", processStatus = false)

        val chunkSize = 999999
        // val chunkSize = 3072
//        val chunkSize = 512
        val bytes = lista.map { it.toByte() }.toByteArray()


        if(IsBluetoothInitialized() && outputStream != null) {
            try{

                var totalBytes = bytes.size
                var bytesSent = 0


                while (bytesSent < totalBytes) {
                    // Determine the end index for the current chunk
                    val end = minOf(bytesSent + chunkSize, bytes.size)
                    outputStream?.write(bytes, bytesSent, end - bytesSent)
//                    Thread.sleep(50)
//                    outputStream?.flush()
                    bytesSent = end

                    println(TAG + " chunkSize ${chunkSize} :: bytesSent ${bytesSent} :: bytes.size ${totalBytes}")
                }

                outputStream?.flush()

//                printStatus = isPrinterReady()
                printStatus = true
            }catch (e: Exception){
                println(TAG + " makeprintUsingBytesInChunks ${e}")
//                disposeBluetoothStreams()


            }
        }else{
            println(TAG + "Outstrem is null")
            ShowToast("Device was disconnected, reconnect")
        }
        isPrinting = false
        SendEvent(processName = "makeprintUsingBytesInChunks", processStatus = true)
        return  printStatus
    }




    public fun makeprintUsingBytesInChunksV1(lista: List<Int>):Boolean{

        var printStatus = false
        isPrinting = true
        SendEvent(processName = "makeprintUsingBytesInChunks", processStatus = false)

        val chunkSize = 1024
//        val chunkSize = 512
        val bytes = lista.map { it.toByte() }.toByteArray()
        var totalBytes = bytes.size
        var bytesSent = 0

        if(outputStream != null) {
            try{

                var offset = 0
                while (offset < totalBytes) {
                    // Determine the end index for the current chunk
                    val end = minOf(offset + chunkSize, bytes.size)
                    outputStream?.write(bytes, offset, end - offset)
                    Thread.sleep(20)
                    outputStream?.flush()
                    bytesSent = end
                    offset += chunkSize
                    println(TAG + " offset ${offset} :: chunkSize ${chunkSize} :: bytesSent ${bytesSent} :: bytes.size ${totalBytes}")
                }

                outputStream?.flush()

//                printStatus = isPrinterReady()
                printStatus = true
            }catch (e: Exception){
                println(TAG + " makeprintUsingBytesInChunks ${e}")
//                disposeBluetoothStreams()


            }
        }else{
            println(TAG + "Outstrem is null")
            ShowToast("Device was disconnected, reconnect")
        }
        isPrinting = false
        SendEvent(processName = "makeprintUsingBytesInChunks", processStatus = true)
        return  printStatus
    }
    // Never use it. It blocked main thred.
//    fun isPrinterReady(): Boolean {
//        var status = false
//        try {
//            val buffer = ByteArray(1)
//            val bytesRead = inputStream?.read(buffer) ?: 0
//            if (bytesRead > 0) {
//                status =   buffer.copyOf(bytesRead)[0] == 0.toByte()
//            }
//        } catch (e: IOException){
//            status = false
//        }
//
//        return status
//    }



    public fun makeprintUsingString(stringArrived: String):Boolean{
        var printStatus = false

        if(outputStream != null) {
            try{
                var size:Int = 0
                var texto:String = ""
                var line = stringArrived.split("//")
                //Log.d(TAG, "list arrived: ${line.size}")
                if(line.size>1) {
                    size = line[0].toInt()
                    texto = line[1]
                    if (size < 1 || size > 5) size = 2
                }else{
                    size = 2
                    texto = stringArrived
                    //Log.d(TAG, "list came 2 text: ${texto} size: $size")
                }

                outputStream?.run {
                    write(setBytes.size[0])
                    write(setBytes.cancelar_chino)
                    write(setBytes.caracteres_escape)
                    write(setBytes.size[size])
                    write(texto.toByteArray(charset("iso-8859-1")))
                    printStatus = true
                }
            }catch (e: Exception){
                disposeBluetoothStreams()
                ShowToast("Device was disconnected, reconnect")
            }
        }
        return  printStatus
    }


    public fun ShowToast(message: String){
        Toast.makeText(mContext, message, Toast.LENGTH_SHORT).show()
    }

    private fun handleCommunication() {
        try {

            if(inputStream != null){
                val buffer = ByteArray(1024)
                val bytesRead = inputStream!!.read(buffer)
                val receivedMessage = String(buffer, 0, bytesRead)
                Log.d("Bluetooth", "Received message: $receivedMessage")

            }

        } catch (e: IOException) {
            Log.e("Bluetooth", "Error during communication: ${e.message}")
        }
    }


    fun close(){
        removeEventSink()
        disposeBluetoothStreams()

    }





}




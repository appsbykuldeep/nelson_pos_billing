package com.peoplewareinnovations.bluetooth_thermal_printer
import java.util.*


class setBytes(){
    companion object {
        //val info = "This is info"
        //fun getMoreInfo():String { return "This is more fun" }

        val enter = "\n".toByteArray()
        val resetear_impresora = byteArrayOf(0x1b, 0x40, 0x0a)
        val cancelar_chino = byteArrayOf(0x1C, 0x2E)
        val caracteres_escape = byteArrayOf(0x1B, 0x74, 0x10)

        val size = arrayOf(
            byteArrayOf(0x1d, 0x21, 0x00), // La fuente no se agranda 0
            byteArrayOf(0x1b, 0x4d, 0x01), // Fuente ASCII comprimida 1
            byteArrayOf(0x1b, 0x4d, 0x00), //Fuente estándar ASCII    2
            byteArrayOf(0x1d, 0x21, 0x11), // Altura doblada 3
            byteArrayOf(0x1d, 0x21, 0x22), // Altura doblada 4
            byteArrayOf(0x1d, 0x21, 0x33) // Altura doblada 5
        )


        //deprecated codes
        const val HT: Byte = 9
        const val LF: Byte = 10
        const val CR: Byte = 13
        const val ESC: Byte = 27
        const val DLE: Byte = 16
        const val GS: Byte = 29
        const val FS: Byte = 28
        const val STX: Byte = 2
        const val US: Byte = 31
        const val CAN: Byte = 24
        const val CLR: Byte = 12
        const val EOT: Byte = 4
        val INIT = byteArrayOf(27, 64)
        var FEED_LINE = byteArrayOf(10)
        var SELECT_FONT_A = byteArrayOf(20, 33, 0)
        var SET_BAR_CODE_HEIGHT = byteArrayOf(29, 104, 100)
        var PRINT_BAR_CODE_1 = byteArrayOf(29, 107, 2)
        var SEND_NULL_BYTE = byteArrayOf(0)
        var SELECT_PRINT_SHEET = byteArrayOf(27, 99, 48, 2)
        var FEED_PAPER_AND_CUT = byteArrayOf(29, 86, 66, 0)
        var SELECT_CYRILLIC_CHARACTER_CODE_TABLE = byteArrayOf(27, 116, 17)
        var SELECT_BIT_IMAGE_MODE = byteArrayOf(27, 42, 33, -128, 0)
        var SET_LINE_SPACING_24 = byteArrayOf(27, 51, 24)
        var SET_LINE_SPACING_30 = byteArrayOf(27, 51, 30)
        var TRANSMIT_DLE_PRINTER_STATUS = byteArrayOf(16, 4, 1)
        var TRANSMIT_DLE_OFFLINE_PRINTER_STATUS = byteArrayOf(16, 4, 2)
        var TRANSMIT_DLE_ERROR_STATUS = byteArrayOf(16, 4, 3)
        var TRANSMIT_DLE_ROLL_PAPER_SENSOR_STATUS = byteArrayOf(16, 4, 4)
        val ESC_FONT_COLOR_DEFAULT = byteArrayOf(27, 114, 0)
        val FS_FONT_ALIGN = byteArrayOf(28, 33, 1, 27, 33, 1)
        val ESC_ALIGN_LEFT = byteArrayOf(27, 97, 0)
        val ESC_ALIGN_RIGHT = byteArrayOf(27, 97, 2)
        val ESC_ALIGN_CENTER = byteArrayOf(27, 97, 1)
        val ESC_CANCEL_BOLD = byteArrayOf(27, 69, 0)
        val ESC_HORIZONTAL_CENTERS = byteArrayOf(27, 68, 20, 28, 0)
        val ESC_CANCLE_HORIZONTAL_CENTERS = byteArrayOf(27, 68, 0)
        val ESC_ENTER = byteArrayOf(27, 74, 64)
        val PRINTE_TEST = byteArrayOf(29, 40, 65)
    }
}


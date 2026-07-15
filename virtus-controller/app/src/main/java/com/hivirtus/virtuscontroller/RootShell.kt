package com.hivirtus.virtuscontroller

import java.io.BufferedReader
import java.io.InputStreamReader
import java.util.concurrent.TimeUnit

object RootShell {
    data class Result(val exitCode: Int, val stdout: String, val stderr: String) {
        val ok: Boolean get() = exitCode == 0
    }

    fun run(command: String, timeoutSec: Long = 120): Result {
        return try {
            val proc = Runtime.getRuntime().exec(arrayOf("su", "-c", command))
            val finished = proc.waitFor(timeoutSec, TimeUnit.SECONDS)
            if (!finished) {
                proc.destroyForcibly()
                return Result(-1, "", "timeout")
            }
            val out = proc.inputStream.bufferedReader().use(BufferedReader::readText)
            val err = proc.errorStream.bufferedReader().use(BufferedReader::readText)
            Result(proc.exitValue(), out.trim(), err.trim())
        } catch (e: Exception) {
            Result(-1, "", e.message ?: "error")
        }
    }

    fun hasRoot(): Boolean = run("id").stdout.contains("uid=0")
}

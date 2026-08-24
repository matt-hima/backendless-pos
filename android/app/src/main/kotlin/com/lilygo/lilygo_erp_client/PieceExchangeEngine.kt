package com.lilygo.lilygo_erp_client

import org.webrtc.DataChannel
import java.nio.ByteBuffer
import java.security.MessageDigest
import java.util.PriorityQueue
import java.util.concurrent.ConcurrentHashMap

/**
 * Native piece exchange used by the Android processor layer.
 * Flutter only supplies the UI and asks this class for progress.
 */
class PieceExchangeEngine(
    private val pieceSize: Int = 256 * 1024
) {
    data class Piece(val index: Int, val hash: ByteArray, val length: Int)

    private data class Availability(val index: Int, var peers: Int) : Comparable<Availability> {
        override fun compareTo(other: Availability): Int = peers - other.peers
    }

    private val pieces = ConcurrentHashMap<Int, Piece>()
    private val availability = ConcurrentHashMap<Int, Int>()
    private val channels = ConcurrentHashMap<String, DataChannel>()
    private val received = ConcurrentHashMap<Int, ByteArray>()

    fun registerPeer(peerId: String, channel: DataChannel) {
        channels[peerId] = channel
        channel.registerObserver(object : DataChannel.Observer {
            override fun onBufferedAmountChange(previousAmount: Long) = Unit
            override fun onStateChange() = Unit
            override fun onMessage(buffer: DataChannel.Buffer) {
                if (!buffer.binary) return
                acceptFrame(buffer.data)
            }
        })
    }

    fun removePeer(peerId: String) {
        channels.remove(peerId)?.unregisterObserver()
    }

    fun announce(index: Int, hash: ByteArray, length: Int, peerCount: Int) {
        pieces[index] = Piece(index, hash, length)
        availability[index] = peerCount
    }

    /** Rarest-first selection, with index as a deterministic tie-breaker. */
    fun nextPiece(): Int? {
        val queue = PriorityQueue<Availability>()
        availability.forEach { (index, peers) ->
            if (!received.containsKey(index)) queue.add(Availability(index, peers))
        }
        return queue.poll()?.index
    }

    fun sendPiece(peerId: String, index: Int, bytes: ByteArray): Boolean {
        val channel = channels[peerId] ?: return false
        val frame = ByteBuffer.allocate(8 + bytes.size)
            .putInt(index)
            .putInt(bytes.size)
            .put(bytes)
            .array()
        return channel.send(DataChannel.Buffer(ByteBuffer.wrap(frame), true))
    }

    fun acceptFrame(frame: ByteBuffer) {
        if (frame.remaining() < 8) return
        val index = frame.int
        val length = frame.int
        if (length < 0 || length > frame.remaining()) return
        val bytes = ByteArray(length)
        frame.get(bytes)
        val expected = pieces[index] ?: return
        if (sha256(bytes).contentEquals(expected.hash)) received[index] = bytes
    }

    fun progress(): Map<String, Any> = mapOf(
        "pieceSize" to pieceSize,
        "totalPieces" to pieces.size,
        "receivedPieces" to received.size,
        "nextPiece" to (nextPiece() ?: -1)
    )

    private fun sha256(bytes: ByteArray): ByteArray =
        MessageDigest.getInstance("SHA-256").digest(bytes)
}

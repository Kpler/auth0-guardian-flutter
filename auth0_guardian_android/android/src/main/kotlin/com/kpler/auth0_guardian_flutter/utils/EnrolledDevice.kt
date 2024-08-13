import android.provider.Settings
import com.auth0.android.guardian.sdk.Enrollment
import java.security.PrivateKey

/**
 * We don't implement all the methods of the Enrollment interface because we don't need them.
 * Only the signing key is required to allow the incoming login requests from Guardian.
 */
class EnrolledDevice(private val signingKey: PrivateKey) : Enrollment {

    private var userId: String? = null

    private var enrollmentId: String? = null

    /**
     * This secondary constructor is used to create an instance of EnrolledDevice with the userId and enrollmentId.
     * This will be used only to un-enroll the device.
     */
    constructor(
        signingKey: PrivateKey,
        userId: String,
        enrollmentId: String
    ) : this(signingKey) {
        this.userId = userId
        this.enrollmentId = enrollmentId
    }

    override fun getSigningKey(): PrivateKey {
        return this.signingKey
    }

    override fun getUserId(): String {
        if (userId == null) {
            throw IllegalStateException("userId is not set.")
        }
        return userId!!
    }

    override fun getId(): String {
        if (userId == null) {
            throw IllegalStateException("enrollmentId is not set?")
        }
        return enrollmentId!!
    }

    /**
     * By default, Guardian [CurrentDevice.java] set the identifier to this value.
     */
    override fun getDeviceIdentifier(): String {
        return Settings.Secure.ANDROID_ID
    }

    override fun getPeriod(): Int? {
        TODO("Not yet implemented")
    }

    override fun getDigits(): Int? {
        TODO("Not yet implemented")
    }

    override fun getAlgorithm(): String? {
        TODO("Not yet implemented")
    }

    override fun getSecret(): String? {
        TODO("Not yet implemented")
    }

    override fun getDeviceName(): String {
        TODO("Not yet implemented")
    }

    override fun getNotificationToken(): String {
        TODO("Not yet implemented")
    }

    override fun getDeviceToken(): String {
        TODO("Not yet implemented")
    }
}

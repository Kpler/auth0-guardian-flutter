package com.kpler.auth0_guardian_flutter.utils

import android.security.keystore.KeyGenParameterSpec
import android.security.keystore.KeyProperties
import java.security.KeyPair
import java.security.KeyPairGenerator
import java.security.KeyStore
import java.security.PrivateKey

class SigningKeyService(private val domain: String) {
    private val keyStoreType = "AndroidKeyStore"

    /** The tag used to store the signing key in the keystore. */
    private var tag: String = "mfa_signing_key#$domain"

    /** Generate a new signing key and store it in the keystore. */
    fun generateSigningKey(): KeyPair {
        // Define the key generation parameters.
        val paramSpecBuilder = KeyGenParameterSpec.Builder(tag, KeyProperties.PURPOSE_SIGN)
        paramSpecBuilder.setKeySize(2048)
        paramSpecBuilder.setDigests(KeyProperties.DIGEST_SHA256)
        paramSpecBuilder.setSignaturePaddings(KeyProperties.SIGNATURE_PADDING_RSA_PKCS1)
        paramSpecBuilder.setEncryptionPaddings(KeyProperties.ENCRYPTION_PADDING_RSA_PKCS1)

        // Creating a generator and generating the key pair using the parameters.
        val generator = KeyPairGenerator.getInstance(KeyProperties.KEY_ALGORITHM_RSA, keyStoreType)
        generator.initialize(paramSpecBuilder.build())
        return generator.generateKeyPair()
    }

    /**
     * Get the private signing key from the keystore The [generateSigningKey] method must be called
     * before this method. The key is stored in the keystore with the tag [tag].
     */
    fun getSigningKey(): PrivateKey {
        // Load the keystore and get the key pair.
        val keyStore: KeyStore = KeyStore.getInstance(keyStoreType)
        keyStore.load(null)
        // Get the private key from the pair.
        val entry = keyStore.getEntry(tag, null) as? KeyStore.PrivateKeyEntry
        return entry!!.privateKey
    }

    /** Delete the signing key from the keystore. */
    fun deleteSigningKey() {
        val keyStore: KeyStore = KeyStore.getInstance(keyStoreType)
        keyStore.load(null)
        keyStore.deleteEntry(tag)
    }
}

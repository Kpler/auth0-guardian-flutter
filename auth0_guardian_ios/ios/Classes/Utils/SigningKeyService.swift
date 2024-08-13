import Foundation
import Guardian

public class SigningKeyService: NSObject {
  /// The domain of the Auth0 account.
  /// It'll be use as an identifier for the keys in the keychain.
  private let domain: String

  // A computed property to generate a filename.
  private var tag: String {
    "mfa_signing_key#" + domain
  }

  init(domain: String) {
    self.domain = domain
  }

  /// Get the signing key from the keychain.
  /// If the key doesn't exist, it'll be created.
  public func getSigningKey() throws -> KeychainRSAPrivateKey {
    do {
      return try KeychainRSAPrivateKey(tag: tag)
    } catch {
      return try KeychainRSAPrivateKey.new(with: tag)
    }
  }
}

extension KeychainRSAPrivateKey {
  public struct Authenticator: Guardian.AuthenticationDevice {
    /// The signing key used to sign the requests.
    public let signingKey: SigningKey

    /// The local identifier is set when the device is enrolled to Guardian the first time.
    /// The default implementation can be found here [EnrolledDevice.vendorIdentifier]
    public let localIdentifier = UIDevice.current.identifierForVendor!.uuidString
  }

  public func getDevice() -> Authenticator {
    return Authenticator(signingKey: self)
  }
}

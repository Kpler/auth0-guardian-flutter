# Auth0 Guardian for Flutter

A community package that wrapped the Auth0 Guardian SDKs for Android and iOS and provide a convenient api to be use in a Flutter app.

Guardian is Auth0's multi-factor authentication (MFA) service that provides a simple, safe way for you to implement MFA.

Auth0 is an authentication broker that supports social identity providers as well as enterprise identity providers such as Active Directory, LDAP, Google Apps and Salesforce.

This SDK allows you to integrate Auth0's Guardian multi-factor service in your own app, transforming it in the second factor itself. Your users will get all the benefits of our frictionless multi-factor authentication from your app.

## Getting started

### Requirements

| Flutter                   | Android         | iOS        |
| ------------------------- | --------------- | ---------- |
| SDK 3.3.0+                | Android API 23+ | iOS 13+    |
| Dart 3.4.3+               | Java 8+         | Swift 5.0+ |

#### SDK Implemented:

[Guardian.swift](https://github.com/auth0/Guardian.swift) -> __v1.4.2__

[Guardian.android](https://github.com/auth0/Guardian.Android) -> __v0.8.0__

### Installation
Add auth0_guardian into your project: 

``flutter pub add auth0_guardian``

### Before getting started
To use this SDK you have to configure your tenant's Guardian service with your own push notification credentials, otherwise you would not receive any push notifications. Please read the [docs](https://auth0.com/docs/secure/multi-factor-authentication) about how to accomplish that.

You'll also have to configure a notification system in your app. (Firebase or other...)

## Features

| ✨ Feature                 | 📱 Android | 🍏 iOS |
| ------------------------- | ---------- | ------ |
| Enroll device             | ✅          | ✅     |
| Delete device (un-enroll) | ✅          | ✅     |
| Accept request            | ✅          | ✅     |
| Reject request            | ✅          | ✅     |
| Update device             | ❌          | ✅     |

## Usage

An implementation example is available [here](../auth0_guardian/example/).

You can access the Guardian API using the Guardian class.
Here *YOUR_DOMAIN* is your own configured Auth0 tenant.

```final guardian = Guardian(domain: <YOUR_DOMAIN>);```

### Enrolling a device

First get an enrollUri using your own way (probably by reading a qr_code).
See the official [documentation](https://auth0.com/docs/secure/multi-factor-authentication/authenticate-using-ropg-flow-with-mfa/enroll-and-challenge-push-authenticators).

You should also pass the notification token to be associated to this device (FCM / APNs).

```
final EnrolledDevice device = await guardian.enroll(
    usingUri: enrollUri,
    notificationToken: notificationToken,
);
```

You should store the device object permanently if you want to keep the ability to update / delete (un-enroll) this device in the future.

> 💡 Note: Only the id, the deviceToken and the userId and the **required** fields from EnrolledDevice to store.

When using the enroll method a signing key will be generated to identify this device. For iOS it'll be store in the Keychain, on Android on the KeyStore.

### Accepting a login request

After a successfull enrollment, use your own system (Firebase or other) to catch the incomings notifications.

You can check if a notification payload is coming from Guardian using the isGuardianNotification method.

```final isValid = await guardian.isGuardianNotification(message.data!);```

Then pass the payload to the acceptRequest method to accept the login.

```final bool result = guardian.acceptRequest(notification: payload);```

### Rejecting a login request

After a successfull enrollment, use your own system (Firebase or other) to catch the incomings notifications.

You can check if a notification payload is coming from Guardian using the isGuardianNotification method.

```final isValid = await guardian.isGuardianNotification(message.data!);```

Then pass the payload to the rejectRequest method to reject the login.

```final bool result = guardian.rejectRequest(notification: payload, reason: <OPTIONAL_REASON>);```

### Deleting a device (un-enroll)

To un-enroll a device from your Auth0 tenant.

```
final bool result = await guardian.deleteDevice(device);
```

### Updating a device (iOS only)

```
await guardian.updateDevice(
    device,
    name: <NEW_NAME>,
    notificationToken: <NEW_TOKEN>,
	localIdentifier: <NEW_LOCAL_IDENTIFIER>,
);
```

## Next steps

- Adding unit tests 🧪
- Implementing update method for Android.

## Licence 

This project is licensed under the MIT license. See the [LICENSE](../LICENSE) file for more info.
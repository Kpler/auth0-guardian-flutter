import 'dart:developer';

import 'package:auth0_guardian/auth0_guardian.dart';
import 'package:auth0_guardian_example/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:push/push.dart' as push;

/// The domain to use to test the enrollment.
const kTenantUrl = "https://<YOUR_TENANT>/appliance-mfa";

void main() {
  runApp(const GuardianExampleApp());
}

class GuardianExampleApp extends StatefulWidget {
  const GuardianExampleApp({super.key});

  @override
  State<GuardianExampleApp> createState() => _GuardianExampleAppState();
}

class _GuardianExampleAppState extends State<GuardianExampleApp> {
  /// The Guardian instance.
  final guardian = Guardian(tenantUrl: kTenantUrl);

  /// The notification token from the device.
  String? notificationToken;

  /// The enrollment URI.
  String? enrollUri;

  /// The enrolled device.
  EnrolledDevice? enrolledDevice;

  /// An instance of [push.RemoteMessage] to store a notification message.
  push.RemoteMessage? latestNotification;

  /// Gets the notification token from the device.
  void setNotificationToken() async {
    // Initialize Firebase.
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Check for permission.
    await FirebaseMessaging.instance.requestPermission();

    final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
    if (apnsToken != null) {
      setState(() => notificationToken = apnsToken);
    } else {
      final token = await FirebaseMessaging.instance.getToken();
      setState(() => notificationToken = token);
    }
  }

  /// Scans a barcode to get the enrollment URI.
  void scanBarcode() {
    FlutterBarcodeScanner.scanBarcode(
      "#ff6666",
      'Cancel',
      false,
      ScanMode.QR,
    ).then((qr) {
      setState(() => enrollUri = Uri.decodeFull(qr));
    });
  }

  /// Enrolls the user with Guardian.
  void enroll(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final EnrolledDevice device = await guardian.enroll(
        usingUri: enrollUri!,
        notificationToken: notificationToken!,
      );
      setState(() => enrolledDevice = device);
      log(device.toString());
    } catch (e, st) {
      if (kDebugMode) {
        print(e);
        print(st);
      }
      messenger.showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  /// Deletes the device from Guardian.
  void deleteDevice(BuildContext context, EnrolledDevice device) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final result = await guardian.deleteDevice(device);
      if (result) setState(() => enrolledDevice = null);
    } catch (e, st) {
      if (kDebugMode) {
        print(e);
        print(st);
      }
      messenger.showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  /// Update the device previously enrolled in Guardian.
  /// In this example, we update the device name.
  /// You can also update the notification token or the local identifier if needed.
  void updateDevice(BuildContext context, EnrolledDevice device) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await guardian.updateDevice(
        device,
        name: 'Updated name',
        notificationToken: notificationToken,
        localIdentifier: null,
      );
    } catch (e, st) {
      if (kDebugMode) {
        print(e);
        print(st);
      }
      messenger.showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  /// Accept the login request from the latest received notification.
  Future<void> rejectRequest() async {
    final payload = latestNotification?.data;
    if (payload != null) {
      final result = await guardian.rejectRequest(notification: payload);
      if (result) {
        setState(() => latestNotification = null);
      }
    }
  }

  /// Reject the login request from the latest received notification.
  Future<void> acceptRequest() async {
    final payload = latestNotification?.data;
    if (payload != null) guardian.acceptRequest(notification: payload);
  }

  @override
  void initState() {
    super.initState();
    // Add the notification listeners.
    push.Push.instance.addOnMessage(onNotification);
    push.Push.instance.addOnBackgroundMessage(onNotification);
    // Request the notification token.
    setNotificationToken();
  }

  /// Handles the received notification message .
  void onNotification(push.RemoteMessage message) async {
    // Check if the notification has data.
    if (message.data == null) return;

    // Check if the notification is from Guardian, and if it is, process it.
    final isValid = await guardian.isGuardianNotification(message.data!);
    if (isValid) {
      log("Received Guardian notification: ${message.data}");
      setState(() => latestNotification = message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('🔑 Auth0 Guardian Example App'),
        ),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Builder(builder: (context) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: [
                  Visibility(
                    visible: notificationToken == null,
                    replacement: _TextLine(
                      label: 'Notification Token (APNs / Firebase)',
                      value: notificationToken ?? '',
                    ),
                    child: ElevatedButton(
                      onPressed: setNotificationToken,
                      child: const Text('Set (APNs / Firebase) token'),
                    ),
                  ),
                  const Divider(),
                  const SizedBox(height: 4),
                  ElevatedButton(
                    onPressed: scanBarcode,
                    child: const Text('Step 1: Scan QR code'),
                  ),
                  const SizedBox(height: 8),
                  Visibility(
                    visible: enrollUri != null,
                    child: _TextLine(
                      label: 'Enroll URI',
                      value: enrollUri ?? '',
                    ),
                  ),
                  const Divider(),
                  const SizedBox(height: 4),
                  ElevatedButton(
                    onPressed: () => enroll(context),
                    child: const Text('Step 2: Trigger enrollment! 🚀'),
                  ),
                  const SizedBox(height: 8),
                  Visibility(
                    visible: enrolledDevice != null,
                    child: _TextLine(
                      label: 'Enrolled device',
                      value: enrolledDevice?.id ?? '',
                    ),
                  ),
                  enrolledDevice != null
                      ? Column(
                          children: [
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () => deleteDevice(
                                context,
                                enrolledDevice!,
                              ),
                              child: Text(
                                'Delete device ${enrolledDevice?.id}',
                              ),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () => updateDevice(
                                context,
                                enrolledDevice!,
                              ),
                              child: const Text(
                                'Update device (iOS only)',
                              ),
                            ),
                          ],
                        )
                      : Container(),
                  const Divider(),
                  const SizedBox(height: 4),
                  const Text(
                    'Step 3: Waiting for a notification',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  if (latestNotification != null)
                    Column(
                      children: [
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: acceptRequest,
                              child: const Text('Accept'),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: rejectRequest,
                              child: const Text('Reject'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(latestNotification?.data.toString() ?? ''),
                      ],
                    )
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _TextLine extends StatelessWidget {
  const _TextLine({
    required this.label,
    required this.value,
  });

  /// The label of the text.
  final String label;

  /// The value of the text.
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
          ),
        ),
        const SizedBox(height: 4),
        Text(value)
      ],
    );
  }
}

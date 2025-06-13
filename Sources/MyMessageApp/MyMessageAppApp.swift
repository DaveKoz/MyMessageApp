import Foundation
import SkipFuse
import SwiftUI

#if os(Android)
import SkipFirebaseCore
import SkipFirebaseMessaging
#else
import FirebaseCore
import FirebaseMessaging
#endif

/// A logger for the MyMessageApp module.
let logger: Logger = Logger(subsystem: "com.floatingaxeheadministries.mymessageapp", category: "MyMessageApp")

/// The shared top-level view for the app, loaded from the platform-specific App delegates below.
///
/// The default implementation merely loads the `ContentView` for the app and logs a message.
/* SKIP @bridge */public struct MyMessageAppRootView : View {
    /* SKIP @bridge */public init() {
    }

    public var body: some View {
        ContentView()
            .task {
                logger.info("Skip app logs are viewable in the Xcode console for iOS; Android logs can be viewed in Studio or using adb logcat")
            }
    }
}

/// Global application delegate functions.
///
/// These functions can update a shared observable object to communicate app state changes to interested views.
/* SKIP @bridge */public final class MyMessageAppAppDelegate : Sendable {
    /* SKIP @bridge */public static let shared = MyMessageAppAppDelegate()
    
    private let notificationDelegate = NotificationDelegate()

    private init() {
    }

    /* SKIP @bridge */public func onInit() {
        logger.debug("onInit")
        
        // Configure Firebase and notifications
        FirebaseApp.configure()
        UNUserNotificationCenter.current().delegate = notificationDelegate
    }

    /* SKIP @bridge */public func onLaunch() {
        logger.debug("onLaunch")
        // Ask for permissions at a time appropriate for your app
       notificationDelegate.requestPermission()
    }

    /* SKIP @bridge */public func onResume() {
        logger.debug("onResume")
    }

    /* SKIP @bridge */public func onPause() {
        logger.debug("onPause")
    }

    /* SKIP @bridge */public func onStop() {
        logger.debug("onStop")
    }

    /* SKIP @bridge */public func onDestroy() {
        logger.debug("onDestroy")
    }

    /* SKIP @bridge */public func onLowMemory() {
        logger.debug("onLowMemory")
    }
}


final class NotificationDelegate : NSObject, UNUserNotificationCenterDelegate, Sendable {
    public func requestPermission() {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        Task { @MainActor in
            do {
                if try await UNUserNotificationCenter.current().requestAuthorization(options: authOptions) {
                    logger.info("notification permission granted")
                } else {
                    logger.info("notification permission denied")
                }
            } catch {
                logger.error("notification permission error: \(error)")
            }
        }
    }
}



public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
    let content = notification.request.content
    logger.info("willPresentNotification: \(content.title): \(content.body) \(content.userInfo)")
    return [.banner, .sound]
}

public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
   let content = response.notification.request.content
    #if os(Android) || !os(macOS)
    // Example of using a deep_link key passed in the notification to route to the app's `onOpenURL` handler
    if let deepLink = response.notification.request.content.userInfo["deep_link"] as? String, let url = URL(string: deepLink) {
        Task { @MainActor in
            await UIApplication.shared.open(url)
        }
    }
    #endif
}



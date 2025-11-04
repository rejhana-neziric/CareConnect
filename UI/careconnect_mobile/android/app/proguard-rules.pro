# Flutter deferred components
-keep class com.google.android.play.core.** { *; }
-keep class com.google.android.play.** { *; }
-keep class com.google.android.gms.common.** { *; }

# Stripe push provisioning
-keep class com.stripe.android.pushProvisioning.** { *; }
-keep class com.reactnativestripesdk.pushprovisioning.** { *; }

# Flutter classes
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# React Native Stripe SDK
-keep class com.reactnativestripesdk.** { *; }

# Stripe general rules
-keep class com.stripe.android.** { *; }
-keep class com.stripe.android.model.** { *; }
-keep class com.stripe.android.core.** { *; }

# General rules
-dontwarn com.google.android.play.**
-dontwarn com.stripe.android.**
-dontwarn org.chromium.**

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep R classes
-keep class **.R$* { *; }
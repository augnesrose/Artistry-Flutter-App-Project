# Flutter-specific rules
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.app.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }

# Keep Razorpay SDK classes
-keep class com.razorpay.** { *; }
-dontwarn com.razorpay.**

# Keep Google Pay API classes used by Razorpay
-keep class com.google.android.apps.nbu.paisa.inapp.client.api.** { *; }
-dontwarn com.google.android.apps.nbu.paisa.inapp.client.api.**

# Prevent warnings for annotations used by Razorpay
-keep class proguard.annotation.** { *; }
-dontwarn proguard.annotation.**

# Prevent removal of Kotlin metadata
-keep class kotlin.Metadata { *; }

# For serialization/deserialization (safe default)
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# Flutter-specific rules.
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.plugins.**  { *; }
-dontwarn io.flutter.plugins.**

# Reglas para Firebase Core y Auth
-keep class com.google.firebase.** { *; }
-keepattributes Signature
-keepattributes *Annotation*

# Reglas para Firestore
-keepclassmembers class ** {
    @com.google.firebase.firestore.PropertyName *;
}

# Reglas para Google ML Kit (OCR)
-keep class com.google.mlkit.** { *; }
-keep class com.google.android.gms.internal.mlkit_vision_text.** { *; }
-keep class com.google.android.gms.internal.mlkit_vision_common.** { *; }

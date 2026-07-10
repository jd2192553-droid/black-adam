# Add project specific ProGuard rules here.
-keep class com.aegis.pentest.** { *; }
-keep class com.google.gson.** { *; }
-keepclassmembers class ** {
    @com.google.gson.annotations.SerializedName <fields>;
}

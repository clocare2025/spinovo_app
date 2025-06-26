# Keep Razorpay classes and annotations
-keep class com.razorpay.** { *; }
-dontwarn com.razorpay.**

# Sometimes this helps with general annotation issues
-keepattributes *Annotation*

import os
cmd = "flutter build apk --analyze-size --target-platform android-arm64"
# cmd = "flutter build apk --analyze-size --target-platform android-x64"
# cmd = "flutter build appbundle --analyze-size --target-platform android-arm64"
os.system(cmd)
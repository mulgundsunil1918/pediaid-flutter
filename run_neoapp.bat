@echo off
echo Starting NEOAPP...
cd /d C:\Users\mulgu\Desktop\APP\neoapp\neoapp_app
start http://localhost:8080
flutter run -d web-server --web-port=8080
pause

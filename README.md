# CareConnect

The CareConnect application is intended for a center that works with children with learning and developmental difficulties. The application consists of a mobile version for clients and a desktop version designed for employees and administrators. This project is developed for the Software Development II (Razvoj softvera II) course at the Faculty of Information Technologies. 

## Backend setup 
1. Clone and prepare repository
2. Extract these zip files to their specified locations:
    - `fit-build-2025-11-04-env-backend.zip` → Project root folder
    - `fit-build-2025-11-04-env-desktop.zip` → `.UI/careconnect-admin/`
    - `fit-build-2025-11-04-env-mobile.zip` → `.careconnect-mobile/`
4. Open a terminal or command prompt in the root project folder, then navigate to the `CareConnect` folder.
5. Build and start the backend using Docker:
```bash
docker compose up --build
```
## Frontend setup 
Desktop Application
1. In the root project folder locate `fit-build-2025-11-04.zip`
2. After extraction, you will find two folders: `Debug` and `flutter-apk`.
4. Navigate to the **Debug** folder
5. Double-click `careconnect_admin.exe` to run the application

Mobile Application
1. Open the `flutter-apk` folder.
2. Install `flutter-app.apk` on an emulator or device by dragging and dropping the APK file.
3. **Important**: Uninstall any previous version before reinstalling

## Login Credentials

### Administrator Account
- **Username:** `admin`
- **Password:** `test`

### Employee Account  
- **Username:** `employee`
- **Password:** `test`

### Client Account
- **Username:** `client`
- **Password:** `test`

---

## 💳 Stripe Integration

Payment processing for appointments and workshops is enabled through Stripe integration in the mobile application.

### Test Payment Credentials
- **Card Number:** `4242 4242 4242 4242`
- **Expiry Date:** `12/26`
- **CVC Code:** `123`
- **Country Selection:** United States

*Use these test credentials to simulate successful payments in the application.*


## RabbitMQ

RabbitMQ microservice acts as a message broker that enables asynchronous communication between services. When an appointment is created or updated in the API, it publishes a message to a RabbitMQ queue. The console application (notification service) consumes these messages from the queue and sends notifications to users, decoupling the appointment management from the notification logic and improving system reliability and scalability.



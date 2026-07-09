/* Firebase Cloud Messaging service worker — displays push notifications
 * arriving while the PediAid web app tab is closed or in the background.
 * Config values mirror the "web" block of lib/firebase_options.dart. */
importScripts('https://www.gstatic.com/firebasejs/10.13.2/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.13.2/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: 'AIzaSyCyNYR5v42yWAIgo8maiSXG8dKX055ji1s',
  appId: '1:11076606207:web:fb572f5ad2c6d487f2d4ca',
  messagingSenderId: '11076606207',
  projectId: 'pediaid-app',
  authDomain: 'pediaid-app.firebaseapp.com',
  storageBucket: 'pediaid-app.firebasestorage.app',
});

/* Instantiating messaging is enough: notification-type payloads are shown
 * by the browser automatically. */
firebase.messaging();

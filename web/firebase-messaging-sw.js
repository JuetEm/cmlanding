importScripts('https://www.gstatic.com/firebasejs/8.4.1/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/8.4.1/firebase-messaging.js');
firebase.initializeApp({
   apiKey: "AIzaSyA4Emv9DEwfWZ49My9UiiQ_lhxFtuMBrsw",
   authDomain: "classmatch-f7175.firebaseapp.com",
   projectId: "classmatch-f7175",
   storageBucket: "classmatch-f7175.appspot.com",
   messagingSenderId: "319946047250",
   appId: "1:319946047250:web:be493626f53ebc908dbdcb",
   measurementId: "G-2CV0S971FG"
});
 const messaging = firebase.messaging();


// If you would like to customize notifications that are received in the
// background (Web app is closed or not in browser focus) then you should
// implement this optional method.
// Keep in mind that FCM will still show notification messages automatically 
// and you should use data messages for custom notifications.
// For more info see: 
// https://firebase.google.com/docs/cloud-messaging/concept-options
messaging.onBackgroundMessage(function(payload) {
    console.log('[firebase-messaging-sw.js] Received background message ', payload);
    // Customize notification here
    const notificationTitle = payload.notification.title;
    const notificationOptions = {
      body: payload.notification.body,
      icon: '/bettercoach_icon.png',
      badge : '/bettercoach_icon_badge.png'

    };
  
    self.registration.showNotification(notificationTitle,
      notificationOptions);
  });

//  messaging.setBackgroundMessageHandler(function (payload) {
//     const notificationOptions = {
//         icon: './bettercoach_icon.png'
//       }; 
//     const promiseChain = clients
//          .matchAll({
//              type: "window",
//              includeUncontrolled: true
//          })
//          .then(windowClients => {
//              for (let i = 0; i < windowClients.length; i++) {
//                  const windowClient = windowClients[i];
//                  windowClient.postMessage(payload);
//              }
//          })
//          .then(() => {
//              return registration.showNotification("New Message",notificationOptions);
//          });
//      return promiseChain;
//  });
//  self.addEventListener('notificationclick', function (event) {
//      console.log('notification received: ', event)
//  });
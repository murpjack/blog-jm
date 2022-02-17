---
{
  slug: 'signalr-vs-socketio',
  title: 'SignalR vs. Socket.IO',
  tags: ['web'],
  publishDate: '2019-06-19',
  description: 'Websockets use push notifications to send data from server to client. Which websocket should ,you chose?',
}
---

SignalR is a Microsoft service for web applications. It is a library which allows a server-side component to interact with a corresponding client-side component. SignalR uses websockets to push notifications from server to client.

Imagine two students being naughty in their teacherless classroom. (Shocking :o ) A third student acts as a lookout and shouts “teacher’s coming” only when the teacher is actually coming back, so the first and second students can keep on playing without keeping an eye on the door.

### For example...

Real-world uses of the SignalR library could be a messenger app that updates when you are typing, a flight site - like Skyscanner taking bookings, or an e-commerce site, displaying different products.

### Is it useful?

SignalR only talks to the client-side of a web application when it notices an update. It sends notifications in real-time. This is useful as it saves the application from fetching data from the server on a set interval (polling) and looking for any differences.

### Is SignalR my only hope?

There are plenty of alternatives to Microsoft’s SignalR, some attracting favourable reviews. SocketIO is an alternative as are NodeJS, Pusher, used by Groupon, and Google’s Cloud messaging service - Pub/Sub.
It is worth noting SignalR.net core is a free open-source library that works on both linux and Windows and is preferable to SignalR.net, which requires a Microsoft system.
[Stackshare](https://stackshare.io/stackups/pusher-vs-signalr-vs-socket-io) offers an overview of some popular services.

### Verdict

#### SocketIO

The SocketIO Api comes well documented and includes an easy-to-follow tutorial for setting up a “Hello World” chat application. The server-side logic can be written in a few different languages, including Javascript :), that are documented on their site.

#### SignalR

Microsoft have included in SignalR, in the ‘ASP.net core v2.2’ Github repository, a number of helpful example projects and that the SignalR documentation is relatively clear and concise.
It is also worth mentioning that if using SignalR for app development, there are well-supported, up-to-date libraries that work with SignalR.

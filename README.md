AppClips
=====================

AppClips is a library that allows you to easily install webclips onto the user's homescreen. This can be useful for launching 3rd party apps, or for launching your own app into different contexts using url schemes. This library was inspired by this conversation on [Stack Overflow](http://stackoverflow.com/questions/2338035/installing-a-configuration-profile-on-iphone-programmatically) 

##Set Up

AppClips requires  [RoutingHTTPServer](https://github.com/mattstevens/RoutingHTTPServer) (pod 'RoutingHTTPServer', '~> 1.0')

##Usage

To use AppClips, you must initialize an instance with a clipURL, a returnURL, and an identifier. You can also optionally inclide an icon. The clipURL representes the URL that the webclip will launch. This will likely be a url scheme that will launch the parent app, but it can be any url. The name is the text that will appear under the icon on the hime screen. The return url will be launched after the user installs the AppClip or cancels. It should be a url that will launch back into the parent app. The identifier should uniquely identify this webclip. The icon should be a UIImage that will appear on the homescreen.

```
let appClipGenerator = AppClips(clipURL: "appcliplaunch://",  name:"Launcher", returnURL: "appclipreturn://", identifier:"com.example.appclip", icon:self.icon)

```

After an instance is created, it must be launched with the startServer() method. This will launch Safari to prompt the user to install the AppClip

After the user returns back to the app, you must remember to call stopServer(). This is necessary to stop the httpserver that was running in the background, and to stop the app from requesting to run in the background any more than necessary.


##License

The MIT License (MIT)

Copyright (c) 2014 Daniel Sanche
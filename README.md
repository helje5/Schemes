<h2>
  Schemes
  <img width="64" alt="Schemes Application Icon" align="right"
       src="https://user-images.githubusercontent.com/7712892/162421691-c6638e8f-f99c-45bf-a23d-59dd98e31857.png" />
</h2>

"Schemes" lists all the schemes and their handlers that are registered via 
[Launch Services](https://developer.apple.com/documentation/coreservices/launch_services)
on your system.
A [small application](https://oliver-epper.de/apps/schemes/) 
originally written in AppKit by
[Oliver Epper](https://oliver-epper.de/).

SwiftUI rewrite by [Helge Heß](https://helgehess.eu/).
Why rewrite something perfectly working in SwiftUI? Procrastination.
SwiftUI version requires macOS 12, because `Table`.

![Schemes-Screenshot](https://user-images.githubusercontent.com/7712892/162419280-1edceaee-e3ae-4bd3-b573-5f7a5d5cab0d.png)

Have fun!

TODO:
- [ ] Move `LSUnregisterURL` back into a privileged XPC
- [ ] Re-enable Sparkle

YKWebPImage
===========

Plug-and-play WebP Image support for iOS. Compatibile with many other image fetch and caching libraries, including [Haneke](https://github.com/Haneke) 

* Works transparently with Swift

Installation
------------

[CocoaPods](http://cocoapods.org/):

```ruby
use_frameworks!
pod 'YKWebPImage'
```

And that's it! There is no code to write, simply passing webp data or files to the UIImage API is enough. 


Requirements
------------

- iOS 8.0+

Under the hood
--------------
In the interest of full disclosure, this library makes very liberal use of swizzling to achieve "Plug-and-play" functionality. Specifically, the following methods are swizzled:

```objective-c
[UIImage imageNamed:inBundle:compatibleWithTraitCollection:]
[UIImage initWithData:]
[UIImage initWithData:scale:]
[UIImage initWithContentsOfFile:]
```

That being said, every effort has been made to ensure that the implementation complies with UIKit's expectations. 


License
-------

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.


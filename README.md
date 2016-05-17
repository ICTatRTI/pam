![pam_w.png](https://bitbucket.org/repo/qqykrk/images/1816352512-pam_w.png)

This is an IOS app using the ResearchKit framework for the Ecological Momentary Assessment using the Photographic Affect Meter (PAM).  For more information on PAM please check out [this site](http://idl.cornell.edu/projects/pam/).

The ResearchNet IOS framework can be found [here](https://bitbucket.org/rcdrti/researchnetsdk-ios). Some day you will be able to use a dependency manager like Cocopods to bring this in, but until then you'll have to manually like this by dragging the xcodeprj file (from the Finder) into your project then adding this as an embedded binary under the apps General settings.

### Push Notifications
Everybody knows that using notifications are a great way to promote user engagement and I mean EVERYBODY. It is for this reason that we have included a sample push notification script handcrafted in PHP.  Here is how to use it:

1. Install PHP
2. Run this in a terminal window
`php notifications/examplepush.php 'Breaking News' 'http://www.adampreston.org'`

Bugs, new requests or contribution
--------------
Please submit bugs, gripes and feature requests at https://bitbucket.org/rcdrti/pam/issues. For any other questions send a polite and grammatically correct email to Adam Preston to this email address: apreston@rti.org
# Electron Updates

This a minimal Sinatra app meant to handle the updates for the [Quazer Desktop App](https://gitlab.magic-technik.de/pi/Quazer-Desktop).


# Running locally

1. `bundle install`
2. `bundle exec rackup config.ru --port 3000`

In development you will use the `db/releases.json` file.

In production you need to set the RELEASES_FILE env var to a remote file (or local also).

# Configuring your client

Once you've deployed your sever, you need to configure a client to query it for
updates.

The example server compares a `version` query parameter to determine whether an
update is required.

The update resource is `/updates/latest`, configure your client
`SQRLUpdater.updateRequest`:

```objc
NSURLComponents *components = [[NSURLComponents alloc] init];

components.scheme = @"http";

BOOL useLocalServer = NO;
if (useLocalServer) {
  components.host = @"localhost";
  components.port = @(3000);
} else {
  components.host = @"my-server.example.com";
}

components.path = @"/updates/latest";

NSString *bundleVersion = NSBundle.mainBundle.sqrl_bundleVersion;
components.query = [[NSString stringWithFormat:@"version=%@", bundleVersion] stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet]

self.updater = [[SQRLUpdater alloc] initWithUpdateRequest:components.URL];
```

# Updating releases.json

When you have updated the `releases.json` file, you need to call /updates/reload in order to reload the file with the new changes.

# Test

Run `script/test`

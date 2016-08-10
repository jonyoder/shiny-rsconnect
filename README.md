# shiny-rsconnect

## Introduction

It is possible to use the `rsconnect` R package to programmatically deploy
content. This is a Shiny application that demonstrates programmatic deployment
with `rsconnect` from a Shiny application.

## Setup

You should be able to run this Shiny application and use the `Update Output`
button without any special preparation. However, before using the
`Deploy Output` button, you must configure `rsconnect`.

### Installing rsconnect

If `rsconnect` is not yet installed, install it with:

```R
install.packages("rsconnect")
```

### Configuring rsconnect

To configure `rsconnect`, issue the following commands in the R console:

```R
library(rsconnect)
rsconnect::addConnectServer('http://myserveraddress:3939', 'mylocaldeployserver')
rsconnect::connectUser(server='mylocaldeployserver')
```

> NOTE: the rsconnect server name, `mylocaldeployserver`, is an arbitrary name
> that is used to identify a Connect server when using rsconnect. You can choose
> any name you wish.

After the last command, you should see the following output:

> A browser window should open; if it doesn't, you may authenticate manually by visiting http://myserveraddress:3939/__login__?url=http%3A%2F%2Fmyserveraddress%3A3939%2Fconnect%2F%23%2Ftokens%2FTc8f636c59ffff521eef4888b163dcf64%2Factivate&user_id=0.

> Waiting for authentication...

If a browser window does not automatically open for you, simply
copy the URL from the output and paste it into a Web browser.

Authenticate with your Connect user credentials.

After successfully connecting your Connect account to `rsconnect`, you
should see this message at the R console:

> Account registered successfully: [First Name] [Last Name] ([username])

### Deploying Content with rsconnect

Now `rsconnect` is configured for deploying content to Connect. Before
clicking the `Deploy Output` button, make sure the input field values
are correct:

| Field | Description |
|-------|-------------|
| `Connect User` | The Connect user account you used when you logged in to Connect during the `Configuring rsconnect` step, above  |
| `Connect Server Name` | The arbitrary Connect server name you chose (`mylocaldeployserver` in the instructions above) |


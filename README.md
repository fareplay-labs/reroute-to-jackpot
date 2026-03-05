# Fareplay Redirect (Pinata + Njalla)

This project is a minimal redirect site. It sends users from `https://app.fareplay.io/` to your target app route on first load.

## Files

- `index.html` - redirect page
- `upload-to-pinata.ps1` - one-command upload helper

## One-time setup

1. Open PowerShell in this folder.
2. Set your Pinata JWT:

```powershell
$env:PINATA_JWT = "PASTE_YOUR_PINATA_JWT"
```

## Upload in one command

```powershell
.\upload-to-pinata.ps1
```

The script prints a CID.

## Njalla DNS records (for app.fareplay.io)

Keep/set these records:

- `CNAME` `app.fareplay.io` -> `fareplay.mypinata.cloud.`
- `TXT` `_dnslink.app.fareplay.io` -> `dnslink=/ipfs/<CID_FROM_SCRIPT>`

If a previous `_dnslink.app.fareplay.io` TXT exists, replace only the CID value.

## Test

1. Wait for DNS TTL/propagation.
2. Open an incognito window.
3. Visit `https://app.fareplay.io`.
4. It should auto-redirect to your `/ipfs/...#/fareVault?...` URL.

## Update later

Any time you change `index.html`:

1. Run `./upload-to-pinata.ps1` again.
2. Update `_dnslink.app.fareplay.io` TXT with the new CID.
# reroute-to-jackpot

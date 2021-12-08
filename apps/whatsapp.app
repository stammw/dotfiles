#!/usr/bin/env bash

FOCUS=i3-msg '[class="Chromium-browser" instance="web.whatsapp.com"] focus'

/etc/profiles/per-user/jc/bin/chromium --app=https://web.whatsapp.com &
sleep 0.5
i3-msg '[class="Chromium-browser" instance="web.whatsapp.com"] focus'

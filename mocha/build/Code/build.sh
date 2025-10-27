#!/bin/bash

sed -i "s/\"workbench.colorTheme\": \"[^\"]*\"/\"workbench.colorTheme\": \"Catppuccin Mocha\"/" settings.json
sed -i "s/\"catppuccin.accentColor\": \"[^\"]*\"/\"workbench.colorTheme\": \"$accent\"/" settings.json
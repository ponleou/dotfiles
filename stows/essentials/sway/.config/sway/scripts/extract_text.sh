#!/bin/bash

grim -g "$(slurp)" - | tesseract - - | wl-copy
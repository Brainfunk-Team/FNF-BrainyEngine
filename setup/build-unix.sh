#!/bin/bash

echo "Starting compile..."

lime test cpp || {
    echo "lime failed, trying haxelib run lime..."
    haxelib run lime test cpp || {
        echo "Build failed!"
        exit 1
    }
}

echo "Build succeeded!"

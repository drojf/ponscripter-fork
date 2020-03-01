if [ "$TRAVIS_OS_NAME" == "linux" ]; then
	sudo apt-get update -qq
	sudo apt-get install -y libasound2-dev
fi

if [ -n "$SSH_KEY" ]; then
	echo "${SSH_KEY}" | base64 --decode > key
	chmod 600 key
fi

if [ -z "$STEAMLESS" ] && [ -n "$SSH_KEY" ]; then
	# Steam SDK
	scp -o StrictHostKeyChecking=no -i key "${DOWNLOAD_SERVER}/steamworks_sdk_129a.zip" . 2>/dev/null
	unzip -d src/extlib/src/steam-sdk/ steamworks_sdk_129a.zip
	mv src/extlib/src/steam-sdk/sdk/* src/extlib/src/steam-sdk/
fi

if [ "$TRAVIS_OS_NAME" == "linux" ]; then
	sudo apt-get install -y chrpath libbz2-dev libvorbis-dev libfreetype6-dev libsdl2-image-dev libsdl2-mixer-dev libsdl2-dev libgles2-mesa-dev libglu1-mesa-dev
	if [ -z "$STEAMLESS" ] && [ -n "$SSH_KEY" ]; then
		# For i386 steam builds, we build x86_64
		# sudo dpkg --add-architecture i386
		# sudo apt-get update -qq
		# sudo apt-get install -y libbz2-dev:i386 libfreetype6-dev:i386 libsdl2-mixer-dev:i386 libsdl2-image-dev:i386 libsdl2-dev:i386 libpulse-dev:i386 libavahi-client-dev:i386 libgles2-mesa-dev:i386 libglu1-mesa-dev:i386 libgl1-mesa-dev:i386 libpng-dev:i386

		# Steam build environment
		mkdir steam
		for file in "http://media.steampowered.com/client/runtime/steam-runtime-sdk_latest.tar.xz" "http://media.steampowered.com/client/runtime/x-tools-amd64-i386_latest.tar.xz" "http://media.steampowered.com/client/runtime/x-tools-amd64-amd64_latest.tar.xz"; do
			echo "Downloading $file"
			curl "$file" | tar -xJf - --strip-components=1 -C steam
		done
		mkdir steam/runtime
		echo "Downloading http://media.steampowered.com/client/runtime/steam-runtime-dev-release_latest.tar.xz"
		curl "http://media.steampowered.com/client/runtime/steam-runtime-dev-release_latest.tar.xz" | tar -xJf - --strip-components=1 -C steam/runtime
	fi
fi
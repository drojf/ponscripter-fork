if [ -n "$STEAMLESS" ] && [ -z "$SSH_KEY" ]; then
	echo "Run with steamless but no SSH key, this would be a repeat of steamless with an SSH key, stopping."
	exit 0
elif [ -z "$STEAMLESS" ] && [ -n "$SSH_KEY" ]; then
	STEAM="--with-steam"
	if [ "$TRAVIS_OS_NAME" == "linux" ]; then
		export STEAM_RUNTIME_HOST_ARCH=$(dpkg --print-architecture)
		export STEAM_RUNTIME_ROOT="$(pwd)/steam/runtime/i386"
		export STEAM_RUNTIME_TARGET_ARCH=i386
		export PATH="$(pwd)/steam/bin:$PATH"
	fi
fi

if [ "$TRAVIS_OS_NAME" == "osx" ]; then
	./configure --unsupported-compiler --with-internal-libs $STEAM
	make
elif [ "$TRAVIS_OS_NAME" == "linux" ]; then
	if [ -n "$STEAM" ]; then
		# Freetype header search is slightly broken, "fix" it by soft linking it to the expected place
		sudo ln -s /usr/include/freetype2 /usr/include/freetype2/freetype
		run.sh ./configure --with-external-sdl-mixer $STEAM
		run.sh make
	else
		./configure --with-internal-libs
		cd src/extlib/src/SDL2_image-2.0.0
		bash fix-timestamps.sh
		cd ../../../..
		make
	fi
else
	echo -n
	# TODO: Windows build
fi
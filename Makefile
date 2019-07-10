game=snake
love_win=./.love_win
love_linux=./.love_linux
$(game): clean dirs love linux windows

.PHONY: clean dirs
clean:
	-rm -r build

dirs:
	mkdir build
	mkdir build/linux
	mkdir build/win

love:
	zip -r build/game.love ./ -x \.*\* Makefile \build\* \*.md

linux:
	cp -r $(love_linux) ./build/linux/.love_linux
	cp build/game.love ./build/linux/
	printf "SCRIPTPATH=$$" >> ./build/linux/start.sh
	printf "(cd \`dirname $$" >> ./build/linux/start.sh
	printf "0\` && pwd)\n" >> ./build/linux/start.sh
	printf "$$" >> ./build/linux/start.sh
	printf "SCRIPTPATH/.love_linux/love " >> ./build/linux/start.sh
	printf "$$" >> ./build/linux/start.sh
	printf "SCRIPTPATH/game.love" >> ./build/linux/start.sh
	chmod +x ./build/linux/start.sh

windows:
	cp  $(love_win)/*.dll ./build/win/
	cp  $(love_win)/license.txt ./build/win/
	cat $(love_win)/love.exe build/game.love > ./build/win/$(game).exe
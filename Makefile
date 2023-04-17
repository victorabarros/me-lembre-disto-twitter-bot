APP_NAME=MeLembreDisto
APP_DIR=/${APP_NAME}/app
DOCKER_BASE_IMAGE=python:3.11
COMMAND?=bash
PORT=5010

# text colors https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux
BOLD_YELLOW=\033[1;33m
COLOR_OFF=\033[0m

welcome:
	@clear
	@echo "${BOLD_YELLOW}"
	@echo "Me Lembre Disto" && sleep .02
	@echo "${NOCOLOR}"
	@# http://patorjk.com/software/taag font ANSI Shadow

remove-containers:
ifneq ($(shell docker ps -a --filter "name=${APP_NAME}" -aq 2> /dev/null | wc -l | bc), 0)
	@echo "${BOLD_YELLOW}removing containers${COLOR_OFF}"
	@docker ps -a --filter "name=${APP_NAME}" -aq | xargs docker rm -f
endif

docker-command: remove-containers
	@echo "${BOLD_YELLOW}running container${COLOR_OFF}"
	@docker run -it -v $(shell pwd):${APP_DIR} -w ${APP_DIR} \
		--name ${APP_NAME} \
		--env-file .env \
		-p ${PORT}:5010 \
		${DOCKER_BASE_IMAGE} bash -c "\
			pip3 install -r requirements.txt && \
			${COMMAND}"

docker-debug: welcome
	@make docker-command

docker-run: welcome
	@make docker-command COMMAND="python3 app.py"

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

# ── Docker ──────────────────────────────────────────────────────────────

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

# ── Git ─────────────────────────────────────────────────────────────────

merge m:
	git fetch origin && git merge origin/main

checkout c:
	@git stash
	@git checkout main
	@git pull
	@git stash pop

OLLAMA_MODEL?=qwen2.5:7b

commit-llm-generated commit:
	git add .
	@msg_file="$$(mktemp)"; \
	{ \
		printf '%s\n\n' 'Write the final git commit message for the staged changes.'; \
		printf '%s\n' 'Return only the commit message text that should be passed to git commit.'; \
		printf '%s\n' 'Do not repeat these instructions.'; \
		printf '%s\n' 'Do not include markdown, code examples, code fences, labels, quotes, explanations, or diff summaries.'; \
		printf '%s\n' 'Use imperative mood.'; \
		printf '%s\n' 'Keep the subject line under 72 characters.'; \
		printf '%s\n' 'Add a short body only if it materially improves clarity.'; \
		printf '%s\n' 'If there is a body, separate it from the subject with one blank line.'; \
		printf '\n%s\n' 'git status --short:'; \
		git status --short; \
		printf '\n%s\n' 'git diff --cached --stat:'; \
		git diff --cached --stat; \
		printf '\n%s\n' 'git diff --cached:'; \
		git diff --cached; \
	} | ollama run "$(OLLAMA_MODEL)" > "$$msg_file"; \
	printf '🦙 message generated with ollama' >> "$$msg_file"; \
	printf '%s\n' 'Generated commit message:'; \
	cat "$$msg_file"; \
	printf '\n'; \
	commit_msg="$$(perl -pe 's/\e\[[0-9;?]*[ -\/]*[@-~]//g' "$$msg_file")"; \
	rm -f "$$msg_file"; \
	git commit -m "$$commit_msg"

push p:
	@make commit-llm-generated
	@git push

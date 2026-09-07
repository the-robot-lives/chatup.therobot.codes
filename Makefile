.PHONY: sandbox sandbox-stop

IMAGE ?= chatup-sandbox
NAME ?= chatup-sandbox
PORT ?= 8787

sandbox: sandbox-stop
	docker build --target production -t $(IMAGE) .
	docker run --rm -d --name $(NAME) -p $(PORT):80 $(IMAGE)
	@echo "http://127.0.0.1:$(PORT)"

sandbox-stop:
	-docker rm -f $(NAME)

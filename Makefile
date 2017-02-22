IMAGE_NAME=codeflavor/systemd-nspawn

.PHONY: clean
clean:
	@echo 'Cleaning out generated rootfs artifacts if they exist...'
	@sudo rm -rf rootfs/*
	@sudo rm -rf rootfs/.dockerenv
	@docker rmi -f ${IMAGE_NAME}:rootfs || true

# creates the rootfs needed to distribute the plugin.
build:
	@echo 'Removing ${IMAGE_NAME}:rootfs image if it exists'
	@docker rmi -f ${IMAGE_NAME}:rootfs || true
	@docker rm -vf tmp || true
	@echo 'Building plugin Docker image...'
	@docker build -t ${IMAGE_NAME}:rootfs .
	@echo 'Creating new rootfs for plugin...'
	@docker create --name tmp ${IMAGE_NAME}:rootfs .
	@echo 'Exporting to rootfs'
	@docker export tmp | tar -x -C rootfs/
	@docker rm -vf tmp || true

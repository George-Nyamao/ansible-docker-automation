.PHONY: help install check deploy scale monitor backup cleanup stop start restart

help:
	@echo "Docker Automation with Ansible"
	@echo "==============================="
	@echo "Available commands:"
	@echo "  make install    - Install dependencies"
	@echo "  make check      - Run syntax check"
	@echo "  make deploy     - Deploy Docker infrastructure"
	@echo "  make scale      - Scale services"
	@echo "  make monitor    - Monitor containers"
	@echo "  make backup     - Backup volumes and configs"
	@echo "  make cleanup    - Clean up Docker resources"
	@echo "  make stop       - Stop all containers"
	@echo "  make start      - Start all containers"
	@echo "  make restart    - Restart all containers"

install:
	@echo "Installing dependencies..."
	ansible-galaxy collection install community.docker

check:
	@echo "Checking syntax..."
	ansible-playbook site.yml --syntax-check
	@echo "Running dry-run..."
	ansible-playbook site.yml --check

deploy:
	@echo "Deploying Docker infrastructure..."
	ansible-playbook site.yml

scale:
	@echo "Scaling services..."
	ansible-playbook scale.yml

monitor:
	@echo "Monitoring containers..."
	ansible-playbook monitor.yml

backup:
	@echo "Running backup..."
	ansible-playbook backup-containers.yml

cleanup:
	@echo "Cleaning up Docker resources..."
	ansible-playbook cleanup.yml

stop:
	@echo "Stopping containers..."
	ansible docker_hosts -m shell -a "docker stop \$$(docker ps -q)" --become

start:
	@echo "Starting containers..."
	ansible docker_hosts -m shell -a "docker start \$$(docker ps -aq)" --become

restart:
	@echo "Restarting containers..."
	ansible docker_hosts -m systemd -a "name=docker state=restarted" --become

# Ansible Docker Automation

Complete Docker infrastructure automation using Ansible - from installation to container orchestration.

## Features

- ✅ Docker & Docker Compose installation
- ✅ Container lifecycle management
- ✅ Network configuration
- ✅ Volume management
- ✅ Multi-container applications
- ✅ Docker Swarm cluster setup
- ✅ Container monitoring
- ✅ Automated backups
- ✅ Portainer for GUI management

## 🔗 Connect With Me

[![GitHub](https://img.shields.io/badge/GitHub-George--Nyamao-181717?style=for-the-badge&logo=github)](https://github.com/George-Nyamao)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-George_Nyamao-0A66C2?style=for-the-badge&logo=linkedin)](https://www.linkedin.com/in/george-nyamao-842137218/)
[![Email](https://img.shields.io/badge/Email-gmnyamao@hotmail.com-D14836?style=for-the-badge&logo=gmail)](mailto:gmnyamao@hotmail.com)

## Project Structure

```
.
├── ansible.cfg
├── site.yml
├── scale.yml
├── monitor.yml
├── backup-containers.yml
├── cleanup.yml
├── Makefile
├── inventory/
│   └── hosts
├── group_vars/
│   └── all.yml
└── roles/
    ├── docker/
    ├── containers/
    ├── docker-compose/
    └── swarm/
```

## Quick Start

### 1. Clone Repository

```bash
git clone https://github.com/George-Nyamao/ansible-docker-automation.git
cd ansible-docker-automation
```

### 2. Configure Inventory

Edit `inventory/hosts`:

```ini
[docker_hosts]
docker1 ansible_host=192.168.1.50
docker2 ansible_host=192.168.1.51
```

### 3. Install Dependencies

```bash
make install
```

### 4. Deploy Infrastructure

```bash
make deploy
```

### 5. Access Portainer

Navigate to: `http://YOUR_SERVER_IP:9000`

## Usage

### Deploy Full Stack

```bash
ansible-playbook site.yml
```

### Monitor Containers

```bash
make monitor
```

### Scale Services

```bash
ansible-playbook scale.yml
# or
make scale
```

### Backup Volumes

```bash
make backup
```

### Clean Up Resources

```bash
make cleanup
```

## Docker Compose Stack

The playbook deploys a complete application stack:

- **Nginx**: Reverse proxy and web server
- **Node.js**: Application backend
- **PostgreSQL**: Database
- **Redis**: Caching layer
- **Portainer**: Docker management UI

## Docker Swarm

For production deployments, the playbook can configure a Docker Swarm cluster:

```bash
ansible-playbook site.yml --tags swarm
```

## Management Commands

### List Running Containers

```bash
ansible docker_hosts -m shell -a "docker ps" --become
```

### View Container Logs

```bash
ansible docker_hosts -m shell -a "docker logs nginx_web" --become
```

### Execute Commands in Container

```bash
ansible docker_hosts -m shell -a "docker exec nginx_web nginx -t" --become
```

### Check Docker Status

```bash
ansible docker_hosts -m shell -a "docker info" --become
```

### Container Statistics

```bash
ansible docker_hosts -m shell -a "docker stats --no-stream" --become
```

## Container Operations

### Start All Containers

```bash
make start
```

### Stop All Containers

```bash
make stop
```

### Restart Docker Service

```bash
make restart
```

### Remove Stopped Containers

```bash
ansible docker_hosts -m shell -a "docker container prune -f" --become
```

### Remove Unused Images

```bash
ansible docker_hosts -m shell -a "docker image prune -a -f" --become
```

## Network Management

### List Networks

```bash
ansible docker_hosts -m shell -a "docker network ls" --become
```

### Inspect Network

```bash
ansible docker_hosts -m shell -a "docker network inspect frontend" --become
```

### Create Custom Network

```bash
ansible docker_hosts -m shell -a "docker network create mynetwork" --become
```

## Volume Management

### List Volumes

```bash
ansible docker_hosts -m shell -a "docker volume ls" --become
```

### Inspect Volume

```bash
ansible docker_hosts -m shell -a "docker volume inspect postgres_data" --become
```

### Backup Volume

```bash
ansible-playbook backup-containers.yml
```

## Troubleshooting

### Container Won't Start

```bash
# Check logs
ansible docker_hosts -m shell -a "docker logs CONTAINER_NAME" --become

# Inspect container
ansible docker_hosts -m shell -a "docker inspect CONTAINER_NAME" --become

# Check container status
ansible docker_hosts -m shell -a "docker ps -a | grep CONTAINER_NAME" --become
```

### Network Issues

```bash
# List networks
ansible docker_hosts -m shell -a "docker network ls" --become

# Inspect network
ansible docker_hosts -m shell -a "docker network inspect NETWORK_NAME" --become

# Test connectivity between containers
ansible docker_hosts -m shell -a "docker exec CONTAINER1 ping CONTAINER2" --become
```

### Volume Issues

```bash
# List volumes
ansible docker_hosts -m shell -a "docker volume ls" --become

# Inspect volume
ansible docker_hosts -m shell -a "docker volume inspect VOLUME_NAME" --become

# Check volume mount points
ansible docker_hosts -m shell -a "docker inspect -f '{{ .Mounts }}' CONTAINER_NAME" --become
```

### Performance Issues

```bash
# Check resource usage
ansible docker_hosts -m shell -a "docker stats --no-stream" --become

# Check disk usage
ansible docker_hosts -m shell -a "docker system df" --become

# Check system resources
ansible docker_hosts -m shell -a "free -h && df -h" --become
```

### Permission Issues

```bash
# Add user to docker group
ansible docker_hosts -m shell -a "usermod -aG docker $USER" --become

# Fix volume permissions
ansible docker_hosts -m shell -a "docker exec CONTAINER chown -R user:group /path" --become
```

## Docker Compose Operations

### View Compose Services

```bash
ansible docker_hosts -m shell -a "cd /opt/docker-apps/myapp && docker-compose ps" --become
```

### View Compose Logs

```bash
ansible docker_hosts -m shell -a "cd /opt/docker-apps/myapp && docker-compose logs" --become
```

### Restart Compose Stack

```bash
ansible docker_hosts -m shell -a "cd /opt/docker-apps/myapp && docker-compose restart" --become
```

### Update Compose Stack

```bash
ansible docker_hosts -m shell -a "cd /opt/docker-apps/myapp && docker-compose pull && docker-compose up -d" --become
```

## Docker Swarm Operations

### List Swarm Nodes

```bash
ansible swarm_managers -m shell -a "docker node ls" --become
```

### Deploy Stack to Swarm

```bash
ansible swarm_managers -m shell -a "docker stack deploy -c docker-compose.yml myapp" --become
```

### List Stack Services

```bash
ansible swarm_managers -m shell -a "docker stack services myapp" --become
```

### Scale Service in Swarm

```bash
ansible swarm_managers -m shell -a "docker service scale myapp_web=5" --become
```

### Remove Stack from Swarm

```bash
ansible swarm_managers -m shell -a "docker stack rm myapp" --become
```

## Monitoring and Logging

### Real-time Container Logs

```bash
# Follow logs for specific container
ansible docker_hosts -m shell -a "docker logs -f nginx_web" --become

# View last 100 lines
ansible docker_hosts -m shell -a "docker logs --tail 100 nginx_web" --become
```

### Container Resource Monitoring

```bash
# Live stats
ansible docker_hosts -m shell -a "docker stats" --become

# Single snapshot
ansible docker_hosts -m shell -a "docker stats --no-stream --format 'table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}'" --become
```

### System Information

```bash
# Docker version
ansible docker_hosts -m shell -a "docker version" --become

# Docker info
ansible docker_hosts -m shell -a "docker info" --become

# Disk usage
ansible docker_hosts -m shell -a "docker system df -v" --become
```

## Security Best Practices

1. **Use Secrets Management**: Store sensitive data in Docker secrets or environment files
2. **Network Segmentation**: Implement proper network isolation between containers
3. **Regular Updates**: Keep Docker and images updated
4. **Image Scanning**: Scan images for vulnerabilities before deployment
5. **Limit Container Privileges**: Run containers with minimal required privileges
6. **Read-only Filesystems**: Use read-only root filesystems where possible
7. **Resource Limits**: Set CPU and memory limits for containers
8. **Logging**: Centralize container logs for security monitoring
9. **User Namespaces**: Enable user namespace remapping
10. **TLS/SSL**: Use encrypted connections for sensitive services

## Backup and Recovery

### Automated Backups

Backups are configured to run on schedule. Manual backup:

```bash
make backup
```

### Restore from Backup

```bash
# Stop containers
make stop

# Restore volume data
ansible docker_hosts -m shell -a "tar -xzf /var/backups/docker/VOLUME_NAME_DATE.tar.gz -C /var/lib/docker/volumes/VOLUME_NAME/_data/" --become

# Start containers
make start
```

### Export/Import Containers

```bash
# Export container
ansible docker_hosts -m shell -a "docker export CONTAINER > container.tar" --become

# Import container
ansible docker_hosts -m shell -a "docker import container.tar myimage:tag" --become
```

## Performance Optimization

### Configure Docker Daemon

Edit daemon.json for performance tuning:

```json
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  },
  "storage-driver": "overlay2",
  "live-restore": true,
  "userland-proxy": false
}
```

### Optimize Images

```bash
# Use multi-stage builds
# Minimize layers
# Use .dockerignore
# Choose minimal base images
```

### Resource Limits

```yaml
services:
  app:
    deploy:
      resources:
        limits:
          cpus: '0.50'
          memory: 512M
        reservations:
          cpus: '0.25'
          memory: 256M
```

## CI/CD Integration

### GitHub Actions Example

```yaml
name: Deploy Docker Stack

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Install Ansible
        run: |
          sudo apt update
          sudo apt install -y ansible
      
      - name: Install Docker Collection
        run: ansible-galaxy collection install community.docker
      
      - name: Deploy
        run: ansible-playbook site.yml
        env:
          ANSIBLE_HOST_KEY_CHECKING: False
```

### Jenkins Pipeline Example

```groovy
pipeline {
    agent any
    stages {
        stage('Deploy Docker') {
            steps {
                sh 'ansible-playbook site.yml'
            }
        }
        stage('Test') {
            steps {
                sh 'ansible-playbook monitor.yml'
            }
        }
    }
}
```

## Advanced Usage

### Custom Docker Networks

```bash
# Create macvlan network
ansible docker_hosts -m shell -a "docker network create -d macvlan --subnet=192.168.1.0/24 --gateway=192.168.1.1 -o parent=eth0 macvlan_net" --become
```

### Docker Plugins

```bash
# Install volume plugin
ansible docker_hosts -m shell -a "docker plugin install --grant-all-permissions vieux/sshfs" --become
```

### Docker Registry

```bash
# Deploy private registry
ansible docker_hosts -m shell -a "docker run -d -p 5000:5000 --name registry registry:2" --become

# Push to private registry
ansible docker_hosts -m shell -a "docker tag myimage localhost:5000/myimage && docker push localhost:5000/myimage" --become
```

## Requirements

- Ansible 2.9+
- Ubuntu 20.04/22.04 target servers
- SSH access with sudo privileges
- Python 3.6+ on control node
- Minimum 2GB RAM per Docker host
- Minimum 20GB disk space per Docker host

## Dependencies

Install required Ansible collections:

```bash
ansible-galaxy collection install community.docker
```

## Support

[![GitHub Issues](https://img.shields.io/github/issues/George-Nyamao/ansible-docker-automation)](https://github.com/George-Nyamao/ansible-docker-automation/issues)
[![GitHub Discussions](https://img.shields.io/badge/GitHub-Discussions-181717?style=flat&logo=github)](https://github.com/George-Nyamao/ansible-docker-automation/discussions)

- **Issues**: [GitHub Issues](https://github.com/George-Nyamao/ansible-docker-automation/issues)
- **Documentation**: See [DEPLOYMENT.md](DEPLOYMENT.md) for detailed guide
- **Discussions**: [GitHub Discussions](https://github.com/George-Nyamao/ansible-docker-automation/discussions)

## Changelog

### v1.0.0 (2025-10-21)
- Initial release
- Docker installation automation
- Container lifecycle management
- Docker Compose integration
- Docker Swarm support
- Monitoring and backup features
- Portainer integration

## Author

**George Nyamao**
- GitHub: [@George-Nyamao](https://github.com/George-Nyamao)
- LinkedIn: [George Nyamao](https://www.linkedin.com/in/george-nyamao-842137218/)
- Email: gmnyamao@hotmail.com

## Acknowledgments

- Docker community
- Ansible community
- Contributors

---

⭐ **Star this repository if you find it helpful!**

## Related Projects

- [Ansible LAMP Stack](https://github.com/George-Nyamao/ansible-lamp-stack)
- [Ansible Kubernetes](https://github.com/George-Nyamao/ansible-kubernetes)
- [Ansible AWS Infrastructure](https://github.com/George-Nyamao/ansible-aws-infra)

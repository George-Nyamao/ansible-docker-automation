-check

# Run dry-run (check mode)
ansible-playbook site.yml --check

# Check connectivity
ansible docker -m ping
```

### Deploy Docker Infrastructure

```bash
# Full deployment
ansible-playbook site.yml

# Deploy with verbose output
ansible-playbook site.yml -v

# Deploy specific roles only
ansible-playbook site.yml --tags docker
ansible-playbook site.yml --tags containers
ansible-playbook site.yml --tags compose
ansible-playbook site.yml --tags swarm
```

### Using Makefile Commands

```bash
# Install dependencies
make install

# Check syntax
make check

# Deploy everything
make deploy

# Monitor containers
make monitor

# Create backups
make backup
```

### Deployment Steps Explained

#### 1. Docker Installation

The playbook will:
- Remove old Docker versions
- Install Docker CE and dependencies
- Configure Docker daemon
- Start and enable Docker service
- Create Docker networks
- Create Docker volumes
- Install Docker Compose
- Add users to docker group

#### 2. Container Deployment

The playbook will:
- Pull required Docker images
- Deploy PostgreSQL container
- Deploy Redis container
- Deploy Nginx container
- Configure health checks
- Verify container status

#### 3. Docker Compose Stack

The playbook will:
- Create application directory
- Deploy docker-compose.yml
- Deploy environment file (.env)
- Start all services
- Verify stack status

#### 4. Docker Swarm (Optional)

The playbook will:
- Initialize Swarm on manager node
- Generate join tokens
- Join worker nodes to cluster
- Deploy stack services
- Verify cluster status

## Post-Deployment

### Verify Installation

```bash
# Check Docker version
ansible docker_hosts -m shell -a "docker --version" --become

# Check Docker service status
ansible docker_hosts -m shell -a "systemctl status docker" --become

# List Docker networks
ansible docker_hosts -m shell -a "docker network ls" --become

# List Docker volumes
ansible docker_hosts -m shell -a "docker volume ls" --become

# List running containers
ansible docker_hosts -m shell -a "docker ps" --become
```

### Access Services

After successful deployment:

1. **Portainer UI**: `http://YOUR_SERVER_IP:9000`
   - First-time setup required
   - Create admin user
   - Connect to local Docker environment

2. **Application**: `http://YOUR_SERVER_IP:80`

3. **PostgreSQL**: Port 5432 (internal access only)

4. **Redis**: Port 6379 (internal access only)

### Configure Portainer

```bash
# Access Portainer
open http://192.168.1.50:9000

# Create admin user through web interface
# Connect to local Docker environment
```

### Verify Container Health

```bash
# Check container health status
ansible docker_hosts -m shell -a "docker ps --format 'table {{.Names}}\t{{.Status}}'" --become

# Check specific container logs
ansible docker_hosts -m shell -a "docker logs nginx_web" --become

# Inspect container details
ansible docker_hosts -m shell -a "docker inspect nginx_web" --become
```

## Container Management

### Starting and Stopping Containers

```bash
# Stop all containers
make stop
# or
ansible docker_hosts -m shell -a "docker stop \$(docker ps -q)" --become

# Start all containers
make start
# or
ansible docker_hosts -m shell -a "docker start \$(docker ps -aq)" --become

# Restart specific container
ansible docker_hosts -m shell -a "docker restart nginx_web" --become

# Restart Docker service
make restart
# or
ansible docker_hosts -m systemd -a "name=docker state=restarted" --become
```

### Scaling Services

```bash
# Scale using playbook
ansible-playbook scale.yml

# Scale specific service in Swarm
ansible swarm_managers -m shell -a "docker service scale myapp_web=5" --become

# Verify scaling
ansible swarm_managers -m shell -a "docker service ls" --become
```

### Updating Containers

```bash
# Pull latest images
ansible docker_hosts -m shell -a "docker pull nginx:alpine" --become

# Recreate container with new image
ansible docker_hosts -m shell -a "docker-compose up -d --force-recreate nginx" --become

# Update all services in compose stack
ansible docker_hosts -m shell -a "cd /opt/docker-apps/myapp && docker-compose pull && docker-compose up -d" --become
```

### Monitoring Containers

```bash
# Run monitoring playbook
ansible-playbook monitor.yml

# Real-time stats
ansible docker_hosts -m shell -a "docker stats" --become

# Container resource usage
ansible docker_hosts -m shell -a "docker stats --no-stream --format 'table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}'" --become

# Disk usage
ansible docker_hosts -m shell -a "docker system df" --become

# Detailed disk usage
ansible docker_hosts -m shell -a "docker system df -v" --become
```

## Backup and Recovery

### Manual Backup

```bash
# Run backup playbook
ansible-playbook backup-containers.yml

# Verify backups
ansible docker_hosts -m shell -a "ls -lh /var/backups/docker/" --become
```

### Automated Backups

Set up cron job for automated backups:

```bash
# Add to crontab (runs daily at 2 AM)
ansible docker_hosts -m cron -a "name='Docker backup' minute=0 hour=2 job='cd /path/to/playbooks && ansible-playbook backup-containers.yml'" --become
```

### Restore from Backup

```bash
# Stop containers
ansible docker_hosts -m shell -a "docker-compose down" --become

# Restore volume
ansible docker_hosts -m shell -a "docker run --rm -v postgres_data:/data -v /var/backups/docker:/backup alpine tar xzf /backup/postgres_data_2024-01-15.tar.gz -C /data" --become

# Start containers
ansible docker_hosts -m shell -a "docker-compose up -d" --become
```

### Export and Import Containers

```bash
# Export container as image
ansible docker_hosts -m shell -a "docker commit nginx_web nginx_backup:latest" --become
ansible docker_hosts -m shell -a "docker save nginx_backup:latest > /tmp/nginx_backup.tar" --become

# Import on another host
ansible docker_hosts -m shell -a "docker load < /tmp/nginx_backup.tar" --become
```

## Troubleshooting

### Docker Service Issues

```bash
# Check Docker service status
ansible docker_hosts -m shell -a "systemctl status docker" --become

# View Docker service logs
ansible docker_hosts -m shell -a "journalctl -u docker -n 50" --become

# Restart Docker service
ansible docker_hosts -m systemd -a "name=docker state=restarted" --become

# Check Docker daemon configuration
ansible docker_hosts -m shell -a "cat /etc/docker/daemon.json" --become
```

### Container Issues

```bash
# Check container logs
ansible docker_hosts -m shell -a "docker logs --tail 100 CONTAINER_NAME" --become

# Follow logs in real-time
ansible docker_hosts -m shell -a "docker logs -f CONTAINER_NAME" --become

# Inspect container configuration
ansible docker_hosts -m shell -a "docker inspect CONTAINER_NAME" --become

# Check container processes
ansible docker_hosts -m shell -a "docker top CONTAINER_NAME" --become

# Execute commands inside container
ansible docker_hosts -m shell -a "docker exec CONTAINER_NAME command" --become
```

### Network Issues

```bash
# List networks
ansible docker_hosts -m shell -a "docker network ls" --become

# Inspect network
ansible docker_hosts -m shell -a "docker network inspect frontend" --become

# Test connectivity between containers
ansible docker_hosts -m shell -a "docker exec container1 ping -c 3 container2" --become

# Check container network settings
ansible docker_hosts -m shell -a "docker inspect --format='{{.NetworkSettings.Networks}}' CONTAINER_NAME" --become
```

### Volume Issues

```bash
# List volumes
ansible docker_hosts -m shell -a "docker volume ls" --become

# Inspect volume
ansible docker_hosts -m shell -a "docker volume inspect VOLUME_NAME" --become

# Check volume usage
ansible docker_hosts -m shell -a "docker system df -v | grep VOLUME_NAME" --become

# Check volume mount points
ansible docker_hosts -m shell -a "docker inspect --format='{{.Mounts}}' CONTAINER_NAME" --become
```

### Image Issues

```bash
# List images
ansible docker_hosts -m shell -a "docker images" --become

# Check image history
ansible docker_hosts -m shell -a "docker history IMAGE_NAME" --become

# Inspect image
ansible docker_hosts -m shell -a "docker inspect IMAGE_NAME" --become

# Remove dangling images
ansible docker_hosts -m shell -a "docker image prune -f" --become
```

### Permission Issues

```bash
# Check Docker socket permissions
ansible docker_hosts -m shell -a "ls -l /var/run/docker.sock" --become

# Add user to docker group
ansible docker_hosts -m shell -a "usermod -aG docker USERNAME" --become

# Verify group membership
ansible docker_hosts -m shell -a "groups USERNAME" --become

# Fix volume permissions
ansible docker_hosts -m shell -a "docker exec CONTAINER chown -R user:group /path/to/data" --become
```

### Performance Issues

```bash
# Check system resources
ansible docker_hosts -m shell -a "free -h && df -h" --become

# Check Docker resource usage
ansible docker_hosts -m shell -a "docker stats --no-stream" --become

# Check container resource limits
ansible docker_hosts -m shell -a "docker inspect --format='{{.HostConfig.Memory}} {{.HostConfig.NanoCpus}}' CONTAINER_NAME" --become

# Clean up unused resources
ansible-playbook cleanup.yml
```

### Swarm Issues

```bash
# Check Swarm status
ansible swarm_managers -m shell -a "docker info | grep Swarm" --become

# List Swarm nodes
ansible swarm_managers -m shell -a "docker node ls" --become

# Check node status
ansible swarm_managers -m shell -a "docker node inspect NODE_ID" --become

# View Swarm service logs
ansible swarm_managers -m shell -a "docker service logs SERVICE_NAME" --become

# Check service tasks
ansible swarm_managers -m shell -a "docker service ps SERVICE_NAME" --become
```

## Cleanup

### Remove Stopped Containers

```bash
ansible docker_hosts -m shell -a "docker container prune -f" --become
```

### Remove Unused Images

```bash
ansible docker_hosts -m shell -a "docker image prune -a -f" --become
```

### Remove Unused Volumes

```bash
ansible docker_hosts -m shell -a "docker volume prune -f" --become
```

### Remove Unused Networks

```bash
ansible docker_hosts -m shell -a "docker network prune -f" --become
```

### Complete Cleanup

```bash
# Run cleanup playbook
ansible-playbook cleanup.yml

# Or manually clean everything
ansible docker_hosts -m shell -a "docker system prune -a --volumes -f" --become
```

## Best Practices

### Security

1. **Use secrets for sensitive data**
   ```bash
   # Create secret
   docker secret create db_password password.txt
   
   # Use in service
   docker service create --secret db_password myapp
   ```

2. **Implement network segmentation**
   - Separate frontend and backend networks
   - Limit container-to-container communication
   - Use internal networks where possible

3. **Regular updates**
   ```bash
   # Update Docker
   ansible docker_hosts -m apt -a "name=docker-ce state=latest update_cache=yes" --become
   
   # Update images regularly
   ansible docker_hosts -m shell -a "docker images --format '{{.Repository}}:{{.Tag}}' | xargs -L1 docker pull" --become
   ```

4. **Scan images for vulnerabilities**
   ```bash
   # Install Trivy
   ansible docker_hosts -m shell -a "docker pull aquasec/trivy" --become
   
   # Scan image
   ansible docker_hosts -m shell -a "docker run aquasec/trivy image IMAGE_NAME" --become
   ```

5. **Use read-only containers**
   ```yaml
   services:
     app:
       read_only: true
       tmpfs:
         - /tmp
   ```

### Performance

1. **Set resource limits**
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

2. **Optimize Docker daemon**
   ```json
   {
     "log-driver": "json-file",
     "log-opts": {
       "max-size": "10m",
       "max-file": "3"
     },
     "storage-driver": "overlay2"
   }
   ```

3. **Use multi-stage builds**
   ```dockerfile
   # Build stage
   FROM node:18 AS builder
   WORKDIR /app
   COPY package*.json ./
   RUN npm ci
   COPY . .
   RUN npm run build
   
   # Production stage
   FROM node:18-alpine
   WORKDIR /app
   COPY --from=builder /app/dist ./dist
   CMD ["node", "dist/index.js"]
   ```

4. **Implement health checks**
   ```yaml
   services:
     app:
       healthcheck:
         test: ["CMD", "curl", "-f", "http://localhost/health"]
         interval: 30s
         timeout: 10s
         retries: 3
         start_period: 40s
   ```

### Monitoring

1. **Container logs**
   ```bash
   # Centralize logs
   docker plugin install grafana/loki-docker-driver:latest --alias loki --grant-all-permissions
   ```

2. **Metrics collection**
   - Deploy Prometheus and Grafana
   - Use cAdvisor for container metrics
   - Monitor Docker daemon metrics

3. **Alerting**
   - Set up alerts for container failures
   - Monitor resource usage
   - Track image vulnerabilities

### Maintenance

1. **Regular cleanup**
   ```bash
   # Schedule weekly cleanup
   ansible docker_hosts -m cron -a "name='Docker cleanup' minute=0 hour=3 weekday=0 job='docker system prune -f'" --become
   ```

2. **Update strategy**
   - Test updates in staging first
   - Use rolling updates for Swarm services
   - Keep backups before major updates

3. **Documentation**
   - Document custom configurations
   - Keep inventory up-to-date
   - Record troubleshooting steps

## Advanced Configuration

### Custom Docker Networks

```bash
# Create overlay network for Swarm
ansible swarm_managers -m shell -a "docker network create --driver overlay --attachable myoverlay" --become

# Create macvlan network
ansible docker_hosts -m shell -a "docker network create -d macvlan --subnet=192.168.1.0/24 --gateway=192.168.1.1 -o parent=eth0 macvlan_net" --become
```

### Docker Registry

```bash
# Deploy private registry
ansible docker_hosts -m shell -a "docker run -d -p 5000:5000 --restart=always --name registry -v /mnt/registry:/var/lib/registry registry:2" --become

# Configure insecure registry
ansible docker_hosts -m lineinfile -a "path=/etc/docker/daemon.json line='  \"insecure-registries\": [\"192.168.1.50:5000\"]' insertafter='{'" --become

# Restart Docker
ansible docker_hosts -m systemd -a "name=docker state=restarted" --become
```

### Docker Secrets

```bash
# Create secret
echo "my_secret_password" | ansible swarm_managers -m shell -a "docker secret create db_password -" --become

# Use secret in service
ansible swarm_managers -m shell -a "docker service create --secret db_password --name myapp myimage" --become
```

## Support and Resources

### Documentation
- [Official Docker Documentation](https://docs.docker.com/)
- [Ansible Docker Modules](https://docs.ansible.com/ansible/latest/collections/community/docker/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)

### Community
- [Docker Community Forums](https://forums.docker.com/)
- [Ansible Community](https://www.ansible.com/community)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/docker)

### Training
- [Docker Official Training](https://www.docker.com/training/)
- [Ansible Training](https://www.ansible.com/products/training-certification)

## Appendix

### Useful Commands Reference

```bash
# Docker Commands
docker ps                    # List running containers
docker ps -a                 # List all containers
docker images                # List images
docker logs CONTAINER        # View logs
docker exec -it CONTAINER sh # Execute shell
docker inspect CONTAINER     # Inspect container
docker stats                 # Live stats
docker system df             # Disk usage

# Docker Compose Commands
docker-compose up -d         # Start services
docker-compose down          # Stop services
docker-compose ps            # List services
docker-compose logs          # View logs
docker-compose restart       # Restart services

# Docker Swarm Commands
docker swarm init            # Initialize swarm
docker node ls               # List nodes
docker service ls            # List services
docker service ps SERVICE    # List tasks
docker stack deploy          # Deploy stack
```

### Environment Variables

```bash
# Docker daemon environment
DOCKER_HOST               # Docker daemon socket
DOCKER_TLS_VERIFY        # Enable TLS verification
DOCKER_CERT_PATH         # Path to certificates
cd ~/ansible-projects/ansible-docker-automation

# First, complete the DEPLOYMENT.md file
cat >> DEPLOYMENT.md << 'EOF'

# Compose environment
COMPOSE_PROJECT_NAME     # Project name
COMPOSE_FILE            # Compose file path
```

### Port Reference

```
22    - SSH
80    - HTTP
443   - HTTPS
2377  - Docker Swarm (cluster management)
7946  - Docker Swarm (node communication)
4789  - Docker Swarm (overlay network)
5000  - Docker Registry
9000  - Portainer
5432  - PostgreSQL
6379  - Redis
```

### Troubleshooting Checklist

- [ ] Check Docker service status
- [ ] Verify container logs
- [ ] Check network connectivity
- [ ] Verify volume mounts
- [ ] Check resource usage
- [ ] Review firewall rules
- [ ] Verify DNS resolution
- [ ] Check permission issues
- [ ] Review security groups (cloud)
- [ ] Verify image availability

## Conclusion

This deployment guide covers the complete lifecycle of Docker infrastructure management using Ansible. For additional help, refer to the main README.md or open an issue on GitHub.

---

**Last Updated**: 2024-01-XX

**Version**: 1.0.0

# PowerDNS Operator Examples

This directory contains comprehensive examples for using the PowerDNS Operator in various scenarios. These examples demonstrate best practices, deployment patterns, and real-world use cases.

## 📁 File Structure

```
examples/
├── README.md                    # This file
├── basic-zone.yaml             # Basic zone configurations
├── rrset-examples.yaml         # Comprehensive RRset examples
├── cluster-resources.yaml      # Cluster-scoped resource examples
└── deployment-patterns.yaml    # GitOps and deployment strategies
```

## 🚀 Quick Start

### 1. Basic Zone Setup

Start with simple zone and record configurations:

```bash
# Apply basic zone examples
kubectl apply -f basic-zone.yaml

# Check created resources
kubectl get zones,rrsets -o wide
```

### 2. Cluster-Wide Resources

For platform teams managing cluster-wide DNS:

```bash
# Apply cluster-scoped resources
kubectl apply -f cluster-resources.yaml

# Check cluster resources
kubectl get clusterzones,clusterrrsets -o wide
```

### 3. Advanced Deployment Patterns

Explore GitOps workflows and deployment strategies:

```bash
# Apply deployment patterns (select relevant sections)
kubectl apply -f deployment-patterns.yaml
```

## 📚 Example Categories

### Basic Zone Examples (`basic-zone.yaml`)

Contains fundamental zone configurations:

- **Simple Zone**: Basic domain setup
- **Development Zone**: Short TTL for rapid iteration
- **Production Zone**: High-availability configuration
- **Regional Zones**: Geographic-specific setups
- **Service Zones**: Microservice discovery patterns
- **Catalog Zones**: PowerDNS catalog integration

**Use Cases:**
- Setting up your first DNS zone
- Environment-specific configurations
- Multi-tenant zone management

### RRset Examples (`rrset-examples.yaml`)

Comprehensive DNS record configurations:

- **A Records**: IPv4 address mappings
- **AAAA Records**: IPv6 address mappings
- **CNAME Records**: Canonical name aliases
- **MX Records**: Mail exchange servers
- **TXT Records**: SPF, DKIM, verification records
- **SRV Records**: Service discovery
- **PTR Records**: Reverse DNS lookups
- **CAA Records**: Certificate authority authorization

**Use Cases:**
- Web service endpoints
- Email server configuration
- Load balancer setups
- SSL certificate management
- Service discovery
- Security policy enforcement

### Cluster Resources (`cluster-resources.yaml`)

Platform-level DNS management:

- **Corporate Zones**: Main company domains
- **Infrastructure Services**: Shared platform services
- **Global Load Balancers**: Multi-region endpoints
- **Security Records**: SPF, DMARC, CAA policies
- **Monitoring Services**: Observability endpoints
- **Certificate Management**: Wildcard and automation

**Use Cases:**
- Platform team DNS management
- Corporate domain policies
- Shared infrastructure services
- Global service endpoints
- Security and compliance

### Deployment Patterns (`deployment-patterns.yaml`)

Advanced deployment strategies:

- **Blue-Green Deployments**: Zero-downtime releases
- **Canary Deployments**: Gradual traffic shifting
- **Multi-Region Deployments**: Geographic distribution
- **A/B Testing**: Traffic splitting for experiments
- **Feature Flags**: Conditional DNS routing
- **Disaster Recovery**: Failover configurations
- **GitOps Workflows**: ArgoCD and Flux integration
- **Monitoring Setup**: Prometheus and alerting

**Use Cases:**
- Production deployment strategies
- GitOps automation
- Traffic management
- Disaster recovery planning
- Monitoring and observability

## 🛠️ Usage Patterns

### For Platform Teams

1. **Start with cluster resources:**
   ```bash
   kubectl apply -f cluster-resources.yaml
   ```

2. **Set up monitoring:**
   ```bash
   # Extract monitoring section from deployment-patterns.yaml
   kubectl apply -f deployment-patterns.yaml --selector=component=monitoring
   ```

3. **Configure security policies:**
   ```bash
   # Apply CAA, SPF, DMARC records
   kubectl apply -f cluster-resources.yaml --selector=purpose=email-auth
   ```

### For Development Teams

1. **Create application zones:**
   ```bash
   kubectl apply -f basic-zone.yaml --selector=environment=development
   ```

2. **Add service records:**
   ```bash
   kubectl apply -f rrset-examples.yaml --selector=service=your-app
   ```

3. **Set up load balancing:**
   ```bash
   # Apply multiple A records for load balancing
   kubectl apply -f rrset-examples.yaml --selector=purpose=load-balancing
   ```

### For DevOps Teams

1. **Implement blue-green deployments:**
   ```bash
   # Apply blue-green pattern
   kubectl apply -f deployment-patterns.yaml --selector=deployment-strategy=blue-green
   ```

2. **Set up canary deployments:**
   ```bash
   # Apply canary pattern
   kubectl apply -f deployment-patterns.yaml --selector=deployment-strategy=canary
   ```

3. **Configure monitoring:**
   ```bash
   # Apply monitoring and alerting
   kubectl apply -f deployment-patterns.yaml --selector=component=monitoring
   ```

## 🔧 Customization Guide

### Environment-Specific Configurations

#### Development Environment
```yaml
metadata:
  labels:
    environment: development
spec:
  ttl: 60  # Short TTL for rapid changes
```

#### Staging Environment
```yaml
metadata:
  labels:
    environment: staging
spec:
  ttl: 300  # Medium TTL for testing
```

#### Production Environment
```yaml
metadata:
  labels:
    environment: production
    criticality: high
spec:
  ttl: 3600  # Longer TTL for stability
```

### Multi-Tenant Setup

#### Namespace-based Isolation
```yaml
apiVersion: dns.cav.enablers.ob/v1alpha2
kind: Zone
metadata:
  name: team-alpha.company.com
  namespace: team-alpha
spec:
  # Team-specific configuration
```

#### Label-based Organization
```yaml
metadata:
  labels:
    team: backend
    service: api
    environment: production
```

### Security Configurations

#### Network Policies
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: dns-team-isolation
spec:
  podSelector:
    matchLabels:
      team: alpha
  # Restrict DNS management access
```

#### RBAC Controls
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: dns-team-admin
rules:
- apiGroups: ["dns.cav.enablers.ob"]
  resources: ["zones", "rrsets"]
  verbs: ["get", "list", "create", "update", "patch", "delete"]
```

## 📊 Monitoring Examples

### Resource Status Checking
```bash
# Check all DNS resources
kubectl get clusterzones,zones,clusterrrsets,rrsets --all-namespaces -o wide

# Detailed resource information
kubectl describe zone example.com -n production

# Check events
kubectl get events --field-selector involvedObject.name=example.com -n production
```

### Health Checks
```bash
# Test DNS resolution
dig @your-powerdns-server www.example.com

# Check operator health
kubectl get pods -n powerdns-operator-system
kubectl logs -n powerdns-operator-system deployment/powerdns-operator-controller-manager
```

### Metrics Collection
```bash
# Port forward to metrics endpoint
kubectl port-forward -n powerdns-operator-system \
  service/powerdns-operator-controller-manager-metrics-service 8080:8443

# Collect metrics
curl -k https://localhost:8080/metrics | grep powerdns
```

## 🚨 Troubleshooting

### Common Issues

#### Resources Stuck in Pending
```bash
# Check resource status
kubectl describe zone example.com -n production

# Force reconciliation
kubectl annotate zone example.com powerdns-operator/reconcile="$(date +%s)" -n production
```

#### DNS Records Not Updating
```bash
# Check PowerDNS server directly
curl -H "X-API-Key: your-api-key" \
     http://powerdns-server:8081/api/v1/servers/localhost/zones/example.com

# Compare with Kubernetes resource
kubectl get rrset example-record -o yaml -n production
```

#### Permission Errors
```bash
# Check RBAC permissions
kubectl auth can-i create zones --as=system:serviceaccount:production:default

# View current permissions
kubectl describe rolebinding -n production
```

## 🔄 GitOps Integration

### ArgoCD Application
```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: dns-config
spec:
  source:
    repoURL: https://github.com/company/dns-config
    path: examples/
    targetRevision: main
  destination:
    server: https://kubernetes.default.svc
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
```

### Flux HelmRelease
```yaml
apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: dns-config
spec:
  chart:
    spec:
      chart: ./examples
      sourceRef:
        kind: GitRepository
        name: dns-config
```

## 📋 Best Practices

### 1. Resource Naming
- Use descriptive names: `api-production-com` instead of `api1`
- Include environment in names: `api-prod`, `api-staging`
- Use consistent naming patterns across teams

### 2. Label Management
```yaml
metadata:
  labels:
    app: my-application
    environment: production
    team: backend
    version: v1.2.3
    managed-by: powerdns-operator
```

### 3. TTL Configuration
- **Development**: 60 seconds (rapid iteration)
- **Staging**: 300 seconds (testing)
- **Production**: 3600 seconds (stability)
- **Critical Services**: 300 seconds (faster failover)

### 4. Security
- Always use TLS for PowerDNS API communication
- Implement proper RBAC controls
- Regular API key rotation
- Network policy enforcement

### 5. Monitoring
- Set up Prometheus monitoring
- Configure alerting for failures
- Regular health checks
- Automated testing

## 🔗 Related Documentation

- [Security Guide](../docs/guides/security.md) - Security best practices
- [Troubleshooting Guide](../docs/guides/troubleshooting.md) - Problem resolution
- [Getting Started](../docs/guides/getting-started-advanced.md) - Comprehensive setup guide
- [API Reference](../docs/guides/zones.md) - Resource specifications

## 💡 Tips and Tricks

### Quick Commands
```bash
# Watch resource changes
kubectl get zones,rrsets --all-namespaces -w

# Export existing configuration
kubectl get zones,rrsets --all-namespaces -o yaml > backup.yaml

# Batch apply with labels
kubectl apply -f . --selector=environment=production

# Force reconciliation of all zones
kubectl get zones --all-namespaces -o name | \
  xargs -I {} kubectl annotate {} powerdns-operator/reconcile="$(date +%s)"
```

### Validation
```bash
# Validate YAML before applying
kubectl apply --dry-run=client -f your-config.yaml

# Validate with server-side checks
kubectl apply --dry-run=server -f your-config.yaml
```

### Backup and Recovery
```bash
# Backup all DNS resources
kubectl get clusterzones,zones,clusterrrsets,rrsets --all-namespaces -o yaml > dns-backup.yaml

# Restore from backup
kubectl apply -f dns-backup.yaml
```

---

These examples provide a solid foundation for implementing DNS management with PowerDNS Operator. Start with the basic examples and gradually adopt more advanced patterns as your needs evolve.

For questions or contributions, please refer to our [Contributing Guide](../CONTRIBUTING.md).
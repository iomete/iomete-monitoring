# IOMETE Monitoring Chart

A Helm chart for deploying the IOMETE monitoring stack, which includes Prometheus, Grafana, AlertManager, and various exporters.

## Overview

This Helm chart deploys a complete monitoring solution for IOMETE data planes, including:

- Prometheus for metrics collection and storage
- Grafana for visualization
- AlertManager for alert management
- Node Exporter for host metrics
- Blackbox Exporter for endpoint monitoring
- PostgreSQL Exporter for database metrics
- Custom health check exporter

## Prerequisites

- Kubernetes 1.16+
- Helm 3.0+
- PV provisioner support in the underlying infrastructure (if using persistent storage)

## Installation

```bash
# Install the chart from local directory
helm install monitoring . \
  --namespace iomete-system \
  --create-namespace \
  -f values.yaml
```

## Configuration

### Required Values

The following values must be configured in your `values.yaml`:

```yaml
# Data plane namespaces to monitor
dataPlaneNamespaces:
  - "lakehouse-1"
  - "lakehouse-2"

# Database configuration
database:
  host: "postgresql"
  adminCredentials:
    user: "postgres"
    password: "your-password"

# Storage configuration
storage:
  bucketName: "lakehouse"
  type: "minio"
  minioSettings:
    endpoint: "http://minio:9000"
    accessKey: "your-access-key"
    secretKey: "your-secret-key"

# Grafana admin password
grafana:
  adminPassword: "your-secure-password"
```

### Optional Features

#### Alert Notifications

Configure various notification channels in AlertManager:

```yaml
alertmanager:
  slack:
    url: "https://hooks.slack.com/services/YOUR-WEBHOOK-URL"
    channels:
      critical: "#alerts-critical"
      warning: "#alerts-warning"
      info: "#alerts-info"

  telegram:
    bot_token: "YOUR-BOT-TOKEN"
    channels:
      critical: -100123456789
      warning: -100123456788
      info: -100123456787
```

#### Storage Configuration

Choose between ephemeral storage (emptyDir) or persistent storage (PVC):

```yaml
grafana:
  storage:
    type: pvc  # or emptyDir
    pvc:
      storageClassName: "standard"
      size: 10Gi
```

## Testing

Run the Helm tests to verify the deployment:

```bash
helm test monitoring -n iomete-system
```

## Upgrading

```bash
helm upgrade monitoring . \
  --namespace iomete-system \
  -f values.yaml
```

## Uninstallation

```bash
helm uninstall monitoring -n iomete-system
```

## Development

### Running Tests Locally

```bash
# Lint the chart
helm lint .

# Run unit tests
helm unittest .

# Test template rendering
helm template . --debug
```

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a new Pull Request

## License

Apache License 2.0 
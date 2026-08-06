# Cloud DevOps Project — End-to-End Kubernetes on AWS

A production-shaped pipeline: a Python app that is containerized, security-scanned,
and continuously deployed to a Kubernetes cluster on AWS (EKS) — with the cluster
itself provisioned as code, GitOps-driven delivery, and full monitoring.

> Built as a hands-on cloud engineering portfolio project.

## Architecture

```
Code (GitHub)
   │
   ▼
GitHub Actions CI  ──►  run tests  ──►  Trivy security scan  ──►  build image  ──►  Amazon ECR
                                                                                        │
                                                                                        ▼
                                                          Argo CD (GitOps) ──► Amazon EKS (Kubernetes)
                                                                                        │
                                                                                        ▼
                                                             Prometheus + Grafana (monitoring)

Infrastructure (VPC, EKS, IAM) provisioned with Terraform.
```

## Tech stack

| Layer | Tool |
|---|---|
| App | Python (Flask) |
| Container | Docker |
| Registry | Amazon ECR |
| CI/CD | GitHub Actions |
| Security | Trivy |
| Infrastructure as Code | Terraform |
| Orchestration | Amazon EKS (Kubernetes) |
| GitOps | Argo CD |
| Monitoring | Prometheus + Grafana |

## Run locally

```bash
pip install -r requirements.txt
python app.py
# visit http://localhost:5000  and  http://localhost:5000/health
```

Run the tests:

```bash
pytest
```

## Project progress

- [x] Phase 0 — App + repo + README
- [ ] Phase 1 — Containerize with Docker
- [ ] Phase 2 — Push image to registry (ECR)
- [ ] Phase 3 — CI pipeline (GitHub Actions)
- [ ] Phase 4 — Security scanning (Trivy)
- [ ] Phase 5 — Provision AWS infra with Terraform
- [ ] Phase 6 — Deploy to EKS
- [ ] Phase 7 — GitOps with Argo CD
- [ ] Phase 8 — Monitoring (Prometheus + Grafana)

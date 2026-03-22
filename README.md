<img width="1162" height="620" alt="workflow" src="https://github.com/user-attachments/assets/a6349590-d34f-4c03-b2a6-b056146b3784" />


# DevSecOps Pipeline: Automated Infrastructure & CI/CD Workflow

This project implements a fully automated DevSecOps pipeline, from infrastructure provisioning with **Terraform** to configuration management via **Ansible**, and a robust **Jenkins** CI/CD pipeline integrated with multi-layered security scanning.

---

## 1. Infrastructure & Configuration (IaC)

### **Terraform**
Provisions the core AWS infrastructure components:
* **Compute:** 4 EC2 Instances (Jenkins Master, Security Node, Application Server, Monitoring Server).
* **Networking:** Custom Security Groups with least-privilege access rules.
* **Storage & Identity:** AWS S3 bucket for security report storage and IAM roles for cross-service permissions.

### **Ansible**
Connects via SSH to perform baseline configuration on all nodes:
* **Environment:** Installs system dependencies and Docker engine.
* **Jenkins:** Automated setup and configuration of the Jenkins Master.
* **Security Tools:** Installs and configures **Trivy**, **Snyk**, and **SonarQube** environments.

---

## 2. Main CI/CD Workflow

1.  **Trigger:** Developer pushes source code along with a `Jenkinsfile` to the Git Repository. A Webhook automatically triggers the **Jenkins Master**.
2.  **Security Scanning:** Jenkins coordinates agents to execute parallel security gates:
    * **Node Security:** Executes **Snyk** (SCA) and **Trivy** (Container Image Scanning).
    * **SonarQube Node:** Performs Static Application Security Testing (**SAST**) and code quality analysis.
3.  **Reporting:** All scan results and security audit logs are automatically uploaded to the **AWS S3** bucket for compliance and tracking.
4.  **Deployment:** Only if all security checks **PASS**, Jenkins pulls the verified Docker image and deploys it to the **Application VM**.

---

## 3. Monitoring

### **Monitor VM**
A dedicated monitoring node (e.g., Prometheus/Grafana) that:
* Collects infrastructure metrics (CPU, RAM, Disk) from all 4 EC2 instances.
* Tracks application-level health and pipeline performance to ensure 24/7 system reliability.

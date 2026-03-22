<img width="1162" height="620" alt="workflow" src="https://github.com/user-attachments/assets/a6349590-d34f-4c03-b2a6-b056146b3784" />
Here is a concise English description of your project workflow:

* Infrastructure & Configuration (IaC)
** Terraform: Provisions 4 EC2 instances (Jenkins, Security, Application, Monitor), Security Groups, S3 bucket, and IAM roles.

*** Ansible: Connects via SSH to configure the environment:
*** Installs dependencies and Docker.
*** Sets up Jenkins Master.
*** Installs/configures scanning tools (Trivy, Snyk, SonarQube).
* Main CI/CD Workflow
** Trigger: Developer pushes code + Jenkinsfile to Git; Webhook triggers Jenkins Master.
** Security Scanning: Jenkins coordinates agents to run parallel scans:
*** Node Security: Runs Snyk & Trivy (SCA/Container scan).
*** SonarQube Node: Performs Static Analysis (SAST).
*** Reporting: All security reports are uploaded to an AWS S3 bucket.
** Deployment: If all security checks PASS, Jenkins pulls the Docker image and deploys it to the Application VM.

* Monitoring
Monitor VM: Collects infrastructure and application metrics from all VMs to ensure system health.

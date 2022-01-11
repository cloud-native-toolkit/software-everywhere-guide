# Configure Environment

Configure the toolkit development environment after installation

## Post installation Tools setup

The following post installation setup is required. To get the developers enabled quickly, make sure you have completed at least post installation tasks. The customization is optional and down to development team needs.

- Configure the RBAC rules in the development cluster. This restricts who can change the parts of the cluster where the tools are installed. Run the RBAC script `./terraform/scripts/rbac.sh {ACCESS-GROUP}`, where `{ACCESS-GROUP}` is the name of the user group (i.e. `{resource_group}-USER`).
- Perform the steps in [Configure Dashboard](../customize/config-dashboard/dashboard.md) to add tiles and menu items for the tools that are external to the cluster: the Image Registry, GitHub, LogDNA, Sysdig, etc.
- If running on IBM Cloud:
    - Check you log data if flowing into LogDNA
    - Complete the [setup of Sysdig](ibmcloud-setup.md) and check the monitoring data is flowing

- Managing development assets is an important part of any **Software Development Life Cycle** (SDLC), The open source version of Artifactory has been installed into the cluster, This enables the full end to end process SDLC to be demonstrated. This version requires some manual configuration after its installation. These these instructions can be found here [Artifactory Setup](../admin/artifactory-setup.md)

- Complete the [Argo CD Setup](../admin/argo-cd-setup.md#configuration), this configures ArgoCD to use Artifactory as a Helm Repository
- Test opening the [Developer Dashboard](../../reference/dashboard.md)
  - Run either or all of the CLI options to load the dashboard `oc dashboard | kubectl dashboard | igc dashboard`
- Test the pipeline by [deploying a first app](../../learning/fast-ci.md)
- [Set up a GitOps repo](../../learning/fast-cd.md#set-up-the-gitops-repo) to validate ArgoCD setup and configuration
- Generated new passwords for **SonarQube** and update the secret in the `tool` namespace
- Test all the installed tools with new passwords
- Test end to end flow for an application and validate the content in each tool

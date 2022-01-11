# Install CodeReady Workspaces on IBM Cloud cluster

Add the cloud hosted development integrated development environment, CodeReady Workspaces (CRW) to your environment

## Installing CodeReady Workspaces

CodeReady Workspaces can be easily added to your development experience using the Red Hat Operator Hub. See [Chapter 3. Installing CodeReady Workspaces from Operator Hub](https://access.redhat.com/documentation/en-us/red_hat_codeready_workspaces/1.1/html/administration_guide/installing-codeready-workspaces-from-operator-hub){: target=_blank}.

CodeReady Workspaces is a developer workspace server and cloud IDE. Workspaces are defined as project code files and all of their dependencies necessary to edit, build, run, and debug them. Each workspace has its own private IDE hosted within it. The IDE is accessible through a browser. The browser downloads the IDE as a single-page web application. CodeReady Workspaces will enable a 100% developer experience to be delivered from a user's browser. This is perfect for running enablement learning from constrained developer laptops, or for site reliability engineers (SREs) to make quick change to a microservice.

### CodeReady Workspaces Installation Pre-requisite

Do this first:

- Provision the OpenShift Cluster
- Ensure the logged in user has the Administrator privileges
- Ensure you have created a new Project to manage the "codeready workspace operator & cluster"

Setting up the CRW Operator & Cluster:

- Navigate to Operator Hub and search of the Red Hat CodeReady workspace. Click on the operator and select the appropriate workspace to install the CRW operator.
- Navigate to the installed operator to view the CRW operator.
- Now click the link visible as part of the operator to create/view the CheCluster part of the workspace
- Create the CheCluster button, to navigate to the YAML Configuration page (displays all the parameters).
- You need to change the following parameter mentioned below, As part of the storage section, please add the following parameters, depending on your cluster type:

    === "VPC"

        ```yaml
        postgresPVCStorageClassName: ibmc-vpc-block-10iops-tier
        workspacePVCStorageClassName: ibmc-vpc-block-10iops-tier
        ```

    === "Classic"

        ```yaml
        postgresPVCStorageClassName: ibmc-block-gold
        workspacePVCStorageClassName: ibmc-block-gold
        ```

- Post definition the yaml section for storage will look as below

    === "VPC"

        ```yaml
        storage:
        postgresPVCStorageClassName: ibmc-vpc-block-10iops-tier
        pvcStrategy: per-workspace
        pvcClaimSize: 1Gi
        preCreateSubPaths: true
        workspacePVCStorageClassName: ibmc-vpc-block-10iops-tier
        ```

    === "Classic"

        ```yaml
        storage:
        postgresPVCStorageClassName: ibmc-block-gold
        pvcStrategy: per-workspace
        pvcClaimSize: 1Gi
        preCreateSubPaths: true
        workspacePVCStorageClassName: ibmc-block-gold
        ```     

- Now create, the cluster after doing the above changes. The cluster will take few minutes to get created as its resources such as Postgres DB, Keycloak Auth, CRW workspace will get created.

- Once Cluster is created navigate to the overview tab of the CheCluster in the CRW operator. You will be able to see the below :
    - URL of the CodeReady Workspaces URL
    - URL of the Red Hat SSO Admin Console URL
    - oAuth SSO Enabled.
    - This should be enabled by default, if not please slide the button to enable and confirm
    - TLS Would be disabled. Please slide the button to enable https connectivity to the CRW workspace and confirm
    - You have now completed the provisioning of the Code Ready Workspaces operator into your development cluster and will enable it to be used by the developers that plan to use this development cluster

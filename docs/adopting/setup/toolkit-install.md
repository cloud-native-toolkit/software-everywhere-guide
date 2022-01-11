# Installing to toolkit to an existing cluster

<!--- cSpell:ignore tfvars cntk igcli datacenter -->

The fast-start install used in the [learning setup](../../setup/fast-start.md){: target=_blank} is one option if you want a standard install.

If you want to customize the Toolkit installation, then use the full Iteration Zero scripts.

## Iteration Zero

Steps to install the Cloud-Native Toolkit for running Openshift or Kubernetes clusters.

### A. Download the Iteration Zero scripts

1. Clone the [ibm-garage-iteration-zero](https://github.com/cloud-native-toolkit/ibm-garage-iteration-zero) Git repository to your local filesystem

    ```shell
    git clone git@github.com:cloud-native-toolkit/ibm-garage-iteration-zero.git
    ```

### B. Configure the credentials

1. In a terminal, change to the `ibm-garage-iteration-zero` cloned directory

    ```shell
    cd ibm-garage-iteration-zero
    ```

2. Copy the `credentials.template` file to a file named `credentials.properties`

    ```shell
    cp credentials.template credentials.properties
    ```

    !!!Note
        `credentials.properties` is already listed in `.gitignore` to prevent the private credentials from being committed to the git repository

3. If on IBM Cloud, update the value for the `ibmcloud.api.key` property in `credentials.properties` with your IBM Cloud API key

### C. Configure the Environment Variables

=== "IBM Cloud"

    #### A. Set Environment Variables

    The settings for creating the <Globals name="shortName" /> on <Globals name="ic" /> are set in the `environment-ibmcloud.tfvars`
    file in the `./terraform/settings` directory of the `ibm-garage-iteration-zero` repository.

    There are a number of values that can be applied in the file, some required and some optional. Consult with
    the following table to determine which values should be used:

    | **Variable**          | **Required?** | **Description**                                                                     | **eg. Value**                 |
    |-----------------------|-----|-----------------------------------------------------------------------------------------------|-------------------------------|
    | `cluster_type`        | yes | The type of cluster into which the toolkit will be installed                                  | `kubernetes`, `ocp3`, `ocp4` or `ocp44` |
    | `cluster_exists`      | yes | Flag indicating if the cluster already exists. (`false` means the cluster should be provisioned) | `true`          |
    | `resource_group_name` | yes | Existing resource group in the account where the cluster has been created                     | `dev-team-one`                |
    | `vpc_cluster`         | yes | Flag indicating that the cluster has been built on VPC infrastructure. Defaults to `true`     | `true` or `false`             |
    | `name_prefix`         | no  | The prefix that should be applied for any resources that are provisioned. Defaults to `{resource_group_name}` | `dev-one`     |
    | `region`              | no  | The region where the cluster has been/will be provisioned                                     | `us-east`, `eu-gb`, etc       |
    | `vpc_zone_names`      | no  | A comma-separated list of the VPC zones that should be used for worker nodes. This value is required if `cluster_exists` is set to `false` and `vpc_cluster` is set to `true` | `us-south-1` or `us-east-1,us-east-2` |
    | `cluster_name`        | no  | The name of the cluster (If `cluster_exists` is set to `true` then this name should match an existing cluster). Defaults to `{prefix_name}-cluster` or `{resource_group_name}-cluster` | `dev-team-one-iks-117-vpc` |
    | `registry_namespace`  | no  | The namespace that should be used in the IBM Container Registry. Defaults to `{resource_group_name}` | `dev-team-one-registry-2020` |
    | `provision_logdna`    | no  | Flag indicating that a new instance of LogDNA should be provisioned. Defaults to `false`      | `true` or `false`          |
    | `logdna_name`         | no  | The name of the LogDNA instance (If `provision_logdna` is set to `false` this value is used by the scripts to bind the existing LogDNA instance to the cluster) | `cntk-showcase-logdna` |
    | `provision_sysdig`    | no  | Flag indicating that a new instance of Sysdig should be provisioned. Defaults to `false`      | `true` or `false`          |
    | `sysdig_name`         | no  | The name of the Sysdig instance (If `provision_sysdig` is set to `false` this value is used by the scripts to bind the existing Sysdig instance to the cluster) | `cntk-showcase-sysdig` |

    #### B. Configure the VLAN settings

    The `vlan.tfvars` file in `terraform/settings` contains properties that define the classic infrastructure configuration in order to provision a 
    new cluster. Typical values look like this:

    ```shell script
    vlan_datacenter="dal10"
    public_vlan_id="2366011"
    private_vlan_id="2366012"
    ```

    You must set all of these specifically for your cluster. Use the values provided by the account manager.

    - `vlan_datacenter` -- The zone in the region in which the cluster worker nodes will be provisioned
    - `public_vlan_id` -- The public VLAN that the cluster will use
    - `private_vlan_id` -- The private VLAN that the cluster will use

    #### Optional: Generate the VLAN properties

    The [IGC CLI](../../reference/cli.md) can be used to generate these settings, to make the configuration as simple as possible.

    If your account has numerous VLANs and you want your cluster to use specific ones, then skip this step and provide the 
    values by hand. This tool is for users who don't know what these required settings should be and want a simple way to 
    gather reasonable defaults for their particular account.

    1. Log in using the <Globals name="igcli" />
    2. Target the region where the cluster will be provisioned with the <Globals name="igcli" />
        ```shell script
        ibmcloud target -r {region}
        ```
    2. Run the VLAN command
        ```shell script
        igc vlan
        ```
    3. Copy the output values from the CLI Command into your `vlan.tfvars` files

    #### C. (Optional) Customize the installed components

    The `terraform/stages` directory contains the default set of stages that define the
    modules that will be applied to the environment. The stages can be customized to change
    the makeup of the environment that is provisioned by either removing or adding stages from/to the 
    `terraform/stages` directory. 

    **Note:** The stages occasionally have dependencies on other stages (e.g. most all
    depend on the cluster module, many depend on the namespace module, etc.) so be aware of those
    dependencies as you start making changes. Dependencies are reflected in the `module.{stage name}` references 
    in the stage variable list.

    The `terraform/stages/catalog` directory contains some optional
    stages that are prep-configured and can be dropped into the `terraform/stages` directory. Other
    modules are available from the [Garage Terraform Modules](https://github.com/cloud-native-toolkit/garage-terraform-modules)
    catalog and can be added as stages to the directory as well. Since this is Terraform,
    any other Terraform scripts and modules can be added to the `terraform/stages` directory
    as desired.

=== "Multi-Cloud"

    #### A. Set Environment Variables

    The configuration values for provisioning the environment on an existing OpenShift cluster are set in the `environment-ocp.tfvars`
    file in the `./terraform/settings` directory of the `ibm-garage-iteration-zero` repository. There are only two values available:

    | **Variable**          | **Required?** | **Description**                                                                     | **eg. Value**                 |
    |-----------------------|-----|-----------------------------------------------------------------------------------------------|-------------------------------|
    | `server_url`          | yes | The url of the OpenShift cluster's API server                                                 | `https://api.mycluster.com`   |
    | `cluster_name`        | no  | The name of the cluster used simply for identification purposes. Defaults to `ocp-cluster`    | `dev-team-one-ocp44`          |

    #### B. (Optional) Customize the installed components

    The `terraform/stages-ocp4` directory contains the default set of stages that define the
    modules that will be applied to the environment. The stages can be customized to change
    the makeup of the environment that is provisioned by either removing or adding stages from/to the 
    `terraform/stages-ocp4` directory. 

    **Note:** The stages occasionally have dependencies on other stages (e.g. most all
    depend on the cluster module, many depend on the namespace module, etc.) so be aware of those
    dependencies as you start making changes. Dependencies are reflected in the `module.{stage name}` references 
    in the stage variable list.

    The `terraform/stages-ocp4/catalog` directory contains some optional
    stages that are prep-configured and can be dropped into the `terraform/stages-ocp4` directory. Other
    modules are available from the [Garage Terraform Modules](https://github.com/cloud-native-toolkit/garage-terraform-modules)
    catalog and can be added as stages to the directory as well. Since this is Terraform,
    any other Terraform scripts and modules can be added to the `terraform/stages-ocp4` directory
    as desired.

### D. Run the installation

1. Open a terminal to the `ibm-garage-iteration-zero` directory
2. Launch a [Developer Tools Docker container](https://github.com/cloud-native-toolkit/ibm-garage-cli-tools "Cloud Garage Tools Docker image") from which the Terraform scripts will be run

    ```shell
    ./launch.sh
    ```

    This will download the Cloud Garage Tools Docker image that contains all the necessary tools to execute Terraform scripts and exec shell into the running container. When the container starts it mounts the file system's `./terraform/` directory as `/home/devops/src/` and loads the values from the `credentials.properties` file as environment variables.

3. Apply the Terraform by running the provided `runTerraform.sh` script

    ```shell
    ./runTerraform.sh
    ```

    This script collects the values provided in the `environment-ibmcloud.tfvars` and the stages defined in the `terraform/stages` to build the Terraform workspace. Along the way it will prompt for a couple pieces of information.

    1. Type of installation: `ibmcloud` or `ocp`

        There are two major paths to installing with the Toolkit. In this case, we are installing
        into an IBM Cloud-managed environment so we will select `ibmcloud`.

        This prompt can be skipped by providing `--ibmcloud` as an argument to `./runTerraform.sh`

    2. Handling of an old workspace (if applicable): `keep` or `delete`

        If you executed the script previously for the current cluster configuration and the workspace directory still exists then you will be prompted to either keep or delete the workspace directory. Keep the workspace directory if you want to use the state from the previous run as a starting point to either add or remove configuration. Delete the workspace if you want to start with a clean install of the Toolkit.

        This prompt can be skipped by providing `--delete` or `--keep` as an argument to `./runTerraform.sh`

    3. Verify the installation configuration

        The script will verify some basic settings and prompt if you want to proceed. After you select **Y** (for yes), the Terraform Apply process will begin to create the infrastructure and services for your environment.

        This prompt can be skipped by providing `--auto-approve` as an argument to `./runTerraform.sh`

    Creating a new cluster takes about 1.5 hours on average (but can also take considerably longer) and the rest of the process takes about 30 minutes.

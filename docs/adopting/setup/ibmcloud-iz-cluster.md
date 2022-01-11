# Provision an IBM Cloud cluster using Iteration Zero scripts

<!--- cSpell:ignore tfvars igcli filesystem's cntk -->

!!!Information
    This installation method will provision the cluster if it doesn't already exist

## Install a managed cluster and the Cloud Native Toolkit using Iteration Zero

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

3. Update the value for the `ibmcloud.api.key` property in `credentials.properties` with your IBM Cloud CLI API key

    !!!Note
        The API key should have been set up during [prepare account](ibmcloud-setup.md).

### C. Configure the environment variables

The settings for creating the Cloud-Native Toolkit on IBM Cloud are set in the `environment-ibmcloud.tfvars` file in the `./terraform/settings` directory of the `ibm-garage-iteration-zero` repository.

There are a number of values that can be applied in the file, some required and some optional. Consult with the following table to determine which values should be used:

=== "VPC Infrastructure"
    | **Variable**          | **Required?** | **Description**                                                                     | **eg. Value**                 |
    |-----------------------|-----|-----------------------------------------------------------------------------------------------|-------------------------------|
    | `cluster_type`        | yes | The type of cluster into which the toolkit will be installed                                  | `kubernetes`, `ocp3`, `ocp4` or `ocp44` |
    | `cluster_exists`      | yes | Flag indicating if the cluster already exists. (`false` means the cluster should be provisioned) | `false`          |
    | `vpc_cluster`         | yes | Flag indicating that the cluster has been built on VPC infrastructure. Defaults to `true`     | `true`          |
    | `name_prefix`         | no  | The prefix that should be applied for any resources that are provisioned. Defaults to `{resource_group_name}` | `dev-one`     |
    | `cluster_name`        | no  | The name of the cluster (If `cluster_exists` is set to `true` then this name should match an existing cluster). Defaults to `{prefix_name}-cluster` or `{resource_group_name}-cluster` | `dev-team-one-iks-117-vpc` |
    | `resource_group_name` | yes | Existing resource group in the account where the cluster has been created                     | `dev-team-one`                |
    | `region`              | yes | The region where the cluster has been/will be provisioned                                     | `us-east`, `eu-gb`, etc       |
    | `vpc_zone_names`      | no  | A comma-separated list of the VPC zones that should be used for worker nodes. This value is required if `cluster_exists` is set to `false` and `vpc_cluster` is set to `true` | `us-south-1` or `us-east-1,us-east-2` |
    | `provision_logdna`    | no  | Flag indicating that a new instance of LogDNA should be provisioned. Defaults to `false`      | `true` or `false`          |
    | `logdna_name`         | no  | The name of the LogDNA instance (If `provision_logdna` is set to `false` this value is used by the scripts to bind the existing LogDNA instance to the cluster) | `cntk-showcase-logdna` |
    | `logdna_region`       | no  | The region where the existing LogDNA instance has been provisioned. If not provided will default to the cluster `region`. | `us-east` |
    | `provision_sysdig`    | no  | Flag indicating that a new instance of Sysdig should be provisioned. Defaults to `false`      | `true` or `false`          |
    | `sysdig_name`         | no  | The name of the Sysdig instance (If `provision_sysdig` is set to `false` this value is used by the scripts to bind the existing Sysdig instance to the cluster) | `cntk-showcase-sysdig` |
    | `sysdig_region`       | no  | The region where the existing Sysdig instance has been provisioned. If not provided will default to the cluster `region`. | `us-east` |
    | `cos_name`            | no  | The name of the Cloud Object Storage instance that will be used with the OCP cluster. | |
    | `registry_type`       | no  | The type of the Container Registry that will be used with the cluster. Valid values are `icr`, `ocp`, `other`, or `none`. | |
    | `registry_namespace`  | no  | The namespace that should be used in the IBM Container Registry. Defaults to `{resource_group_name}` | `dev-team-one-registry-2020` |
    | `registry_host`       | no  | The host name of the image registry (e.g. us.icr.io or quay.io). This value is only used if the registry_type is set to "other" | `quay.io` |
    | `registry_user`       | no  | The username needed to access the image registry. This value is only used if the registry_type is set to "other" | `{username}` |
    | `registry_password`   | no  | The password needed to access the image registry. This value is required if the registry_type is set to "other". | `{password}` |
    | `source_control_type` | no  | The type of source control system (github, gitlab, or none)                                                      | `github` |
    | `source_control_url`  | no  | The url to the source control system                                                                             | `https://github.com` |

    Update `environment-ibmcloud.tfvars` with the appropriate values for your installation. Particularly, be sure to set the following values in order to provision a VPC cluster:

    - `cluster_exists` to `false`
    - `vpc_cluster` to `true`

=== "Classic Infrastructure"
    | **Variable**          | **Required?** | **Description**                                                                     | **eg. Value**                 |
    |-----------------------|-----|-----------------------------------------------------------------------------------------------|-------------------------------|
    | `cluster_type`        | yes | The type of cluster into which the toolkit will be installed                                  | `kubernetes`, `ocp3`, `ocp4` or `ocp44` |
    | `cluster_exists`      | yes | Flag indicating if the cluster already exists. (`false` means the cluster should be provisioned) | `false`          |
    | `vpc_cluster`         | yes | Flag indicating that the cluster has been built on VPC infrastructure. Defaults to `true`     | `false`             |
    | `name_prefix`         | no  | The prefix that should be applied for any resources that are provisioned. Defaults to `{resource_group_name}` | `dev-one`     |
    | `cluster_name`        | no  | The name of the cluster (If `cluster_exists` is set to `true` then this name should match an existing cluster). Defaults to `{prefix_name}-cluster` or `{resource_group_name}-cluster` | `dev-team-one-iks-117-vpc` |
    | `resource_group_name` | yes | Existing resource group in the account where the cluster has been created                     | `dev-team-one`                |
    | `region`              | yes | The region where the cluster has been/will be provisioned                                     | `us-east`, `eu-gb`, etc       |
    | `provision_logdna`    | no  | Flag indicating that a new instance of LogDNA should be provisioned. Defaults to `false`      | `true` or `false`          |
    | `logdna_name`         | no  | The name of the LogDNA instance (If `provision_logdna` is set to `false` this value is used by the scripts to bind the existing LogDNA instance to the cluster) | `cntk-showcase-logdna` |
    | `logdna_region`       | no  | The region where the existing LogDNA instance has been provisioned. If not provided will default to the cluster `region`. | `us-east` |
    | `provision_sysdig`    | no  | Flag indicating that a new instance of Sysdig should be provisioned. Defaults to `false`      | `true` or `false`          |
    | `sysdig_name`         | no  | The name of the Sysdig instance (If `provision_sysdig` is set to `false` this value is used by the scripts to bind the existing Sysdig instance to the cluster) | `cntk-showcase-sysdig` |
    | `sysdig_region`       | no  | The region where the existing Sysdig instance has been provisioned. If not provided will default to the cluster `region`. | `us-east` |
    | `cos_name`            | no  | The name of the Cloud Object Storage instance that will be used with the OCP cluster. | |
    | `registry_type`       | no  | The type of the Container Registry that will be used with the cluster. Valid values are `icr`, `ocp`, `other`, or `none`. | |
    | `registry_namespace`  | no  | The namespace that should be used in the IBM Container Registry. Defaults to `{resource_group_name}` | `dev-team-one-registry-2020` |
    | `registry_host`       | no  | The host name of the image registry (e.g. us.icr.io or quay.io). This value is only used if the registry_type is set to "other" | `quay.io` |
    | `registry_user`       | no  | The username needed to access the image registry. This value is only used if the registry_type is set to "other" | `{username}` |
    | `registry_password`   | no  | The password needed to access the image registry. This value is required if the registry_type is set to "other". | `{password}` |
    | `source_control_type` | no  | The type of source control system (github, gitlab, or none)                                                      | `github` |
    | `source_control_url`  | no  | The url to the source control system                                                                             | `https://github.com` |

    #### Configure the VLAN settings

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

### D. (Optional) Customize the installed components

The `terraform/stages` directory contains the default set of stages that define the
modules that will be applied to the environment. The stages can be customized to change
the makeup of the environment that is provisioned by either removing or adding stages from/to the
`terraform/stages` directory.

!!!Note
    The stages occasionally have dependencies on other stages (e.g. most all depend on the cluster module, many depend on the namespace module, etc.) so be aware of those dependencies as you start making changes. Dependencies are reflected in the `module.{stage name}` references in the stage variable list.

The `terraform/stages/catalog` directory contains some optional
stages that are prep-configured and can be dropped into the `terraform/stages` directory. Other
modules are available from the [Garage Terraform Modules](https://github.com/cloud-native-toolkit/garage-terraform-modules) catalog and can be added as stages to the directory as well. Since this is Terraform, any other Terraform scripts and modules can be added to the `terraform/stages` directory
as desired.

### E. Run the installation

1. Open a terminal to the `ibm-garage-iteration-zero` directory
2. Launch a [Developer Tools Docker container](https://github.com/cloud-native-toolkit/ibm-garage-cli-tools "Cloud Garage Tools Docker image") from which the Terraform scripts will be run

    ```shell
    ./launch.sh
    ```

    This will download the Cloud Garage Tools Docker image that contains all the necessary tools to execute Terraform scripts and exec shell into the running container. When the container starts it mounts the filesystem's `./terraform/` directory as `/home/devops/src/` and loads the values from the `credentials.properties` file as environment variables.

3. Apply the Terraform by running the provided `runTerraform.sh` script

    ```shell
    ./runTerraform.sh
    ```

    This script collects the values provided in the `environment-ibmcloud.tfvars` and the stages defined in the `terraform/stages` to build the Terraform workspace. Along the way it will prompt for a couple pieces of information.

    1. Type of installation: `cluster`
        This prompt can be skipped by providing `--cluster` as an argument to `./runTerraform.sh`

    2. Handling of an old workspace (if applicable): `keep` or `delete`
        If you executed the script previously for the current cluster configuration and the workspace directory still exists then you will be prompted to either keep or delete the workspace directory. Keep the workspace directory if you want to use the state from the previous run as a starting point to either add or remove configuration. Delete the workspace if you want to start with a clean install of the Toolkit.

        This prompt can be skipped by providing `--delete` or `--keep` as an argument to `./runTerraform.sh`

    3. Verify the installation configuration

        The script will verify some basic settings and prompt if you want to proceed. After you select **Y** (for yes), the Terraform Apply process will begin to create the infrastructure and services for your environment.

        This prompt can be skipped by providing `--auto-approve` as an argument to `./runTerraform.sh`

    Creating a new cluster takes about 1.5 hours on average (but can also take considerably longer) and the rest of the process takes about 30 minutes.

## Troubleshooting

If you find that the Terraform provisioning has failed, for Private Catalog delete the workspace and for Iteration Zero  try re-running the `runTerraform.sh` script again.
The state will be saved and Terraform will try and apply the configuration to match the desired end state.

If you find that some of the services have failed to create in the time allocated, try the following with Iteration zero:

1. Manually delete the service instances in your resource group
2. Re-run the `runTerraform.sh` script with the `--delete` argument to clean up the state

    ```shell
    ./runTerraform.sh --delete
    ```

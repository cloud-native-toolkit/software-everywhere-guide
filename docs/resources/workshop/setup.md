# Setup Workshop Environment

<!--- cSpell:ignore CSPLAB -->

Provides the steps to install the Cloud-Native Toolkit and setting up the  Cloud-Native Toolkit Workshop hands on labs.

<iframe width="100%" height="500" src="https://www.youtube-nocookie.com/embed/aFSt5cW9TlI" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

## 1. Create OpenShift Cluster

Create an OpenShift Cluster for example:

- The 8 hours free Cluster on [IBM Open Labs](https://developer.ibm.com/openlabs/openshift) select lab 6 `Bring Your Own Application`
- Deploy a Cluster on IBM Cloud VPC2 using the [Toolkit](../../adopting/setup/ibmcloud-tile-cluster.md)
- On other Clouds using docs from [cloudnativetoolkit.dev/multi-cloud](../../adopting/setup/provision-cluster.md)
- IBM internal DTE Infrastructure access via [IBM VPN](https://ccp-ui.csplab.intranet.ibm.com/) or [IBM CSPLAB](https://ccp-ui.apps.labprod.ocp.csplab.local/)

## 2. Install IBM Cloud Native Toolkit

- Use one of the install options for example the [Quick Install](../../setup/fast-start.md)

    ```shell
    curl -sfL get.cloudnativetoolkit.dev | sh -
    ```

## 3. Setup IBM Cloud Native Toolkit Workshop

- Install the foundation for the workshops

    ```shell
    curl -sfL workshop.cloudnativetoolkit.dev | sh -
    ```

    !!!Note
      - The username and password for Git Admin is `toolkit` `toolkit`
      - Usernames `user01` through `user15` are configured with a password of `password`.
      - Username `userdemo` is configured with the password `password`. You can use this username if using the workshop environment
        for self study or giving a demo.  If you are preparing the environment for a workshop you can remove `userdemo`
    b   y running the `uninstall-userdemo.sh` script which is part of the [workshop](https://github.com/cloud-native-toolkit/cloud-native-toolkit-workshop) scripts.

## 4. (Optional) Customization of the IBM Cloud Native Toolkit Workshop

- You can customize the Workshop environment by cloning the [workshop](https://github.com/cloud-native-toolkit/cloud-native-toolkit-workshop) repo

- Some of the most common customizations are:

  - You can create more than 15 users by setting a `USER_COUNT` environment variable. For example to configure 30 users use the command
      ```bash
      export USER_COUNT=30
      ```

  - You can create more than 15 projects by setting a `PROJECT_COUNT` environment variable. For example to configure 30 projects use the command
      ```bash
      export PROJECT_COUNT=30
      ```

- Once you have finished configuring your customizations, login to the cluster from the cli and run the `scripts/install.sh` script to perform the install.

- You can also add additional users to the workshop clusters.
    - Create a file with one user id per line.
    **IMPORTANT: there needs to be newline after the last entry.**
    For example a `users.txt` file with content.
      ```bash
      additionaluserID
      anotheruserID
      someuserID

      ```

    !!! note ""
        For Openshift clusters on IBM Cloud (ROKS) the user ids are their IBM IDs (email address) all lowercase with an uppercase `IAM#` prefix added to the beginning.
        ```bash
        IAM#additionaluserid@email.com
        IAM#anotheruserid@email.com
        IAM#someuserid@email.com

        ```

      - Create a `ADDITIONAL_USERS_FILE` environment variable with the path and name of the file.
        ```bash
        export ADDITIONAL_USERS_FILE=users.txt
        ```
      - The additional users will be granted the `self-provisioner` role, meaning they can create new Openshift Projects.
        If you wish to remove this permission set an environment
      variable `ADDITIONAL_USERS_SELF_PROVISIONER` with a value of `N`
        ```bash
        export ADDITIONAL_USERS_SELF_PROVISIONER=N
        ```

  - Once you have finished configuring the additional users, login to the cluster from the cli and run the `scripts/13-ocp-additional-users.sh` script.



